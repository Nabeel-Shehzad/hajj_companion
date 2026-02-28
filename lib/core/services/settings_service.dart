import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _keyLanguage = 'language';
  static const String _keyAudioEnabled = 'audio_enabled';
  static const String _keyHapticEnabled = 'haptic_enabled';
  static const String _keyLocationEnabled = 'location_enabled';
  static const String _keyAudioVolume = 'audio_volume';

  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  // Language Settings - NFR-10
  Future<void> setLanguage(String language) async {
    await _prefs.setString(_keyLanguage, language);
  }

  String getLanguage() {
    return _prefs.getString(_keyLanguage) ?? 'English';
  }

  // Audio Guidance - UR-04
  Future<void> setAudioEnabled(bool enabled) async {
    await _prefs.setBool(_keyAudioEnabled, enabled);
  }

  bool isAudioEnabled() {
    return _prefs.getBool(_keyAudioEnabled) ?? true;
  }

  // Haptic Feedback - UR-05
  Future<void> setHapticEnabled(bool enabled) async {
    await _prefs.setBool(_keyHapticEnabled, enabled);
  }

  bool isHapticEnabled() {
    return _prefs.getBool(_keyHapticEnabled) ?? true;
  }

  // Location Services
  Future<void> setLocationEnabled(bool enabled) async {
    await _prefs.setBool(_keyLocationEnabled, enabled);
  }

  bool isLocationEnabled() {
    return _prefs.getBool(_keyLocationEnabled) ?? true;
  }

  // Audio Volume
  Future<void> setAudioVolume(double volume) async {
    await _prefs.setDouble(_keyAudioVolume, volume);
  }

  double getAudioVolume() {
    return _prefs.getDouble(_keyAudioVolume) ?? 0.7;
  }

  // Reset all settings
  Future<void> resetSettings() async {
    await _prefs.clear();
  }

  // Get all settings as map
  Map<String, dynamic> getAllSettings() {
    return {
      'language': getLanguage(),
      'audioEnabled': isAudioEnabled(),
      'hapticEnabled': isHapticEnabled(),
      'locationEnabled': isLocationEnabled(),
      'audioVolume': getAudioVolume(),
    };
  }
}
