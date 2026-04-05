import 'dart:async';
import 'package:flutter/foundation.dart';
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

  StreamSubscription<GuidanceEvent>? _guidanceSubscription;
  StreamSubscription<dynamic>? _positionSubscription;

  bool _isTracking = false;
  bool _hasError = false;
  String _errorMessage = '';
  String _currentLocation = 'Acquiring GPS signal...';
  List<DuaWithLocation> _currentDuas = [];
  // True when any GPS position arrives (not just when near a holy site)
  bool _hasReceivedPosition = false;
  bool _gpsTimedOut = false;

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
    // Check / request the location permission.
    // Note: Geolocator.isLocationServiceEnabled() crashes on WearOS with
    // ApiException: "Not implemented on this platform" at the native layer —
    // it cannot be caught in Dart. We skip that check entirely and rely on
    // the position stream's onError to surface the "service disabled" error.
    final hasPermission = await _locationService.checkPermissions();
    if (!hasPermission) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage =
              'Location permission required. Enable location access in settings.';
        });
      }
      return;
    }

    _startTracking();
  }

  Future<void> _startTracking() async {
    try {
      // ── Step 1: Subscribe to raw position stream FIRST ────────────────────
      // The _positionController in LocationService is initialised eagerly, so
      // this subscription is in place before startGuidance() starts the
      // geolocator. That prevents the race condition where an immediate
      // "location service disabled" error fires before anyone is listening
      // (broadcast streams discard events with no current subscribers).
      _positionSubscription = _locationService.positionStream.listen(
        (position) {
          if (mounted && !_hasReceivedPosition) {
            setState(() {
              _hasReceivedPosition = true;
              _gpsTimedOut = false;
              if (_currentDuas.isEmpty) _currentLocation = 'GPS active';
            });
          }
        },
        onError: (error) {
          debugPrint('WearRitualScreen: position stream error: $error');
          if (mounted) {
            setState(() {
              _hasError = true;
              _errorMessage =
                  'Location service is off. Enable GPS in Settings → Location.';
            });
          }
        },
      );

      // ── Step 2: Start guidance (internally starts geolocator) ─────────────
      final started = await _guidanceService.startGuidance(ritualType: 'self');

      if (!started) {
        await _positionSubscription?.cancel();
        _positionSubscription = null;
        if (mounted) {
          setState(() {
            _hasError = true;
            _errorMessage = 'Could not start GPS tracking. Check permissions.';
          });
        }
        return;
      }

      if (mounted) setState(() => _isTracking = true);

      // ── Step 3: Listen for holy-site guidance events ──────────────────────
      _guidanceSubscription = _guidanceService.guidanceEvents.listen(
        (event) {
          if (mounted) {
            setState(() {
              _hasReceivedPosition = true;
              _gpsTimedOut = false;
              _currentLocation = event.location.nameEn;
              _currentDuas = event.duasWithLocations;
            });
            HapticFeedback.mediumImpact();
          }
        },
        onError: (error) {
          debugPrint('WearRitualScreen: guidance stream error: $error');
          if (mounted && error.toString().toLowerCase().contains('disabled')) {
            setState(() {
              _hasError = true;
              _errorMessage = 'Location service is disabled';
            });
          }
        },
      );

      // ── Step 4: Timeout only if GPS genuinely produces no positions ────────
      // 30 s covers GPS cold-start on WearOS devices.
      Future.delayed(const Duration(seconds: 30), () {
        if (mounted && _isTracking && !_hasReceivedPosition) {
          setState(() => _gpsTimedOut = true);
        }
      });
    } catch (e) {
      debugPrint('WearRitualScreen: error starting tracking: $e');
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString().toLowerCase().contains('disabled')
              ? 'Location service is disabled. Enable it in Settings.'
              : 'GPS error: ${e.toString()}';
        });
      }
    }
  }

  @override
  void dispose() {
    _positionSubscription?.cancel();
    _guidanceSubscription?.cancel();
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
    final isRound =
        screenSize.width == screenSize.height && screenSize.width >= 300;

    return Scaffold(
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
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, size: 20),
            onPressed: () => Navigator.pop(context),
            padding: const EdgeInsets.all(8),
          ),
        ),
        const Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Color(0xFF00A651)),
              SizedBox(height: 16),
              Text('Starting GPS...', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrackingView(bool isRound) {
    return Column(
      children: [
        // Location Header with back button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, size: 18),
              ),
              const SizedBox(width: 6),
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
              const SizedBox(width: 6),
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
                  // Round dials: extra horizontal padding to avoid corner clipping
                  padding: EdgeInsets.symmetric(
                    horizontal: isRound ? 20 : 10,
                    vertical: isRound ? 8 : 10,
                  ),
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
    final String title;
    final String subtitle;
    final IconData icon;

    if (_hasReceivedPosition) {
      icon = Icons.explore;
      title = 'Move closer to a holy site';
      subtitle = 'GPS is tracking your location';
    } else if (_gpsTimedOut) {
      icon = Icons.gps_off;
      title = 'No GPS signal received';
      subtitle = 'GPS is on but no signal.\nOn emulator: set location in\nExtended Controls → Location.\nOn device: go outdoors.';
    } else {
      icon = Icons.gps_not_fixed;
      title = 'Waiting for GPS...';
      subtitle = 'Acquiring signal — may take up to 30s outdoors';
    }

    return Center(
      child: Padding(
        // Round dials clip corners — use extra horizontal inset
        padding: EdgeInsets.symmetric(
          horizontal: isRound ? 28.0 : 14.0,
          vertical: isRound ? 12.0 : 10.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.white.withOpacity(0.5)),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: isRound ? 11 : 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: isRound ? 9 : 10,
                color: Colors.white.withOpacity(0.6),
              ),
              textAlign: TextAlign.center,
            ),
            if (_gpsTimedOut && !_hasReceivedPosition) ...[
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _gpsTimedOut = false;
                    _hasError = false;
                    _errorMessage = '';
                  });
                  _requestPermissionsAndStart();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00A651).withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF00A651).withOpacity(0.5),
                    ),
                  ),
                  child: const Text(
                    'Retry',
                    style: TextStyle(fontSize: 11, color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDuaCard(DuaWithLocation duaWithLocation, bool isRound) {
    final dua = duaWithLocation.dua;
    // Smaller sizes for round dials where corners are clipped
    final double arabicSize = isRound ? 12.0 : 14.0;
    final double translationSize = isRound ? 9.0 : 10.0;
    final double translitSize = isRound ? 8.0 : 9.0;
    final EdgeInsets cardPadding = isRound
        ? const EdgeInsets.all(8)
        : const EdgeInsets.all(10);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: cardPadding,
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
              style: TextStyle(
                fontSize: arabicSize,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                height: 1.6,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5),

            // English Translation
            Text(
              dua.englishTranslation,
              style: TextStyle(
                fontSize: translationSize,
                color: Colors.white.withOpacity(0.8),
                height: 1.3,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            // Transliteration (if available)
            if (dua.transliteration != null) ...[
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  dua.transliteration!,
                  style: TextStyle(
                    fontSize: translitSize,
                    fontStyle: FontStyle.italic,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
