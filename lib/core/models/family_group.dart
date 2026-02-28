import 'package:cloud_firestore/cloud_firestore.dart';

class FamilyGroup {
  final String groupId;
  final String groupName;
  final String adminDeviceId;
  final DateTime createdAt;
  final String joinCode;

  FamilyGroup({
    required this.groupId,
    required this.groupName,
    required this.adminDeviceId,
    required this.createdAt,
    required this.joinCode,
  });

  // Convert Firestore document to FamilyGroup object
  factory FamilyGroup.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FamilyGroup(
      groupId: doc.id,
      groupName: data['groupName'] ?? '',
      adminDeviceId: data['adminDeviceId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      joinCode: data['joinCode'] ?? '',
    );
  }

  // Convert FamilyGroup object to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'groupName': groupName,
      'adminDeviceId': adminDeviceId,
      'createdAt': Timestamp.fromDate(createdAt),
      'joinCode': joinCode,
    };
  }

  // Create a copy with updated fields
  FamilyGroup copyWith({
    String? groupId,
    String? groupName,
    String? adminDeviceId,
    DateTime? createdAt,
    String? joinCode,
  }) {
    return FamilyGroup(
      groupId: groupId ?? this.groupId,
      groupName: groupName ?? this.groupName,
      adminDeviceId: adminDeviceId ?? this.adminDeviceId,
      createdAt: createdAt ?? this.createdAt,
      joinCode: joinCode ?? this.joinCode,
    );
  }
}
