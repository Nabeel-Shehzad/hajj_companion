import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'wear/screens/wear_home_screen.dart';
import 'core/services/data_seed_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/gesture_service.dart';
import 'core/database/app_database.dart';
import 'wear/screens/permit/wear_permit_display_screen.dart';

// Global navigator key for WearOS navigation
final GlobalKey<NavigatorState> wearNavigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize notification service
  await NotificationService().initialize();

  runApp(const HajjCompanionWearApp());
}

class HajjCompanionWearApp extends StatefulWidget {
  const HajjCompanionWearApp({super.key});

  @override
  State<HajjCompanionWearApp> createState() => _HajjCompanionWearAppState();
}

class _HajjCompanionWearAppState extends State<HajjCompanionWearApp> {
  final _gestureService = GestureService();

  @override
  void initState() {
    super.initState();
    _seedDatabaseIfNeeded();
    _initWristRaiseGesture();
  }

  Future<void> _seedDatabaseIfNeeded() async {
    final database = AppDatabase();
    final seedService = DataSeedService(database);
    await seedService.seedInitialData();
  }

  Future<void> _initWristRaiseGesture() async {
    // Start monitoring wrist raise gesture
    _gestureService.startMonitoring();

    // Listen for wrist raise events
    _gestureService.gestureStream.listen((gesture) {
      if (gesture == WristGesture.raised) {
        _showPermitQuickView();
      }
    });
  }

  void _showPermitQuickView() {
    final currentContext = wearNavigatorKey.currentContext;
    if (currentContext != null) {
      Navigator.of(currentContext).push(
        MaterialPageRoute(
          builder: (context) => const WearPermitDisplayScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _gestureService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: wearNavigatorKey,
      title: 'Hajj Companion',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Dark theme optimized for WearOS (OLED battery saving)
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF006B3E), // Islamic Green
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00A651), // Brighter green for dark mode
          secondary: Color(0xFFD4AF37), // Gold
          surface: Color(0xFF1A1A1A),
          background: Colors.black,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onBackground: Colors.white,
        ),
        // WearOS-optimized typography
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyLarge: TextStyle(fontSize: 14, color: Colors.white),
          bodyMedium: TextStyle(fontSize: 12, color: Colors.white70),
        ),
        // Card theme for WearOS
        cardTheme: CardThemeData(
          elevation: 2,
          color: const Color(0xFF1A1A1A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        // Button theme for WearOS (larger touch targets)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A651),
            foregroundColor: Colors.white,
            minimumSize: const Size(48, 48), // Minimum touch target
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24), // More rounded for watch
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white, size: 24),
      ),
      home: const WearHomeScreen(),
    );
  }
}
