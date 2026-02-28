import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_companion/core/database/app_database.dart';
import 'package:hajj_companion/core/services/location_service.dart';
import 'package:hajj_companion/core/services/geofence_service.dart';
import 'package:hajj_companion/core/services/ritual_guidance_service.dart';

class WearRitualScreen extends StatefulWidget {
  const WearRitualScreen({super.key});

  @override
  State<WearRitualScreen> createState() => _WearRitualScreenState();
}

class _WearRitualScreenState extends State<WearRitualScreen> {
  final _database = AppDatabase.instance;
  late final LocationService _locationService;
  late final GeofenceService _geofenceService;
  late final RitualGuidanceService _guidanceService;

  bool _isTracking = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _currentLocation = 'Acquiring GPS signal...';
  List<DuaWithLocation> _currentDuas = [];
  bool _hasReceivedPosition = false;

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _geofenceService = GeofenceService(_database, _locationService);
    _guidanceService = RitualGuidanceService(
      _database,
      _locationService,
      _geofenceService,
    );
    _requestPermissionsAndStart();
  }

  Future<void> _requestPermissionsAndStart() async {
    print('WearRitualScreen: Requesting permissions...');

    // First check and request permissions
    final hasPermission = await _locationService.checkPermissions();

    print('WearRitualScreen: Permission result: $hasPermission');

    if (!hasPermission) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'Location permission required. Please enable location access in settings.';
        });
      }
      return;
    }

    print('WearRitualScreen: Permissions granted, starting tracking...');
    // Permissions granted, start tracking
    _startTracking();
  }

  Future<void> _startTracking() async {
    try {
      print('WearRitualScreen: Calling startGuidance...');
      final started = await _guidanceService.startGuidance(ritualType: 'self');

      print('WearRitualScreen: startGuidance result: $started');

      if (started) {
        setState(() => _isTracking = true);

        // Listen for guidance events
        _guidanceService.guidanceEvents.listen(
          (event) {
            if (mounted) {
              print(
                'WearRitualScreen: Received guidance event for ${event.location.nameEn}',
              );
              setState(() {
                _hasReceivedPosition = true;
                _currentLocation = event.location.nameEn;
                _currentDuas = event.duasWithLocations;
              });

              // Trigger haptic feedback
              HapticFeedback.mediumImpact();
            }
          },
          onError: (error) {
            print('WearRitualScreen: Guidance stream error: $error');
            // Handle location service errors gracefully
            if (mounted && error.toString().contains('disabled')) {
              setState(() {
                _hasError = true;
                _errorMessage = 'Location service is disabled';
              });
            }
          },
        );

        // Set a timeout to check if we're receiving location data
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted && _isTracking && !_hasReceivedPosition) {
            print('WearRitualScreen: No GPS signal after 5 seconds');
          }
        });
      } else {
        print('WearRitualScreen: Failed to start guidance');
        setState(() {
          _hasError = true;
          _errorMessage = 'Could not start GPS tracking. Check permissions.';
        });
      }
    } catch (e) {
      // Handle GPS errors
      print('WearRitualScreen: Error starting tracking: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          if (e.toString().contains('disabled')) {
            _errorMessage =
                'Location service is disabled. Enable it in Settings.';
          } else {
            _errorMessage = 'GPS error: ${e.toString()}';
          }
        });
      }
    }
  }

  @override
  void dispose() {
    try {
      _guidanceService.dispose();
    } catch (e) {
      // Ignore disposal errors
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isRound = screenSize.width == screenSize.height;

    return Scaffold(
      appBar: AppBar(title: const Text('Ritual Guide'), centerTitle: true),
      body: SafeArea(
        child: _hasError
            ? _buildErrorView(isRound)
            : (_isTracking ? _buildTrackingView(isRound) : _buildLoadingView()),
      ),
    );
  }

  Widget _buildErrorView(bool isRound) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isRound ? 20.0 : 14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: 40,
              color: Colors.orange.withOpacity(0.7),
            ),
            const SizedBox(height: 12),
            Text(
              'GPS Not Available',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage.contains('disabled')
                  ? 'Enable Location in Settings → Location'
                  : 'Make sure location permissions are granted.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.5),
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, size: 14),
                  label: const Text('Back', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B4513),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _hasError = false;
                      _errorMessage = '';
                    });
                    _requestPermissionsAndStart();
                  },
                  icon: const Icon(Icons.refresh, size: 14),
                  label: const Text('Retry', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A651),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
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

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Color(0xFF00A651)),
          SizedBox(height: 16),
          Text('Starting GPS...', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildTrackingView(bool isRound) {
    return Column(
      children: [
        // Location Header
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFF006B3E).withOpacity(0.3),
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFF006B3E).withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.navigation,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _currentLocation,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),

        // Duas List
        Expanded(
          child: _currentDuas.isEmpty
              ? _buildWaitingView(isRound)
              : ListView.builder(
                  padding: EdgeInsets.all(isRound ? 14 : 10),
                  itemCount: _currentDuas.length,
                  itemBuilder: (context, index) {
                    final duaWithLocation = _currentDuas[index];
                    return _buildDuaCard(duaWithLocation, isRound);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildWaitingView(bool isRound) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isRound ? 20.0 : 14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _hasReceivedPosition ? Icons.explore : Icons.gps_not_fixed,
              size: 40,
              color: Colors.white.withOpacity(0.5),
            ),
            const SizedBox(height: 12),
            Text(
              _hasReceivedPosition
                  ? 'Move closer to a holy site'
                  : 'Waiting for GPS signal...',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              _hasReceivedPosition
                  ? 'GPS is tracking your location'
                  : 'Set emulator location in Extended Controls',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.white.withOpacity(0.6),
                fontSize: 9,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDuaCard(DuaWithLocation duaWithLocation, bool isRound) {
    final dua = duaWithLocation.dua;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Location badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37).withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 10,
                    color: Color(0xFFD4AF37),
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      duaWithLocation.location.nameEn,
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD4AF37),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),

            // Arabic Text
            Text(
              dua.arabicText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.6,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 6),

            // English Translation
            Text(
              dua.englishTranslation,
              style: TextStyle(
                fontSize: 10,
                color: Colors.white.withOpacity(0.8),
                height: 1.3,
              ),
            ),

            // Transliteration (if available)
            if (dua.transliteration != null) ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  dua.transliteration!,
                  style: TextStyle(
                    fontSize: 9,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
