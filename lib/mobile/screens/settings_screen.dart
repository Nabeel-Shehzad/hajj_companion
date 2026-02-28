import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_companion/core/services/settings_service.dart';
import 'package:hajj_companion/main_mobile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _settingsService = SettingsService();
  String _selectedLanguage = 'English';
  bool _audioGuidanceEnabled = true;
  bool _hapticFeedbackEnabled = true;
  bool _locationServicesEnabled = true;
  double _audioVolume = 0.7;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await _settingsService.init();
    setState(() {
      _selectedLanguage = _settingsService.getLanguage();
      _audioGuidanceEnabled = _settingsService.isAudioEnabled();
      _hapticFeedbackEnabled = _settingsService.isHapticEnabled();
      _locationServicesEnabled = _settingsService.isLocationEnabled();
      _audioVolume = _settingsService.getAudioVolume();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;
    final isArabic = provider?.language == 'Arabic';

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(tr?.settingsTitle ?? 'Settings'),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(tr?.settingsTitle ?? 'Settings'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Language Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr?.languageSettings ?? 'Language Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: Text(tr?.language ?? 'Language'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedLanguage == 'Arabic'
                              ? (tr?.arabic ?? 'العربية')
                              : (tr?.english ?? 'English'),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isArabic ? 'محفوظ ✓' : 'Saved ✓',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.green[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () => _showLanguageDialog(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Guidance Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr?.guidanceSettings ?? 'Guidance Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    secondary: const Icon(Icons.volume_up),
                    title: Text(tr?.audioGuidance ?? 'Audio Guidance'),
                    subtitle: Text(
                      tr?.playDuas ?? 'Play duas through earphones',
                    ),
                    value: _audioGuidanceEnabled,
                    onChanged: (value) async {
                      await _settingsService.setAudioEnabled(value);
                      setState(() {
                        _audioGuidanceEnabled = value;
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Audio guidance ${value ? 'enabled' : 'disabled'} ✓',
                            ),
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                  if (_audioGuidanceEnabled) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tr?.audioVolume ?? 'Audio Volume'),
                          Slider(
                            value: _audioVolume,
                            onChanged: (value) {
                              setState(() {
                                _audioVolume = value;
                              });
                            },
                            onChangeEnd: (value) async {
                              await _settingsService.setAudioVolume(value);
                            },
                            min: 0.0,
                            max: 1.0,
                            divisions: 10,
                            label: '${(_audioVolume * 100).round()}%',
                          ),
                        ],
                      ),
                    ),
                  ],
                  SwitchListTile(
                    secondary: const Icon(Icons.vibration),
                    title: Text(tr?.hapticFeedback ?? 'Haptic Feedback'),
                    subtitle: Text(
                      tr?.vibrationAlerts ?? 'Vibration alerts for locations',
                    ),
                    value: _hapticFeedbackEnabled,
                    onChanged: (value) async {
                      await _settingsService.setHapticEnabled(value);
                      setState(() {
                        _hapticFeedbackEnabled = value;
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Haptic feedback ${value ? 'enabled' : 'disabled'} ✓',
                            ),
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Location Settings
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr?.locationSettings ?? 'Location Settings',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    secondary: const Icon(Icons.location_on),
                    title: Text(tr?.locationServices ?? 'Location Services'),
                    subtitle: Text(tr?.enableGPS ?? 'Enable GPS tracking'),
                    value: _locationServicesEnabled,
                    onChanged: (value) async {
                      await _settingsService.setLocationEnabled(value);
                      setState(() {
                        _locationServicesEnabled = value;
                      });
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Location services ${value ? 'enabled' : 'disabled'} ✓',
                            ),
                            duration: const Duration(seconds: 1),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // About Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr?.about ?? 'About',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.info),
                    title: Text(tr?.appVersion ?? 'Version'),
                    subtitle: const Text('1.0.0'),
                  ),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: Text(tr?.privacyPolicy ?? 'Privacy Policy'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to privacy policy
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: Text(tr?.helpSupport ?? 'Help & Support'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to help
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

  void _showLanguageDialog() {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(tr?.selectLanguage ?? 'Select Language'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: const Text('English'),
                value: 'English',
                groupValue: _selectedLanguage,
                onChanged: (value) async {
                  await _settingsService.setLanguage(value!);
                  setState(() {
                    _selectedLanguage = value;
                  });
                  Navigator.pop(context);
                  if (context.mounted) {
                    _showRestartDialog(context, false);
                  }
                },
              ),
              RadioListTile<String>(
                title: const Text('Arabic - العربية'),
                value: 'Arabic',
                groupValue: _selectedLanguage,
                onChanged: (value) async {
                  await _settingsService.setLanguage(value!);
                  setState(() {
                    _selectedLanguage = value;
                  });
                  Navigator.pop(context);
                  if (context.mounted) {
                    _showRestartDialog(context, true);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showRestartDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            isArabic ? 'تم تغيير اللغة' : 'Language Changed',
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
          ),
          content: Text(
            isArabic
                ? 'يرجى إعادة تشغيل التطبيق لتطبيق اللغة العربية مع التنسيق من اليمين إلى اليسار.'
                : 'Please restart the app to apply the language change with proper text direction.',
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // Close the entire app
                SystemNavigator.pop();
              },
              child: Text(
                isArabic ? 'حسناً، سأعيد التشغيل' : 'OK, I\'ll Restart',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}
