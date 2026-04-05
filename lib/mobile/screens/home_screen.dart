import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'permit/permit_entry_screen.dart';
import 'permit/permit_display_screen.dart';
import 'ritual/ritual_selection_screen.dart';
import 'ritual/location_tracking_screen.dart';
import 'family_safety/family_safety_home_screen.dart';
import 'chat_list_screen.dart';
import 'settings_screen.dart';
import '../../main.dart';
import '../../core/services/device_id_service.dart';
import '../../core/services/family_group_service.dart';
import '../../core/database/app_database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    // Check if we've already asked for permission
    final prefs = await SharedPreferences.getInstance();
    final hasAsked = prefs.getBool('location_permission_asked') ?? false;

    if (!hasAsked) {
      // Wait a bit for the home screen to render first
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showLocationPermissionDialog();
      }

      // Mark that we've asked
      await prefs.setBool('location_permission_asked', true);
    }
  }

  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_on, color: Colors.green.shade700, size: 28),
            const SizedBox(width: 12),
            const Expanded(child: Text('Location Permission')),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This app needs location access to provide:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('📍 Ritual guidance at holy sites')),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text('🕋 Auto duas when entering sacred locations'),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 20),
                SizedBox(width: 8),
                Expanded(child: Text('👨‍👩‍👧‍👦 Family tracking for safety')),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Your location data is stored locally and never shared without your consent.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Not Now'),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              Navigator.pop(context);
              final permission = await Geolocator.requestPermission();
              if (permission == LocationPermission.denied ||
                  permission == LocationPermission.deniedForever) {
                if (!mounted) return;
                _showPermissionDeniedSnackbar();
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 12),
                        Text('Location permission granted!'),
                      ],
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            icon: const Icon(Icons.check),
            label: const Text('Allow Location'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('You can enable location in Settings later'),
        action: SnackBarAction(
          label: 'Open Settings',
          onPressed: () => Geolocator.openLocationSettings(),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr?.homeTitle ?? 'Hajj & Umrah Companion'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [const Color(0xFF006B3E).withOpacity(0.05), Colors.white],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Section with Islamic Design
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF006B3E), Color(0xFF008B4E)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF006B3E).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFFD4AF37,
                                  ).withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.mosque,
                              size: 50,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'بِسْمِ اللهِ الرَّحْمٰنِ الرَّحِيْمِ',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD4AF37),
                              letterSpacing: 2,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tr?.homeTitle ?? 'Smart Hajj & Umrah Companion',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            provider?.language == 'Arabic'
                                ? 'مساعدك في رحلتك الروحانية'
                                : 'Your spiritual journey assistant',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Main Features Grid
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildFeatureCard(
                      context,
                      tr?.digitalPermit ?? 'Digital Permit',
                      Icons.badge,
                      const Color(0xFF006B3E),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PermitEntryScreen(),
                        ),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      tr?.viewPermit ?? 'View Permit',
                      Icons.qr_code,
                      const Color(0xFFD4AF37),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PermitDisplayScreen(),
                        ),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      tr?.ritualGuide ?? 'Ritual Guide',
                      Icons.navigation,
                      const Color(0xFF8B4513),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RitualSelectionScreen(),
                        ),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      tr?.locationTracking ?? 'Location Tracking',
                      Icons.location_on,
                      const Color(0xFFB8860B),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LocationTrackingScreen(
                            ritualType: 'Hajj',
                            selectedRitual: 'General',
                          ),
                        ),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      tr?.familySafety ?? 'Family Safety',
                      Icons.family_restroom,
                      const Color(0xFF2E8B57),
                      () async {
                        // Initialize services for Family Safety
                        final prefs = await SharedPreferences.getInstance();
                        final deviceIdService = DeviceIdService(prefs);
                        final groupService = FamilyGroupService(
                          FirebaseFirestore.instance,
                          deviceIdService,
                          prefs,
                        );

                        if (!mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FamilySafetyHomeScreen(
                              deviceIdService: deviceIdService,
                              groupService: groupService,
                            ),
                          ),
                        );
                      },
                    ),
                    _buildFeatureCard(
                      context,
                      'AI Assistant',
                      Icons.smart_toy,
                      const Color(0xFF9C27B0),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatListScreen(database: AppDatabase.instance),
                        ),
                      ),
                    ),
                    _buildFeatureCard(
                      context,
                      tr?.settings ?? 'Settings',
                      Icons.settings,
                      const Color(0xFF696969),
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, color.withOpacity(0.05)],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(icon, size: 36, color: color),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF006B3E),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
