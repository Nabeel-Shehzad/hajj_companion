import 'package:flutter/material.dart';
import 'package:hajj_companion/wear/screens/permit/wear_permit_display_screen.dart';
import 'package:hajj_companion/wear/screens/permit/wear_permit_entry_screen.dart';
import 'package:hajj_companion/wear/screens/ritual/wear_ritual_screen.dart';
import 'package:hajj_companion/wear/screens/family/wear_family_screen.dart';
import 'package:hajj_companion/core/database/app_database.dart';
import 'package:hajj_companion/core/services/permit_service.dart';

class WearHomeScreen extends StatelessWidget {
  const WearHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // WearOS round displays always have equal width/height. Rectangular watches
    // have different dimensions. The >=300 guard filters out unlikely edge cases
    // where a tiny square non-watch screen could be misidentified as round.
    final isRound =
        screenSize.width == screenSize.height && screenSize.width >= 300;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: isRound ? 24 : 16),
          children: [
            const SizedBox(height: 24),
            // App Title
            Column(
              children: [
                Icon(
                  Icons.mosque,
                  size: 40,
                  color: Theme.of(context).colorScheme.secondary,
                ),
                const SizedBox(height: 8),
                const Text(
                  'بِسْمِ اللهِ',
                  style: TextStyle(fontSize: 16, color: Color(0xFFD4AF37)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Hajj Companion',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Main Action Cards
            _WearActionCard(
              icon: Icons.badge,
              title: 'My Permit',
              subtitle: 'Digital ID',
              color: const Color(0xFF006B3E),
              onTap: () async {
                // Check if permit exists
                final permitService = PermitService(AppDatabase.instance);
                final permit = await permitService.getPermit();

                if (!context.mounted) return;

                if (permit != null) {
                  // Navigate to display screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WearPermitDisplayScreen(),
                    ),
                  );
                } else {
                  // Navigate to entry screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const WearPermitEntryScreen(),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 12),
            _WearActionCard(
              icon: Icons.navigation,
              title: 'Ritual Guide',
              subtitle: 'GPS Duas',
              color: const Color(0xFF8B4513),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WearRitualScreen(),
                  ),
                );
              },
            ),
            const SizedBox(height: 12),
            _WearActionCard(
              icon: Icons.family_restroom,
              title: 'Family',
              subtitle: 'Location',
              color: const Color(0xFF2E8B57),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WearFamilyScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Tip for wrist raise
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.pan_tool,
                    size: 16,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Raise wrist to show permit',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _WearActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _WearActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5), width: 1),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 24, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 20,
                color: Colors.white.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
