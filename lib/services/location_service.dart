import 'dart:async';
import 'package:geolocator/geolocator.dart';

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
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Start continuous GPS tracking with high accuracy
  Future<bool> startTracking() async {
    if (_isTracking) return true;

    final hasPermission = await checkPermissions();
    if (!hasPermission) return false;

    _positionController = StreamController<Position>.broadcast();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high, // ±10 meters
      distanceFilter: 5, // Update every 5 meters
    );

    _positionStreamSub =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
            _positionController?.add(position);
          },
          onError: (error) {
            _positionController?.addError(error);
          },
        );

    _isTracking = true;
    return true;
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
