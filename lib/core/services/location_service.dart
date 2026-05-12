import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// GPS tracking service for ritual guidance
class LocationService {
  // We use a StreamController to broadcast location updates to multiple listeners (screens).
  final StreamController<Position> _positionController =
      StreamController<Position>.broadcast();
      // We use a broadcast stream so multiple screens can listen to location updates
  StreamSubscription<Position>? _positionStreamSub;// We keep the subscription so we can cancel it when stopping tracking
  bool _isTracking = false;


// Expose the position stream for listeners (e.g. screens) to subscribe to
  Stream<Position> get positionStream => _positionController.stream;
  //Provides the position stream to other classes.
  bool get isTracking => _isTracking;//return tracking status

  /// Check and request location permissions
  Future<bool> checkPermissions() async {
    try {
     
      var status = await ph.Permission.location.status;

      if (status.isDenied) {
        status = await ph.Permission.location.request();
      }

      if (status.isPermanentlyDenied || status.isDenied) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('LocationService: Error checking permissions: $e');
      return false;
    }
  }

  /// Start continuous GPS tracking with high accuracy
  Future<bool> startTracking() async {
    if (_isTracking) return true;

    try {
      final hasPermission = await checkPermissions();
      if (!hasPermission) return false;

      // _positionController already exists — do not recreate it.

      // Use AndroidSettings with forceLocationManager=true on Android.
      // This bypasses the Fused Location Provider (Google Play Services) and
      // uses the standard Android LocationManager directly — required for
      // WearOS where the Fused Location Provider throws "not implemented".
      final locationSettings = Platform.isAndroid
          ? AndroidSettings(
              accuracy: LocationAccuracy.high, // ±10 meters
              distanceFilter: 5, // Update every 5 meters
              forceLocationManager: true,
            )
          : const LocationSettings(// iOS and others
              accuracy: LocationAccuracy.high,
              distanceFilter: 5,
            );

      _positionStreamSub =
          Geolocator.getPositionStream(
            //geolocator package provides a stream of location updates based on the specified settings.
            locationSettings: locationSettings,
          ).listen(
            (Position position) {
              _positionController.add(position);
            },
            onError: (error) {
              // Forward the error so screens can react (e.g. location service disabled)
              _positionController.addError(error);
            },
            cancelOnError: false,
          );

      _isTracking = true;
      return true;
    } catch (e) {
      debugPrint('LocationService: Error starting tracking: $e');
      return false;
    }
  }

  /// Stop GPS tracking to save battery
  Future<void> stopTracking() async {
    await _positionStreamSub?.cancel();
    _positionStreamSub = null;
    _isTracking = false;
    
  }

  /// Get current location once (for one-time checks)
  Future<Position?> getCurrentLocation() async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: Platform.isAndroid,
      );
    } catch (e) {
      return null;
    }
  }

  /// Calculate distance between two points in meters
  double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    return Geolocator.distanceBetween(lat1, lon1, lat2, lon2);
  }

  void dispose() {
    stopTracking();
    _positionController.close();
  }
}
