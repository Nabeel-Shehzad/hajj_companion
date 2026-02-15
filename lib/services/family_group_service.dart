import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hajj_companion/models/family_group.dart';
import 'package:hajj_companion/models/family_member.dart';
import 'package:hajj_companion/services/device_id_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FamilyGroupService {
  static const String _currentGroupIdKey = 'current_group_id';

  final FirebaseFirestore _firestore;
  final DeviceIdService _deviceIdService;
  final SharedPreferences _prefs;

  FamilyGroupService(this._firestore, this._deviceIdService, this._prefs);

  /// Get the current group ID that this device belongs to
  String? getCurrentGroupId() {
    return _prefs.getString(_currentGroupIdKey);
  }

  /// Check if device is part of a family group
  bool isInGroup() {
    return getCurrentGroupId() != null;
  }

  /// Create a new family group
  Future<FamilyGroup> createGroup({
    required String groupName,
    required String adminDisplayName,
  }) async {
    final deviceId = _deviceIdService.getDeviceId();
    final joinCode = _deviceIdService.generateJoinCode();

    // Save display name locally
    await _deviceIdService.setDisplayName(adminDisplayName);

    // Create the group document
    final groupRef = _firestore.collection('family_groups').doc();
    final group = FamilyGroup(
      groupId: groupRef.id,
      groupName: groupName,
      adminDeviceId: deviceId,
      createdAt: DateTime.now(),
      joinCode: joinCode,
    );

    await groupRef.set(group.toFirestore());

    // Add the admin as the first member
    final member = FamilyMember(
      deviceId: deviceId,
      displayName: adminDisplayName,
      role: MemberRole.admin,
      isChild: false,
      joinedAt: DateTime.now(),
    );

    await groupRef
        .collection('members')
        .doc(deviceId)
        .set(member.toFirestore());

    // Save the group ID locally
    await _prefs.setString(_currentGroupIdKey, group.groupId);

    return group;
  }

  /// Join an existing family group using join code
  Future<FamilyGroup?> joinGroup({
    required String joinCode,
    required String displayName,
    bool isChild = false,
  }) async {
    final deviceId = _deviceIdService.getDeviceId();

    // Find the group with the matching join code
    final querySnapshot = await _firestore
        .collection('family_groups')
        .where('joinCode', isEqualTo: joinCode.toUpperCase())
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null; // Group not found
    }

    final groupDoc = querySnapshot.docs.first;
    final group = FamilyGroup.fromFirestore(groupDoc);

    // Save display name locally
    await _deviceIdService.setDisplayName(displayName);

    // Add this device as a member
    final member = FamilyMember(
      deviceId: deviceId,
      displayName: displayName,
      role: MemberRole.member,
      isChild: isChild,
      joinedAt: DateTime.now(),
      safeDistanceMeters: isChild ? 1000.0 : null, // Default 1km for children
    );

    await _firestore
        .collection('family_groups')
        .doc(group.groupId)
        .collection('members')
        .doc(deviceId)
        .set(member.toFirestore());

    // Save the group ID locally
    await _prefs.setString(_currentGroupIdKey, group.groupId);

    return group;
  }

  /// Get the current family group details
  Future<FamilyGroup?> getCurrentGroup() async {
    final groupId = getCurrentGroupId();
    if (groupId == null) return null;

    final doc = await _firestore.collection('family_groups').doc(groupId).get();

    if (!doc.exists) return null;

    return FamilyGroup.fromFirestore(doc);
  }

  /// Stream of members in the current group
  Stream<List<FamilyMember>> streamMembers() {
    final groupId = getCurrentGroupId();
    if (groupId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('family_groups')
        .doc(groupId)
        .collection('members')
        .orderBy('joinedAt')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => FamilyMember.fromFirestore(doc))
              .toList();
        });
  }

  /// Get all members in the current group
  Future<List<FamilyMember>> getMembers() async {
    final groupId = getCurrentGroupId();
    if (groupId == null) return [];

    final snapshot = await _firestore
        .collection('family_groups')
        .doc(groupId)
        .collection('members')
        .orderBy('joinedAt')
        .get();

    return snapshot.docs.map((doc) => FamilyMember.fromFirestore(doc)).toList();
  }

  /// Update member's safe distance (admin only)
  Future<void> updateMemberSafeDistance({
    required String memberDeviceId,
    required double distanceMeters,
  }) async {
    final groupId = getCurrentGroupId();
    if (groupId == null) return;

    await _firestore
        .collection('family_groups')
        .doc(groupId)
        .collection('members')
        .doc(memberDeviceId)
        .update({'safeDistanceMeters': distanceMeters});
  }

  /// Toggle member's child status (admin only)
  Future<void> toggleMemberChildStatus({
    required String memberDeviceId,
    required bool isChild,
  }) async {
    final groupId = getCurrentGroupId();
    if (groupId == null) return;

    final updateData = <String, dynamic>{'isChild': isChild};

    // Set default safe distance if marking as child
    if (isChild) {
      updateData['safeDistanceMeters'] = 1000.0;
    }

    await _firestore
        .collection('family_groups')
        .doc(groupId)
        .collection('members')
        .doc(memberDeviceId)
        .update(updateData);
  }

  /// Remove a member from the group (admin only)
  Future<void> removeMember(String memberDeviceId) async {
    final groupId = getCurrentGroupId();
    if (groupId == null) return;

    await _firestore
        .collection('family_groups')
        .doc(groupId)
        .collection('members')
        .doc(memberDeviceId)
        .delete();
  }

  /// Leave the current group
  Future<void> leaveGroup() async {
    final groupId = getCurrentGroupId();
    final deviceId = _deviceIdService.getDeviceId();

    if (groupId == null) return;

    // Remove this device from members
    await _firestore
        .collection('family_groups')
        .doc(groupId)
        .collection('members')
        .doc(deviceId)
        .delete();

    // Clear local group ID
    await _prefs.remove(_currentGroupIdKey);
  }

  /// Check if current device is admin
  Future<bool> isAdmin() async {
    final groupId = getCurrentGroupId();
    final deviceId = _deviceIdService.getDeviceId();

    if (groupId == null) return false;

    final group = await getCurrentGroup();
    return group?.adminDeviceId == deviceId;
  }

  /// Get member by device ID
  Future<FamilyMember?> getMember(String deviceId) async {
    final groupId = getCurrentGroupId();
    if (groupId == null) return null;

    final doc = await _firestore
        .collection('family_groups')
        .doc(groupId)
        .collection('members')
        .doc(deviceId)
        .get();

    if (!doc.exists) return null;

    return FamilyMember.fromFirestore(doc);
  }
}
