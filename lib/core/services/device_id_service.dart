import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class DeviceIdService {
  static const String _deviceIdKey = 'device_id';
  static const String _displayNameKey = 'device_display_name';

  final SharedPreferences _prefs;
  final Uuid _uuid = const Uuid();

  DeviceIdService(this._prefs);

  /// Get the unique device ID, generating one if it doesn't exist
  String getDeviceId() {
    String? deviceId = _prefs.getString(_deviceIdKey);

    if (deviceId == null || deviceId.isEmpty) {
      deviceId = _uuid.v4();
      _prefs.setString(_deviceIdKey, deviceId);
    }

    return deviceId;
  }

  /// Get the device display name
  String? getDisplayName() {
    return _prefs.getString(_displayNameKey);
  }

  /// Set the device display name
  Future<bool> setDisplayName(String name) async {
    return await _prefs.setString(_displayNameKey, name);
  }

  /// Check if device has a display name set
  bool hasDisplayName() {
    final name = _prefs.getString(_displayNameKey);
    return name != null && name.isNotEmpty;
  }

  /// Generate a short join code (6 characters, uppercase alphanumeric)
  String generateJoinCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = _uuid.v4().replaceAll('-', '');
    return List.generate(6, (index) {
      final charIndex = random.codeUnitAt(index) % chars.length;
      return chars[charIndex];
    }).join();
  }

  /// Clear all device data (for testing/reset)
  Future<void> clearDeviceData() async {
    await _prefs.remove(_deviceIdKey);
    await _prefs.remove(_displayNameKey);
  }
}
