import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'mobile/screens/home_screen.dart';
import 'mobile/screens/permit/permit_display_screen.dart';
import 'core/services/settings_service.dart';
import 'core/services/gesture_service.dart';
import 'core/services/data_seed_service.dart';
import 'core/services/notification_service.dart';
import 'core/database/app_database.dart';
import 'core/utils/app_localizations.dart';
import 'core/providers/language_provider.dart';
export 'core/providers/language_provider.dart';

// Global navigator key for navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Initialize notification service
  await NotificationService().initialize();

  runApp(const HajjCompanionMobileApp());
}

class HajjCompanionMobileApp extends StatefulWidget {
  const HajjCompanionMobileApp({super.key});

  @override
  State<HajjCompanionMobileApp> createState() => _HajjCompanionMobileAppState();
}

class _HajjCompanionMobileAppState extends State<HajjCompanionMobileApp> {
  final _settingsService = SettingsService();
  final _gestureService = GestureService();
  String _currentLanguage ='Arabic'; // Default to Arabic for mobile
  bool _gestureDetectionEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    _initGlobalGestureDetection();
    _seedDatabaseIfNeeded();
  }

  Future<void> _seedDatabaseIfNeeded() async {
    final database = AppDatabase();
    final seedService = DataSeedService(database);

    // Only seed if database is empty (first install)
    await seedService.seedInitialData();
  }

  Future<void> _initGlobalGestureDetection() async {
    // Load gesture detection settings
    final prefs = await SharedPreferences.getInstance();
    _gestureDetectionEnabled =
        prefs.getBool('gesture_detection_enabled') ?? false;

    // Start monitoring if enabled
    if (_gestureDetectionEnabled) {
      _gestureService.startMonitoring();
    }

    // Listen for gesture events globally
    _gestureService.gestureStream.listen((gesture) {
      if (gesture == WristGesture.raised && _gestureDetectionEnabled) {
        _navigateToPermitDisplay();
      }
    });
  }

  void _navigateToPermitDisplay() {
    final currentContext = navigatorKey.currentContext;
    if (currentContext != null) {
      // Check if we're not already on the permit display screen
      Navigator.of(currentContext).push(
        MaterialPageRoute(builder: (context) => const PermitDisplayScreen()),
      );
    }
  }

  @override
  void dispose() {
    _gestureService.dispose();
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    await _settingsService.init();
    setState(() {
      _currentLanguage = _settingsService.getLanguage();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isArabic = _currentLanguage == 'Arabic';
    // Convert "English"/"Arabic" to "en"/"ar" for AppLocalizations
    final languageCode = isArabic ? 'ar' : 'en';
    final localizations = AppLocalizations(languageCode);

    return LanguageProvider(
      language: _currentLanguage,
      localizations: localizations,
      child: MaterialApp(
        navigatorKey: navigatorKey, // Add global navigator key
        title: isArabic ? 'رفيق الحج والعمرة' : 'Hajj & Umrah Companion',
        debugShowCheckedModeBanner: false,
        locale: isArabic ? const Locale('ar', 'SA') : const Locale('en', 'US'),
        supportedLocales: const [Locale('en', 'US'), Locale('ar', 'SA')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          primaryColor: const Color(0xFF006B3E), // Islamic Green
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF006B3E),
            primary: const Color(0xFF006B3E),
            secondary: const Color(0xFFD4AF37), // Gold
            tertiary: const Color(0xFF8B4513), // Brown
            background: const Color(0xFFF8F9FA),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF006B3E),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF006B3E),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
            ),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
