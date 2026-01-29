import 'dart:async';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart' show Value;
import '../database/app_database.dart';
import 'location_service.dart';
import 'geofence_service.dart';

/// Dua with its location information
class DuaWithLocation {
  final Dua dua;
  final GeofenceLocation location;

  DuaWithLocation({required this.dua, required this.location});
}

/// Guidance event for UI display
class GuidanceEvent {
  final GeofenceLocation location;
  final List<DuaWithLocation> duasWithLocations;
  final bool audioEnabled;
  final bool hapticsEnabled;
  final DateTime timestamp;

  GuidanceEvent({
    required this.location,
    required this.duasWithLocations,
    required this.audioEnabled,
    required this.hapticsEnabled,
    required this.timestamp,
  });
}

/// Main ritual guidance orchestrator
/// Combines location tracking, geofencing, and dua display
class RitualGuidanceService {
  final AppDatabase _database;
  final GeofenceService _geofenceService;

  StreamController<GuidanceEvent>? _guidanceController;
  StreamSubscription<GeofenceEvent>? _geofenceSub;
  RitualSetting? _currentSettings;
  bool _isActive = false;

  RitualGuidanceService(
    this._database,
    LocationService locationService,
    this._geofenceService,
  );

  Stream<GuidanceEvent> get guidanceEvents => _guidanceController!.stream;
  bool get isActive => _isActive;

  /// Start ritual guidance for selected type
  Future<bool> startGuidance({required String ritualType}) async {
    if (_isActive) return true;

    // Load user settings
    _currentSettings = await _database.getRitualSettings();

    // Create default settings if none exist
    if (_currentSettings == null) {
      await _database.saveRitualSettings(
        RitualSettingsCompanion.insert(
          ritualType: ritualType,
          selectedRitual: 'tawaf', // Default ritual
          audioEnabled: const Value(true),
          hapticEnabled: const Value(true),
          audioVolume: const Value(80),
        ),
      );
      _currentSettings = await _database.getRitualSettings();
    }

    // Start geofence monitoring - load ALL locations
    final started = await _geofenceService.startMonitoring(
      ritualName: null, // null = all locations
    );

    if (!started) return false;

    _guidanceController = StreamController<GuidanceEvent>.broadcast();

    // Listen for geofence events
    _geofenceSub = _geofenceService.geofenceEvents.listen((event) {
      if (event.isInside) {
        _handleLocationEntry(event);
      }
    });

    _isActive = true;
    return true;
  }

  /// Handle entering a holy site
  Future<void> _handleLocationEntry(GeofenceEvent event) async {
    // Get ALL locations user is currently inside
    final currentLocationIds = _geofenceService.getCurrentLocations();

    // Collect duas with their location info from ALL active geofences
    final allDuasWithLocations = <DuaWithLocation>[];

    for (final locationId in currentLocationIds) {
      final location = await _database.getLocationById(locationId);
      if (location != null) {
        final duas = await _database.getDuasForLocation(
          locationId,
          _currentSettings?.ritualType ?? 'self',
        );

        // Pair each dua with its location
        for (final dua in duas) {
          allDuasWithLocations.add(
            DuaWithLocation(dua: dua, location: location),
          );
        }
      }
    }

    if (allDuasWithLocations.isEmpty) return;

    // Trigger haptic feedback if enabled (only once)
    if (_currentSettings?.hapticEnabled ?? false) {
      _triggerHapticPattern(event.location.ritualName);
    }

    // Emit guidance event with ALL duas from ALL nearby locations
    _guidanceController?.add(
      GuidanceEvent(
        location: event.location, // Primary location that triggered
        duasWithLocations:
            allDuasWithLocations, // All duas with their locations
        audioEnabled: _currentSettings?.audioEnabled ?? false,
        hapticsEnabled: _currentSettings?.hapticEnabled ?? false,
        timestamp: DateTime.now(),
      ),
    );
  }

  /// Trigger distinct vibration patterns for different locations
  void _triggerHapticPattern(String ritualName) {
    switch (ritualName) {
      case 'tawaf':
        // Two short pulses for Tawaf
        HapticFeedback.mediumImpact();
        Future.delayed(const Duration(milliseconds: 200), () {
          HapticFeedback.mediumImpact();
        });
        break;
      case 'sai':
        // Three short pulses for Sa'i
        HapticFeedback.lightImpact();
        Future.delayed(const Duration(milliseconds: 150), () {
          HapticFeedback.lightImpact();
          Future.delayed(const Duration(milliseconds: 150), () {
            HapticFeedback.lightImpact();
          });
        });
        break;
      default:
        // Single pulse for general locations
        HapticFeedback.heavyImpact();
    }
  }

  /// Map ritual type to database ritual name
  String _getRitualNameFromType(String type) {
    // Return null to load ALL locations regardless of ritual
    // This allows showing nearby duas for any location
    return type.toLowerCase(); // Maps 'self' or 'proxy' to ritual names
  }

  /// Update ritual settings
  Future<void> updateSettings({
    bool? audioEnabled,
    bool? hapticEnabled,
    int? audioVolume,
  }) async {
    if (_currentSettings == null) return;

    await _database.saveRitualSettings(
      RitualSettingsCompanion.insert(
        ritualType: _currentSettings!.ritualType,
        selectedRitual: _currentSettings!.selectedRitual,
        audioEnabled: Value(audioEnabled ?? _currentSettings!.audioEnabled),
        hapticEnabled: Value(hapticEnabled ?? _currentSettings!.hapticEnabled),
        audioVolume: Value(audioVolume ?? _currentSettings!.audioVolume),
      ),
    );

    // Reload settings
    _currentSettings = await _database.getRitualSettings();
  }

  /// Get current ritual settings
  Future<RitualSetting?> getCurrentSettings() => _database.getRitualSettings();

  /// Stop guidance
  Future<void> stopGuidance() async {
    await _geofenceSub?.cancel();
    await _guidanceController?.close();
    await _geofenceService.stopMonitoring();
    _geofenceSub = null;
    _guidanceController = null;
    _isActive = false;
  }

  void dispose() {
    stopGuidance();
  }
}
