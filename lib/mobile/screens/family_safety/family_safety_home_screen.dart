import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hajj_companion/core/models/family_group.dart';
import 'package:hajj_companion/core/services/device_id_service.dart';
import 'package:hajj_companion/core/services/family_group_service.dart';
import 'package:hajj_companion/core/utils/app_localizations.dart';
import 'package:hajj_companion/core/providers/language_provider.dart';
import 'create_group_screen.dart';
import 'join_group_screen.dart';
import 'family_members_screen.dart';
import 'qr_code_display_dialog.dart';

class FamilySafetyHomeScreen extends StatefulWidget {
  final DeviceIdService deviceIdService;
  final FamilyGroupService groupService;

  const FamilySafetyHomeScreen({
    super.key,
    required this.deviceIdService,
    required this.groupService,
  });

  @override
  State<FamilySafetyHomeScreen> createState() => _FamilySafetyHomeScreenState();
}

class _FamilySafetyHomeScreenState extends State<FamilySafetyHomeScreen> {
  bool _isLoading = true;
  FamilyGroup? _currentGroup;

  @override
  void initState() {
    super.initState();
    _loadGroupStatus();
  }

  Future<void> _loadGroupStatus() async {
    setState(() => _isLoading = true);
    final group = await widget.groupService.getCurrentGroup();
    setState(() {
      _currentGroup = group;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = LanguageProvider.of(context);
    final tr = provider?.localizations;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr?.familySafetyTitle ?? 'Family Safety'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentGroup != null
              ? _buildGroupView(tr)
              : _buildNoGroupView(tr),
    );
  }

  Widget _buildNoGroupView(AppLocalizations? tr) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.family_restroom, size: 80, color: Colors.green),
            const SizedBox(height: 24),
            Text(
              tr?.keepFamilySafe ?? 'Keep Your Family Safe',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              tr?.familySafetyDesc ??
                  'Share your location with family members and get alerted if children exceed safe distances.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _navigateToCreateGroup,
                icon: const Icon(Icons.add),
                label: Text(tr?.createFamilyGroup ?? 'Create Family Group'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _navigateToJoinGroup,
                icon: const Icon(Icons.group_add),
                label: Text(tr?.joinExistingGroup ?? 'Join Existing Group'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.green,
                  side: const BorderSide(color: Colors.green),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupView(AppLocalizations? tr) {
    final deviceId = widget.deviceIdService.getDeviceId();
    final isAdmin = _currentGroup!.adminDeviceId == deviceId;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.group, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _currentGroup!.groupName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (isAdmin)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            tr?.adminBadge ?? 'ADMIN',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        '${tr?.joinCodeLabel ?? 'Join Code'}: ',
                        style:
                            const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _currentGroup!.joinCode,
                        style: const TextStyle(
                          fontSize: 18,
                          fontFamily: 'monospace',
                          color: Colors.green,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.qr_code),
                        onPressed: _showQrCode,
                        tooltip: tr?.showQrCode ?? 'Show QR code',
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () => _copyJoinCode(tr),
                        tooltip: tr?.copyJoinCodeLabel ?? 'Copy join code',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _navigateToMembersScreen,
              icon: const Icon(Icons.location_on),
              label:
                  Text(tr?.viewFamilyLocations ?? 'View Family Locations'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () => _confirmLeaveGroup(tr),
              icon: const Icon(Icons.exit_to_app),
              label: Text(tr?.leaveGroup ?? 'Leave Group'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToCreateGroup() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateGroupScreen(
          deviceIdService: widget.deviceIdService,
          groupService: widget.groupService,
        ),
      ),
    );
    if (result == true) _loadGroupStatus();
  }

  Future<void> _navigateToJoinGroup() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JoinGroupScreen(
          deviceIdService: widget.deviceIdService,
          groupService: widget.groupService,
        ),
      ),
    );
    if (result == true) _loadGroupStatus();
  }

  Future<void> _navigateToMembersScreen() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FamilyMembersScreen(
          deviceIdService: widget.deviceIdService,
          groupService: widget.groupService,
        ),
      ),
    );
  }

  Future<void> _confirmLeaveGroup(AppLocalizations? tr) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tr?.leaveGroup ?? 'Leave Group'),
        content: Text(
          tr?.leaveGroupConfirm ??
              'Are you sure you want to leave this family group? You will need a join code to rejoin.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(tr?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(tr?.leave ?? 'Leave'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await widget.groupService.leaveGroup();
      _loadGroupStatus();
    }
  }

  void _showQrCode() {
    if (_currentGroup == null) return;
    showDialog(
      context: context,
      builder: (context) => QrCodeDisplayDialog(
        joinCode: _currentGroup!.joinCode,
        groupName: _currentGroup!.groupName,
      ),
    );
  }

  void _copyJoinCode(AppLocalizations? tr) {
    if (_currentGroup == null) return;
    Clipboard.setData(ClipboardData(text: _currentGroup!.joinCode));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            Text(tr?.joinCodeCopied ?? 'Join code copied to clipboard!'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
