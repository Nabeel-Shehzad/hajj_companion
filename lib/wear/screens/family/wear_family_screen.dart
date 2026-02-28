import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hajj_companion/core/services/device_id_service.dart';
import 'package:hajj_companion/core/services/family_group_service.dart';
import 'package:hajj_companion/core/services/location_sharing_service.dart';
import 'package:hajj_companion/core/services/location_service.dart';
import 'package:hajj_companion/core/services/notification_service.dart';

class WearFamilyScreen extends StatefulWidget {
  const WearFamilyScreen({super.key});

  @override
  State<WearFamilyScreen> createState() => _WearFamilyScreenState();
}

class _WearFamilyScreenState extends State<WearFamilyScreen> {
  late FamilyGroupService _groupService;
  late LocationSharingService _locationService;
  bool _isInGroup = false;
  bool _isLoading = true;
  List<MemberWithLocation> _members = [];

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    final deviceIdService = DeviceIdService(prefs);
    _groupService = FamilyGroupService(
      FirebaseFirestore.instance,
      deviceIdService,
      prefs,
    );
    _locationService = LocationSharingService(
      FirebaseFirestore.instance,
      deviceIdService,
      _groupService,
      LocationService(),
      NotificationService(),
    );

    _checkGroupStatus();
  }

  Future<void> _checkGroupStatus() async {
    setState(() => _isLoading = true);

    _isInGroup = _groupService.isInGroup();

    if (_isInGroup) {
      // Start location sharing
      await _locationService.startSharing();

      // Listen to member locations
      _locationService.streamMembersWithLocations().listen((members) {
        if (mounted) {
          setState(() {
            _members = members;
          });
        }
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _locationService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isRound = screenSize.width == screenSize.height;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00A651)),
        ),
      );
    }

    if (!_isInGroup) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(isRound ? 24.0 : 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.family_restroom,
                    size: 48,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Not in a family group',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create or join a group on phone app',
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2E8B57).withOpacity(0.3),
                border: Border(
                  bottom: BorderSide(
                    color: const Color(0xFF2E8B57).withOpacity(0.5),
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.family_restroom,
                    size: 20,
                    color: Color(0xFF2E8B57),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Family Members',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_members.length}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Members List
            Expanded(
              child: _members.isEmpty
                  ? _buildEmptyView(isRound)
                  : ListView.builder(
                      padding: EdgeInsets.all(isRound ? 16 : 12),
                      itemCount: _members.length,
                      itemBuilder: (context, index) {
                        return _buildMemberCard(_members[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(bool isRound) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isRound ? 24.0 : 16.0),
        child: Text(
          'Loading members...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildMemberCard(MemberWithLocation memberWithLocation) {
    final member = memberWithLocation.member;
    final location = memberWithLocation.location;
    final hasLocation = location != null;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: member.isChild
                    ? Colors.orange.withOpacity(0.3)
                    : const Color(0xFF2E8B57).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                member.isChild ? Icons.child_care : Icons.person,
                size: 18,
                color: member.isChild ? Colors.orange : const Color(0xFF2E8B57),
              ),
            ),
            const SizedBox(width: 10),

            // Member Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.displayName,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (member.isAdmin) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD4AF37).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'ADMIN',
                            style: TextStyle(
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        hasLocation ? Icons.location_on : Icons.location_off,
                        size: 10,
                        color: hasLocation ? Colors.green : Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        hasLocation ? 'Location active' : 'No location',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
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
