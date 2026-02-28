import 'package:flutter/material.dart';

class ChildMonitoringScreen extends StatefulWidget {
  const ChildMonitoringScreen({super.key});

  @override
  State<ChildMonitoringScreen> createState() => _ChildMonitoringScreenState();
}

class _ChildMonitoringScreenState extends State<ChildMonitoringScreen> {
  final List<Map<String, dynamic>> _children = [
    {
      'name': 'Ahmed',
      'deviceId': 'WATCH002',
      'safeDistance': 1000.0,
      'currentDistance': 120.0,
      'alertEnabled': true,
    },
    {
      'name': 'Fatima',
      'deviceId': 'WATCH003',
      'safeDistance': 800.0,
      'currentDistance': 850.0,
      'alertEnabled': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Child Monitoring'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Information Card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue.shade700,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Set safe distance limits for each child. You\'ll receive alerts when they exceed the configured distance.',
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
          const SizedBox(height: 24),

          // Children List
          ..._children.map((child) => _buildChildMonitorCard(child)),
        ],
      ),
    );
  }

  Widget _buildChildMonitorCard(Map<String, dynamic> child) {
    final bool isAlert = child['currentDistance'] > child['safeDistance'];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: isAlert
                      ? Colors.red.shade100
                      : Colors.green.shade100,
                  child: Icon(
                    Icons.child_care,
                    color: isAlert
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        child['name'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        child['deviceId'],
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: child['alertEnabled'],
                  onChanged: (value) {
                    setState(() {
                      child['alertEnabled'] = value;
                    });
                  },
                  activeColor: Colors.green,
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Current Status
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isAlert ? Colors.red.shade50 : Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isAlert ? Colors.red.shade200 : Colors.green.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isAlert ? Icons.warning : Icons.check_circle,
                    color: isAlert
                        ? Colors.red.shade700
                        : Colors.green.shade700,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAlert ? 'DISTANCE ALERT' : 'WITHIN SAFE ZONE',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isAlert
                                ? Colors.red.shade900
                                : Colors.green.shade900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${child['currentDistance'].toStringAsFixed(0)}m / ${child['safeDistance'].toStringAsFixed(0)}m',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isAlert
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Safe Distance Slider
            Text(
              'Safe Distance: ${child['safeDistance'].toStringAsFixed(0)} meters',
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
            ),
            Slider(
              value: child['safeDistance'],
              min: 100,
              max: 2000,
              divisions: 19,
              label: '${child['safeDistance'].toStringAsFixed(0)}m',
              onChanged: (value) {
                setState(() {
                  child['safeDistance'] = value;
                });
              },
              activeColor: Colors.green,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '100m',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
                Text(
                  '2000m',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to map
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Locating ${child['name']} on map...'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.location_on),
                    label: const Text('Locate'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Send notification
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Notification sent to ${child['name']}',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.notifications),
                    label: const Text('Notify'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
