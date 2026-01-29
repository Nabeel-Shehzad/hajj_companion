import 'package:flutter/material.dart';
import 'package:drift/drift.dart' show Value;
import 'location_tracking_screen.dart';
import '../../database/app_database.dart';

class RitualSelectionScreen extends StatefulWidget {
  const RitualSelectionScreen({super.key});

  @override
  State<RitualSelectionScreen> createState() => _RitualSelectionScreenState();
}

class _RitualSelectionScreenState extends State<RitualSelectionScreen> {
  final _database = AppDatabase();
  String _ritualType = 'self';
  String _selectedRitual = 'tawaf';
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
    _database.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ritual Selection'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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
            const SizedBox(height: 24),

            // Ritual Selection
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
                          Icons.mosque,
                          color: Colors.green.shade700,
                          size: 28,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Select Ritual',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildRitualOption(
                      'tawaf',
                      'Tawaf',
                      'Circumambulation around the Kaaba',
                      Icons.sync,
                    ),
                    const Divider(),
                    _buildRitualOption(
                      'sai',
                      'Sa\'i',
                      'Walking between Safa and Marwah',
                      Icons.directions_walk,
                    ),
                    const Divider(),
                    _buildRitualOption(
                      'arafat',
                      'Arafat',
                      'Standing at Mount Arafat',
                      Icons.landscape,
                    ),
                    const Divider(),
                    _buildRitualOption(
                      'muzdalifah',
                      'Muzdalifah',
                      'Stay at Muzdalifah',
                      Icons.nightlight_round,
                    ),
                    const Divider(),
                    _buildRitualOption(
                      'mina',
                      'Mina',
                      'Days in Mina and Rami al-Jamarat',
                      Icons.location_city,
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
                    selectedRitual: _selectedRitual,
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
                      selectedRitual: _selectedRitual,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.navigation, size: 24),
              label: const Text('Start Location Tracking'),
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

  Widget _buildRitualOption(
    String value,
    String title,
    String description,
    IconData icon,
  ) {
    final isSelected = _selectedRitual == value;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedRitual = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedRitual,
              onChanged: (val) {
                setState(() {
                  _selectedRitual = val!;
                });
              },
              activeColor: Colors.green,
            ),
            Icon(
              icon,
              color: isSelected ? Colors.green.shade700 : Colors.grey.shade600,
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? Colors.green.shade800
                          : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
