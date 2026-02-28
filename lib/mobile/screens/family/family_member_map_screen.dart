import 'package:flutter/material.dart';

class FamilyMemberMapScreen extends StatelessWidget {
  final List<Map<String, dynamic>> familyMembers;

  const FamilyMemberMapScreen({super.key, required this.familyMembers});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Location Map'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Map Placeholder
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.grey.shade200,
              child: Stack(
                children: [
                  // Map background placeholder
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 80, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'Map View',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Interactive map integration pending',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                  // Simulated markers
                  Positioned(
                    top: 100,
                    left: 150,
                    child: _buildMapMarker('You', Colors.blue, true),
                  ),
                  Positioned(
                    top: 120,
                    left: 180,
                    child: _buildMapMarker('Sarah', Colors.green, false),
                  ),
                  Positioned(
                    top: 200,
                    left: 200,
                    child: _buildMapMarker('Ahmed', Colors.green, false),
                  ),
                  Positioned(
                    top: 300,
                    left: 100,
                    child: _buildMapMarker('Fatima', Colors.orange, false),
                  ),
                ],
              ),
            ),
          ),

          // Member List at Bottom
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Family Members',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${familyMembers.length} nearby',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...familyMembers.map(
                    (member) => _buildMemberListItem(context, member),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'center',
            onPressed: () {
              // TODO: Center map on user location
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Centering on your location'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: () {
              // TODO: Refresh locations
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Refreshing locations...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            child: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  Widget _buildMapMarker(String name, Color color, bool isUser) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4),
            ],
          ),
          child: Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          isUser ? Icons.person_pin : Icons.location_on,
          color: color,
          size: isUser ? 40 : 32,
          shadows: [
            Shadow(color: Colors.black.withOpacity(0.3), blurRadius: 4),
          ],
        ),
      ],
    );
  }

  Widget _buildMemberListItem(
    BuildContext context,
    Map<String, dynamic> member,
  ) {
    final bool isWarning = member['status'] == 'warning';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isWarning
              ? Colors.orange.shade100
              : Colors.green.shade100,
          child: Icon(
            member['isChild'] ? Icons.child_care : Icons.person,
            color: isWarning ? Colors.orange.shade700 : Colors.green.shade700,
          ),
        ),
        title: Text(
          member['name'],
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('${member['distance'].toStringAsFixed(0)}m away'),
        trailing: Icon(
          isWarning ? Icons.warning : Icons.check_circle,
          color: isWarning ? Colors.orange : Colors.green,
        ),
        onTap: () {
          // TODO: Center map on member
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Locating ${member['name']}...'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
      ),
    );
  }
}
