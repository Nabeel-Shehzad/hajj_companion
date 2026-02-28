import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// GPS tracking service for ritual guidance
/// Requirements: FR-05 - ±10 meter accuracy
class LocationService {
  StreamController<Position>? _positionController;
  StreamSubscription<Position>? _positionStreamSub;
  bool _isTracking = false;

  Stream<Position> get positionStream => _positionController!.stream;
  bool get isTracking => _isTracking;

  /// Check and request location permissions
  Future<bool> checkPermissions() async {
    try {
      // Use permission_handler for explicit permission request
      // This is more reliable on WearOS
      var status = await ph.Permission.location.status;

      print('Current location permission status: $status');

      if (status.isDenied) {
        print('Requesting location permission...');
        status = await ph.Permission.location.request();
        print('Permission request result: $status');
      }

      if (status.isPermanentlyDenied) {
        print('Location permission permanently denied');
        return false;
      }

      if (status.isDenied) {
        print('Location permission denied');
        return false;
      }

      print('Location permission granted!');
      return true;
    } catch (e) {
      print('Error checking permissions: $e');
      // Handle WearOS or platform-specific errors
      return false;
    }
  }

  /// Start continuous GPS tracking with high accuracy
  Future<bool> startTracking() async {
    if (_isTracking) {
      print('LocationService: Already tracking');
      return true;
    }

    try {
      print('LocationService: Checking permissions before starting...');
      final hasPermission = await checkPermissions();
      if (!hasPermission) {
        print('LocationService: No permission, cannot start tracking');
        return false;
      }

      print('LocationService: Creating position controller...');
      _positionController = StreamController<Position>.broadcast();

      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high, // ±10 meters
        distanceFilter: 5, // Update every 5 meters
      );

      print('LocationService: Starting position stream...');
      _positionStreamSub =
          Geolocator.getPositionStream(
            locationSettings: locationSettings,
          ).listen(
            (Position position) {
              print(
                'LocationService: Got position: ${position.latitude}, ${position.longitude}',
              );
              _positionController?.add(position);
            },
            onError: (error) {
              print('LocationService: Position stream error: $error');
              // Don't propagate error to avoid crashes - just log it
              // UI will handle timeout for no position data
            },
            cancelOnError: false, // Keep trying even after errors
          );

      _isTracking = true;
      print('LocationService: Tracking started successfully');
      return true;
    } catch (e) {
      print('LocationService: Error starting tracking: $e');
      // Handle WearOS or platform-specific errors
      return false;
    }
  }

  /// Stop GPS tracking to save battery
  Future<void> stopTracking() async {
    await _positionStreamSub?.cancel();
    await _positionController?.close();
    _positionStreamSub = null;
    _positionController = null;
    _isTracking = false;
  }

  /// Get current location once (for one-time checks)
  Future<Position?> getCurrentLocation() async {
    final hasPermission = await checkPermissions();
    if (!hasPermission) return null;

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
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
  }
}
