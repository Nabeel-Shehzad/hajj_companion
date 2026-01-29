import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import '../../database/app_database.dart';
import '../../services/location_service.dart';
import '../../services/geofence_service.dart';
import '../../services/ritual_guidance_service.dart';
import '../../services/audio_service.dart';

class LocationTrackingScreen extends StatefulWidget {
  final String ritualType;
  final String selectedRitual;

  const LocationTrackingScreen({
    super.key,
    required this.ritualType,
    required this.selectedRitual,
  });

  @override
  State<LocationTrackingScreen> createState() => _LocationTrackingScreenState();
}

class _LocationTrackingScreenState extends State<LocationTrackingScreen> {
  late final AppDatabase _database;
  late final LocationService _locationService;
  late final GeofenceService _geofenceService;
  late final RitualGuidanceService _guidanceService;
  late final AudioService _audioService;

  StreamSubscription<GuidanceEvent>? _guidanceSub;
  StreamSubscription<Position>? _positionSub;

  bool _isTracking = false;
  bool _hasPermission = false;
  Position? _currentPosition;
  GeofenceLocation? _currentLocation;
  List<DuaWithLocation> _currentDuas = [];
  RitualSetting? _settings;
  String? _currentlyPlayingDuaId;

  @override
  void initState() {
    super.initState();
    _database = AppDatabase();
    _locationService = LocationService();
    _geofenceService = GeofenceService(_database, _locationService);
    _guidanceService = RitualGuidanceService(
      _database,
      _locationService,
      _geofenceService,
    );
    _audioService = AudioService();
    _initTracking();
  }

  Future<void> _initTracking() async {
    // Check location permissions
    _hasPermission = await _locationService.checkPermissions();
    if (!_hasPermission) {
      if (mounted) {
        _showPermissionDialog();
      }
      return;
    }

    // Load settings
    _settings = await _database.getRitualSettings();

    // Start guidance
    final started = await _guidanceService.startGuidance(
      ritualType: widget.ritualType,
    );

    if (started) {
      setState(() => _isTracking = true);

      // Listen to position updates
      _positionSub = _locationService.positionStream.listen((position) {
        setState(() => _currentPosition = position);
      });

      // Listen to guidance events
      _guidanceSub = _guidanceService.guidanceEvents.listen((event) {
        setState(() {
          _currentLocation = event.location;
          _currentDuas = event.duasWithLocations;
        });
      });
    }
  }

  void _showPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs location access to provide ritual guidance. Please enable location services.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Go Back'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await Geolocator.openLocationSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildDuaCard(DuaWithLocation duaWithLocation) {
    final dua = duaWithLocation.dua;
    final location = duaWithLocation.location;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Location Header
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.place, size: 20, color: Colors.green.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          location.nameEn,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade900,
                          ),
                        ),
                        Text(
                          location.nameAr,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Arabic Dua Text
            Text(
              dua.arabicText,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.8,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),

            // English Translation
            Text(
              dua.englishTranslation,
              style: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),

            // Transliteration (if available)
            if (dua.transliteration != null) ...[
              const SizedBox(height: 8),
              Text(
                dua.transliteration!,
                style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
              ),
            ],

            const SizedBox(height: 16),

            // Audio Controls
            Row(
              children: [
                // Play Arabic Button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      if (_currentlyPlayingDuaId == '${dua.id}_ar') {
                        await _audioService.stop();
                        setState(() => _currentlyPlayingDuaId = null);
                      } else {
                        await _audioService.playDua(dua.arabicText);
                        setState(() => _currentlyPlayingDuaId = '${dua.id}_ar');
                      }
                    },
                    icon: Icon(
                      _currentlyPlayingDuaId == '${dua.id}_ar'
                          ? Icons.stop
                          : Icons.play_arrow,
                      size: 18,
                    ),
                    label: Text(
                      _currentlyPlayingDuaId == '${dua.id}_ar'
                          ? 'Stop'
                          : 'Arabic',
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Play Translation Button
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      if (_currentlyPlayingDuaId == '${dua.id}_en') {
                        await _audioService.stop();
                        setState(() => _currentlyPlayingDuaId = null);
                      } else {
                        await _audioService.playTranslation(
                          dua.englishTranslation,
                        );
                        setState(() => _currentlyPlayingDuaId = '${dua.id}_en');
                      }
                    },
                    icon: Icon(
                      _currentlyPlayingDuaId == '${dua.id}_en'
                          ? Icons.stop
                          : Icons.volume_up,
                      size: 18,
                    ),
                    label: Text(
                      _currentlyPlayingDuaId == '${dua.id}_en'
                          ? 'Stop'
                          : 'English',
                      style: const TextStyle(fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _guidanceSub?.cancel();
    _positionSub?.cancel();
    _guidanceService.dispose();
    _geofenceService.dispose();
    _locationService.dispose();
    _audioService.dispose();
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location Tracking'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_isTracking ? Icons.pause : Icons.play_arrow),
            onPressed: _toggleTracking,
          ),
        ],
      ),
      body: !_hasPermission ? _buildPermissionDenied() : _buildTrackingView(),
    );
  }

  Widget _buildPermissionDenied() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 80, color: Colors.red.shade300),
            const SizedBox(height: 24),
            const Text(
              'Location Permission Required',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Please enable location services to use ritual guidance.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await Geolocator.openLocationSettings();
              },
              icon: const Icon(Icons.settings),
              label: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackingView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Status Card
          Card(
            color: _isTracking ? Colors.green.shade50 : Colors.grey.shade100,
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Icon(
                    _isTracking ? Icons.gps_fixed : Icons.gps_off,
                    size: 48,
                    color: _isTracking ? Colors.green : Colors.grey,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isTracking ? 'Tracking Active' : 'Tracking Paused',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _isTracking
                          ? Colors.green.shade800
                          : Colors.grey.shade700,
                    ),
                  ),
                  if (_currentPosition != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Accuracy: ±${_currentPosition!.accuracy.toStringAsFixed(1)}m',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Current Location Card
          if (_currentLocation != null) ...[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.place,
                          color: Colors.green.shade700,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Current Location',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _currentLocation!.nameEn,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currentLocation!.nameAr,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentLocation!.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Duas Card
          if (_currentDuas.isNotEmpty) ...[
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.menu_book,
                          color: Colors.green.shade700,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Duas for This Location',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ..._currentDuas.map(_buildDuaCard),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Coordinates Card
          if (_currentPosition != null) ...[
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GPS Coordinates',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Lat: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      'Lon: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Settings Card
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guidance Settings',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  SwitchListTile(
                    title: const Text('Audio Guidance'),
                    value: _settings?.audioEnabled ?? true,
                    onChanged: (value) async {
                      await _guidanceService.updateSettings(
                        audioEnabled: value,
                      );
                      setState(() {
                        _settings = _settings?.copyWith(audioEnabled: value);
                      });
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Haptic Feedback'),
                    value: _settings?.hapticEnabled ?? true,
                    onChanged: (value) async {
                      await _guidanceService.updateSettings(
                        hapticEnabled: value,
                      );
                      setState(() {
                        _settings = _settings?.copyWith(hapticEnabled: value);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleTracking() async {
    if (_isTracking) {
      await _guidanceService.stopGuidance();
      setState(() => _isTracking = false);
    } else {
      final started = await _guidanceService.startGuidance(
        ritualType: widget.ritualType,
      );
      if (started) {
        setState(() => _isTracking = true);
      }
    }
  }
}
