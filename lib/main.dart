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

// Global navigator key for navigation from anywhere
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
//used a global navigator key to navigate to the permit display screen when a wrist gesture is detected without needing widget context.
// we used final to ensure that the navigator key is only set once and cannot be changed later in the app lifecycle, providing a consistent reference for navigation throughout the app.

// Global access to current language
class LanguageProvider extends InheritedWidget {
  //This class is a provider that shares language information across the entire widget tree. It uses InheritedWidget pattern.
  //nheritedWidget allows child widgets to access data without passing it through constructor parameters (prop drilling
  final String language;
  final AppLocalizations localizations;

const LanguageProvider({
    super.key,
    //super.key — Flutter key for widget identification
    required this.language,
    required this.localizations,
    required super.child,
  });

  static LanguageProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LanguageProvider>();
  }
//This method is used to access the current LanguageProvider from anywhere in the widget tree using the BuildContext.
  @override
  bool updateShouldNotify(LanguageProvider oldWidget) {
    return language != oldWidget.language; //اذا اللغه القديمه مو نفس الجديد يعني ترو وغير لي 
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize notification service
  await NotificationService().initialize();

  runApp(const HajjCompanionApp());
}//This function initializes Flutter services, Firebase, and notifications before starting the application.
  

class HajjCompanionApp extends StatefulWidget {
  const HajjCompanionApp({super.key});

  @override
  State<HajjCompanionApp> createState() => _HajjCompanionAppState();
}

class _HajjCompanionAppState extends State<HajjCompanionApp> {
  final _settingsService = SettingsService();
  final _gestureService = GestureService();

  String _currentLanguage = 'English';
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

    await seedService.seedInitialData();
  }

  Future<void> _initGlobalGestureDetection() async {
    // Load saved gesture setting from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    _gestureDetectionEnabled =
        prefs.getBool('gesture_detection_enabled') ?? false;

    // If gesture detection is enabled, start monitoring wrist movement.
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
    //stop the gesture service when the app is closed to free up resources and prevent memory leaks.
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
