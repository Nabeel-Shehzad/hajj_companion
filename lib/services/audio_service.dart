import 'package:flutter_tts/flutter_tts.dart';

/// Service for playing duas using Text-to-Speech
class AudioService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isPlaying = false;
  double _volume = 0.8;
  double _pitch = 1.0;
  double _rate = 0.4; // Slower for Arabic recitation

  AudioService() {
    _initializeTts();
  }

  Future<void> _initializeTts() async {
    // Set language to Arabic
    await _flutterTts.setLanguage('ar-SA'); // Saudi Arabic
    await _flutterTts.setSpeechRate(_rate);
    await _flutterTts.setVolume(_volume);
    await _flutterTts.setPitch(_pitch);

    // Set up callbacks
    _flutterTts.setStartHandler(() {
      _isPlaying = true;
    });

    _flutterTts.setCompletionHandler(() {
      _isPlaying = false;
    });

    _flutterTts.setErrorHandler((msg) {
      _isPlaying = false;
    });
  }

  /// Play Arabic dua text
  Future<void> playDua(String arabicText) async {
    if (_isPlaying) {
      await stop();
    }

    await _flutterTts.setLanguage('ar-SA');
    await _flutterTts.speak(arabicText);
  }

  /// Play English translation
  Future<void> playTranslation(String englishText) async {
    if (_isPlaying) {
      await stop();
    }

    await _flutterTts.setLanguage('en-US');
    await _flutterTts.speak(englishText);
  }

  /// Stop current playback
  Future<void> stop() async {
    await _flutterTts.stop();
    _isPlaying = false;
  }

  /// Pause current playback
  Future<void> pause() async {
    await _flutterTts.pause();
    _isPlaying = false;
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _flutterTts.setVolume(_volume);
  }

  /// Set speech rate (0.0 to 1.0, default 0.4 for Arabic)
  Future<void> setRate(double rate) async {
    _rate = rate.clamp(0.0, 1.0);
    await _flutterTts.setSpeechRate(_rate);
  }

  /// Set pitch (0.5 to 2.0, default 1.0)
  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 2.0);
    await _flutterTts.setPitch(_pitch);
  }

  /// Check if currently playing
  bool get isPlaying => _isPlaying;

  /// Get available languages
  Future<List<dynamic>> getLanguages() async {
    return await _flutterTts.getLanguages;
  }

  /// Check if Arabic is available
  Future<bool> isArabicAvailable() async {
    final languages = await getLanguages();
    return languages.any((lang) => lang.toString().startsWith('ar'));
  }

  void dispose() {
    _flutterTts.stop();
  }
}
