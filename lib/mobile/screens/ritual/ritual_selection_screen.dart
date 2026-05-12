import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'location_tracking_screen.dart';
import 'package:hajj_companion/core/database/app_database.dart';
import 'package:hajj_companion/core/providers/language_provider.dart';

class RitualSelectionScreen extends StatefulWidget {
  const RitualSelectionScreen({super.key});

  @override
  State<RitualSelectionScreen> createState() => _RitualSelectionScreenState();
}

class _RitualSelectionScreenState extends State<RitualSelectionScreen> {
  final _database = AppDatabase.instance;
  String _ritualType = 'self';
  RitualSetting? _savedSettings;

  @override
  void initState() {
    super.initState();
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    final settings = await _database.getRitualSettings();
    if (settings != null) {
      setState(() {
        _savedSettings = settings;
        _ritualType = settings.ritualType;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr?.ritualGuidanceSettings ?? 'Ritual Guidance Settings'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tr?.locationAutoDetect2 ??
                            'Your location will automatically detect nearby holy sites and display appropriate duas',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Ritual Type Selection
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Colors.green.shade700,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          tr?.performingRitualFor ?? 'Performing Ritual For',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    RadioListTile<String>(
                      title: Text(tr?.forMyself ?? 'For Myself'),
                      subtitle: Text(
                        tr?.standardDuasDesc ??
                            'Standard duas for personal rituals',
                      ),
                      value: 'self',
                      groupValue: _ritualType,
                      onChanged: (value) {
                        setState(() {
                          _ritualType = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                    RadioListTile<String>(
                      title: Text(
                          tr?.onBehalfOfSomeone ?? 'On Behalf of Someone'),
                      subtitle: Text(
                          tr?.modifiedDuasDesc ??
                              'Modified duas for proxy rituals'),
                      value: 'proxy',
                      groupValue: _ritualType,
                      onChanged: (value) {
                        setState(() {
                          _ritualType = value!;
                        });
                      },
                      activeColor: Colors.green,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Start Tracking Button
            ElevatedButton.icon(
              onPressed: () async {
                await _database.saveRitualSettings(
                  RitualSettingsCompanion.insert(
                    ritualType: _ritualType,
                    selectedRitual: 'auto',
                    audioEnabled: Value(_savedSettings?.audioEnabled ?? true),
                    hapticEnabled: Value(_savedSettings?.hapticEnabled ?? true),
                    audioVolume: Value(_savedSettings?.audioVolume ?? 80),
                  ),
                );

                if (!mounted) return;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LocationTrackingScreen(
                      ritualType: _ritualType,
                      selectedRitual: 'auto',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.navigation, size: 24),
              label: Text(tr?.startGPSGuidance ?? 'Start GPS Guidance'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 18),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),

            // Information Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        tr?.locationAutoDetect ??
                            'The app will automatically detect your location and provide appropriate duas',
                        style: TextStyle(
                          color: Colors.blue.shade900,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
