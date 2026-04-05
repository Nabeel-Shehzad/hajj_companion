import 'dart:async';
import 'package:geolocator/geolocator.dart';
import '../database/app_database.dart';
import 'location_service.dart';

/// Detected geofence event
class GeofenceEvent {
  final GeofenceLocation location;
  final double distanceMeters;
  final bool isInside;
  final DateTime timestamp;

  GeofenceEvent({
    required this.location,
    required this.distanceMeters,
    required this.isInside,
    required this.timestamp,
  });
}

/// Geofencing service for holy site detection
/// Requirements: FR-06 - Detect entrance to predefined areas
class GeofenceService {
  final AppDatabase _database;
  final LocationService _locationService;

  StreamController<GeofenceEvent>? _geofenceController;
  StreamSubscription<Position>? _locationSub;
  final Map<String, bool> _insideGeofences = {};
  List<GeofenceLocation> _activeLocations = [];
  bool _isMonitoring = false;

  GeofenceService(this._database, this._locationService);

  Stream<GeofenceEvent> get geofenceEvents => _geofenceController!.stream;
  bool get isMonitoring => _isMonitoring;

  /// Start monitoring geofences for a specific ritual
  Future<bool> startMonitoring({String? ritualName}) async {
    if (_isMonitoring) return true;

    // Load active geofence locations
    if (ritualName != null) {
      _activeLocations = await _database.getLocationsByRitual(ritualName);
    } else {
      _activeLocations = await _database.getAllLocations();
    }

    if (_activeLocations.isEmpty) {
      return false;
    }

    // Initialize tracking state
    for (final location in _activeLocations) {
      _insideGeofences[location.locationId] = false;
    }

    // Start location tracking if not already
    final started = await _locationService.startTracking();
    if (!started) return false;

    _geofenceController = StreamController<GeofenceEvent>.broadcast();

    // Listen to location updates
    _locationSub = _locationService.positionStream.listen(
      (position) {
        _checkGeofences(position);
      },
      onError: (error) {
        // Position stream errors (e.g. location service disabled) are handled
        // by the UI layer. Swallow here to prevent unhandled exception crash.
      },
      cancelOnError: false,
    );

    _isMonitoring = true;
    return true;
  }

  /// Check all geofences against current position
  void _checkGeofences(Position currentPosition) {
    for (final location in _activeLocations) {
      final distance = _locationService.calculateDistance(
        currentPosition.latitude,
        currentPosition.longitude,
        location.latitude,
        location.longitude,
      );

      final wasInside = _insideGeofences[location.locationId] ?? false;
      final isInsideNow = distance <= location.radiusMeters;

      // Trigger event only on state change (enter/exit)
      if (!wasInside && isInsideNow) {
        // Entered geofence
        _insideGeofences[location.locationId] = true;
        _geofenceController?.add(
          GeofenceEvent(
            location: location,
            distanceMeters: distance,
            isInside: true,
            timestamp: DateTime.now(),
          ),
        );
      } else if (wasInside && !isInsideNow) {
        // Exited geofence
        _insideGeofences[location.locationId] = false;
        _geofenceController?.add(
          GeofenceEvent(
            location: location,
            distanceMeters: distance,
            isInside: false,
            timestamp: DateTime.now(),
          ),
        );
      }
    }
  }

  /// Get current distance to a specific location
  Future<double?> getDistanceToLocation(String locationId) async {
    final currentPos = await _locationService.getCurrentLocation();
    if (currentPos == null) return null;

    final location = await _database.getLocationById(locationId);
    if (location == null) return null;

    return _locationService.calculateDistance(
      currentPos.latitude,
      currentPos.longitude,
      location.latitude,
      location.longitude,
    );
  }

  /// Check if currently inside a specific geofence
  bool isInsideGeofence(String locationId) {
    return _insideGeofences[locationId] ?? false;
  }

  /// Get all locations user is currently inside
  List<String> getCurrentLocations() {
    return _insideGeofences.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
  }

  /// Stop monitoring geofences
  Future<void> stopMonitoring() async {
    await _locationSub?.cancel();
    await _geofenceController?.close();
    _locationSub = null;
    _geofenceController = null;
    _insideGeofences.clear();
    _activeLocations.clear();
    _isMonitoring = false;
  }

  void dispose() {
    stopMonitoring();
  }
}
