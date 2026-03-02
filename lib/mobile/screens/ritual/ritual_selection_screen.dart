import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'location_tracking_screen.dart';
import 'package:hajj_companion/core/database/app_database.dart';

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
    // Don't close the singleton database - it's shared across the app
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ritual Guidance Settings'),
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
                          'Performing Ritual For',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    RadioListTile<String>(
                      title: const Text('For Myself'),
                      subtitle: const Text(
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
                      title: const Text('On Behalf of Someone'),
                      subtitle: const Text('Modified duas for proxy rituals'),
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
                // Save settings before starting
                await _database.saveRitualSettings(
                  RitualSettingsCompanion.insert(
                    ritualType: _ritualType,
                    selectedRitual: 'auto', // Auto-detected by GPS
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
                      selectedRitual: 'auto', // GPS determines ritual
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.navigation, size: 24),
              label: const Text('Start GPS Guidance'),
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
