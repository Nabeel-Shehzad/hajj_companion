import 'package:cloud_firestore/cloud_firestore.dart';

enum MemberRole { admin, member }

class FamilyMember {
  final String deviceId;
  final String displayName;
  final MemberRole role;
  final bool isChild;
  final DateTime joinedAt;
  final double? safeDistanceMeters; // Only for children

  FamilyMember({
    required this.deviceId,
    required this.displayName,
    required this.role,
    required this.isChild,
    required this.joinedAt,
    this.safeDistanceMeters,
  });

  // Convert Firestore document to FamilyMember object
  factory FamilyMember.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FamilyMember(
      deviceId: doc.id,
      displayName: data['displayName'] ?? '',
      role: data['role'] == 'admin' ? MemberRole.admin : MemberRole.member,
      isChild: data['isChild'] ?? false,
      joinedAt: (data['joinedAt'] as Timestamp).toDate(),
      safeDistanceMeters: data['safeDistanceMeters']?.toDouble(),
    );
  }

  // Convert FamilyMember object to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'role': role == MemberRole.admin ? 'admin' : 'member',
      'isChild': isChild,
      'joinedAt': Timestamp.fromDate(joinedAt),
      if (safeDistanceMeters != null) 'safeDistanceMeters': safeDistanceMeters,
    };
  }

  // Create a copy with updated fields
  FamilyMember copyWith({
    String? deviceId,
    String? displayName,
    MemberRole? role,
    bool? isChild,
    DateTime? joinedAt,
    double? safeDistanceMeters,
  }) {
    return FamilyMember(
      deviceId: deviceId ?? this.deviceId,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      isChild: isChild ?? this.isChild,
      joinedAt: joinedAt ?? this.joinedAt,
      safeDistanceMeters: safeDistanceMeters ?? this.safeDistanceMeters,
    );
  }

  bool get isAdmin => role == MemberRole.admin;
}
