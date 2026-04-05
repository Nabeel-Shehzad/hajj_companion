import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// GPS tracking service for ritual guidance
/// Requirements: FR-05 - ±10 meter accuracy
class LocationService {
  // Initialized eagerly so callers can subscribe BEFORE startTracking() is
  // called and not miss any errors emitted during geolocator startup.
  final StreamController<Position> _positionController =
      StreamController<Position>.broadcast();
  StreamSubscription<Position>? _positionStreamSub;
  bool _isTracking = false;

  Stream<Position> get positionStream => _positionController.stream;
  bool get isTracking => _isTracking;

  /// Check and request location permissions
  Future<bool> checkPermissions() async {
    try {
      // Use permission_handler for explicit permission request
      // This is more reliable on WearOS
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
          : const LocationSettings(
              accuracy: LocationAccuracy.high,
              distanceFilter: 5,
            );

      _positionStreamSub =
          Geolocator.getPositionStream(
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
    // Do NOT close _positionController — it is reused if tracking restarts.
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
