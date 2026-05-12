import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hajj_companion/core/models/family_group.dart';
import 'package:hajj_companion/core/services/device_id_service.dart';
import 'package:hajj_companion/core/services/family_group_service.dart';
import 'package:hajj_companion/core/services/location_sharing_service.dart';
import 'package:hajj_companion/core/services/location_service.dart';
import 'package:hajj_companion/core/services/notification_service.dart';
import 'wear_join_group_screen.dart';

class WearFamilyScreen extends StatefulWidget {
  const WearFamilyScreen({super.key});

  @override
  State<WearFamilyScreen> createState() => _WearFamilyScreenState();
}

class _WearFamilyScreenState extends State<WearFamilyScreen> {
  // Nullable so dispose() is safe even if initServices hasn't completed yet
  DeviceIdService? _deviceIdService;
  FamilyGroupService? _groupService;
  LocationSharingService? _locationService;
  StreamSubscription<List<MemberWithLocation>>? _membersSubscription;

  bool _isLoading = true;
  bool _isInGroup = false;
  FamilyGroup? _currentGroup;
  List<MemberWithLocation> _members = [];

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    _deviceIdService = DeviceIdService(prefs);
    _groupService = FamilyGroupService(
      FirebaseFirestore.instance,
      _deviceIdService!,
      prefs,
    );
    _locationService = LocationSharingService(
      FirebaseFirestore.instance,
      _deviceIdService!,
      _groupService!,
      LocationService(),
      NotificationService(),
    );

    await _checkGroupStatus();
  }

  Future<void> _checkGroupStatus() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    _isInGroup = _groupService?.isInGroup() ?? false;

    if (_isInGroup && _groupService != null) {
      _currentGroup = await _groupService!.getCurrentGroup();
    } else {
      _currentGroup = null;
    }

    if (_isInGroup && _locationService != null) {
      // Cancel any existing subscription before creating a new one
      await _membersSubscription?.cancel();

      await _locationService!.startSharing();

      _membersSubscription = _locationService!
          .streamMembersWithLocations()
          .listen(
            (members) {
              if (mounted) setState(() => _members = members);
            },
            onError: (error) {
              // Firestore or network failure — keep showing last state
              if (mounted) setState(() => _members = []);
            },
          );
    } else {
      _members = [];
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _leaveGroup() async {
    final confirmed = await _showConfirmDialog(
      title: 'Leave Group',
      message: 'Leave "${_currentGroup?.groupName ?? 'this group'}"?\nYou\'ll need the join code to rejoin.',
      confirmLabel: 'Leave',
      isDestructive: true,
    );
    if (confirmed != true) return;

    setState(() => _isLoading = true);
    await _membersSubscription?.cancel();
    _membersSubscription = null;
    await _locationService?.stopSharing();
    await _groupService?.leaveGroup();
    await _checkGroupStatus();
  }

  Future<bool?> _showConfirmDialog({
    required String title,
    required String message,
    required String confirmLabel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        title: Text(title, style: const TextStyle(fontSize: 14, color: Colors.white)),
        content: Text(
          message,
          style: const TextStyle(fontSize: 11, color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(fontSize: 11)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(
              foregroundColor: isDestructive ? Colors.red : const Color(0xFF00A651),
            ),
            child: Text(
              confirmLabel,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _membersSubscription?.cancel();
    _locationService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isRound =
        screenSize.width == screenSize.height && screenSize.width >= 300;

    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF00A651)),
        ),
      );
    }

    if (!_isInGroup) {
      return _buildNoGroupView(isRound);
    }

    return _buildGroupView(isRound);
  }

  // ── NOT IN GROUP ──────────────────────────────────────────────────────────

  Widget _buildNoGroupView(bool isRound) {
  return Scaffold(
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isRound ? 24.0 : 16.0,
            vertical: 8.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.family_restroom,
                size: 34,
                color: Colors.white.withOpacity(0.4),
              ),

              const SizedBox(height: 10),

              Text(
                'No Family Group',
                style: TextStyle(
                  fontSize: isRound ? 12 : 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 5),

              Text(
                'Join a group to track your family\'s location.',
                style: TextStyle(
                  fontSize: isRound ? 8 : 10,
                  color: Colors.white.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 14),

              SizedBox(
                height: 34,
                child: ElevatedButton.icon(
                  onPressed: _navigateToJoin,
                  icon: const Icon(Icons.group_add, size: 12),
                  label: const Text(
                    'Join Group',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E8B57),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

  Future<void> _navigateToJoin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const WearJoinGroupScreen()),
    );
    if (result == true && mounted) {
      await _checkGroupStatus();
    }
  }

  // ── IN GROUP ──────────────────────────────────────────────────────────────

  Widget _buildGroupView(bool isRound) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
                    size: 16,
                    color: Color(0xFF2E8B57),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      _currentGroup?.groupName ?? 'Family',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // Member count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E8B57),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${_members.length}',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // Leave button
                  GestureDetector(
                    onTap: _leaveGroup,
                    child: Icon(
                      Icons.exit_to_app,
                      size: 16,
                      color: Colors.red.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),

            // ── Join code row ──
            if (_currentGroup != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                color: Colors.white.withOpacity(0.04),
                child: Row(
                  children: [
                    Icon(
                      Icons.vpn_key,
                      size: 11,
                      color: Colors.white.withOpacity(0.4),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Code: ',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.4),
                      ),
                    ),
                    Text(
                      _currentGroup!.joinCode,
                      style: const TextStyle(
                        fontSize: 11,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD4AF37),
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),

            // ── Members list ──
            Expanded(
              child: _members.isEmpty
                  ? _buildEmptyMembersView(isRound)
                  : ListView.builder(
                      padding: EdgeInsets.symmetric(
                        horizontal: isRound ? 20 : 10,
                        vertical: 8,
                      ),
                      itemCount: _members.length,
                      itemBuilder: (context, index) =>
                          _buildMemberCard(_members[index], isRound),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyMembersView(bool isRound) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isRound ? 24.0 : 16.0),
        child: Text(
          'Waiting for members...',
          style: TextStyle(
            fontSize: 11,
            color: Colors.white.withOpacity(0.5),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildMemberCard(MemberWithLocation mwl, bool isRound) {
    final member = mwl.member;
    final hasLocation = mwl.hasLocation;
    final isStale = mwl.isLocationStale;
    final myDeviceId = _deviceIdService?.getDeviceId();
    final isMe = member.deviceId == myDeviceId;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: member.isChild
                    ? Colors.orange.withOpacity(0.3)
                    : const Color(0xFF2E8B57).withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                member.isChild ? Icons.child_care : Icons.person,
                size: 16,
                color: member.isChild
                    ? Colors.orange
                    : const Color(0xFF2E8B57),
              ),
            ),
            const SizedBox(width: 8),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + badges
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          member.displayName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isMe) ...[
                        const SizedBox(width: 3),
                        _badge('YOU', const Color(0xFF00A651)),
                      ],
                      if (member.isAdmin) ...[
                        const SizedBox(width: 3),
                        _badge('ADMIN', const Color(0xFFD4AF37)),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),

                  // Location status
                  Row(
                    children: [
                      Icon(
                        hasLocation
                            ? (isStale ? Icons.location_on : Icons.location_on)
                            : Icons.location_off,
                        size: 9,
                        color: hasLocation
                            ? (isStale ? Colors.orange : Colors.green)
                            : Colors.grey,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        hasLocation
                            ? (isStale ? 'Last seen (stale)' : 'Live location')
                            : 'No location',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.white.withOpacity(0.5),
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

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5), width: 0.5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 7,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}
