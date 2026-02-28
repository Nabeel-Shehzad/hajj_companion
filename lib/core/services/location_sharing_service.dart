import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hajj_companion/core/models/location_share.dart';
import 'package:hajj_companion/core/models/family_member.dart';
import 'package:hajj_companion/core/services/device_id_service.dart';
import 'package:hajj_companion/core/services/family_group_service.dart';
import 'package:hajj_companion/core/services/location_service.dart';
import 'package:hajj_companion/core/services/notification_service.dart';

class LocationSharingService {
  final FirebaseFirestore _firestore;
  final DeviceIdService _deviceIdService;
  final FamilyGroupService _groupService;
  final LocationService _locationService;
  final NotificationService _notificationService;

  StreamSubscription<Position>? _locationSubscription;
  Timer? _syncTimer;
  Timer? _alertCheckTimer;
  bool _isSharing = false;

  // Track which children have been alerted (to avoid repeated notifications)
  final Set<String> _alertedChildren = {};

  LocationSharingService(
    this._firestore,
    this._deviceIdService,
    this._groupService,
    this._locationService,
    this._notificationService,
  );

  bool get isSharing => _isSharing;

  /// Start sharing location with family group
  Future<void> startSharing() async {
    if (_isSharing) return;

    final groupId = _groupService.getCurrentGroupId();
    if (groupId == null) {
      throw Exception('Not in a family group');
    }

    _isSharing = true;

    // Share location immediately
    await _shareCurrentLocation();

    // Then sync every 30 seconds
    _syncTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _shareCurrentLocation();
    });

    // Check children distances every 30 seconds and send alerts
    _alertCheckTimer = Timer.periodic(const Duration(seconds: 30), (_) async {
      await _checkAndAlertDistances();
    });
  }

  /// Stop sharing location
  Future<void> stopSharing() async {
    _isSharing = false;
    _locationSubscription?.cancel();
    _locationSubscription = null;
    _syncTimer?.cancel();
    _syncTimer = null;
    _alertCheckTimer?.cancel();
    _alertCheckTimer = null;
    _alertedChildren.clear();
  }

  /// Share current location once
  Future<void> _shareCurrentLocation() async {
    try {
      final groupId = _groupService.getCurrentGroupId();
      if (groupId == null) return;

      final position = await _locationService.getCurrentLocation();
      if (position == null) return;

      final deviceId = _deviceIdService.getDeviceId();
      final displayName = _deviceIdService.getDisplayName() ?? 'Unknown';

      final locationShare = LocationShare.fromPosition(
        deviceId: deviceId,
        displayName: displayName,
        position: position,
      );

      await _firestore
          .collection('family_groups')
          .doc(groupId)
          .collection('locations')
          .doc(deviceId)
          .set(locationShare.toFirestore());
    } catch (e) {
      print('Error sharing location: $e');
    }
  }

  /// Stream all family members' locations
  Stream<List<LocationShare>> streamFamilyLocations() {
    final groupId = _groupService.getCurrentGroupId();
    if (groupId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('family_groups')
        .doc(groupId)
        .collection('locations')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => LocationShare.fromFirestore(doc))
              .toList();
        });
  }

  /// Get location of a specific family member
  Future<LocationShare?> getMemberLocation(String deviceId) async {
    final groupId = _groupService.getCurrentGroupId();
    if (groupId == null) return null;

    final doc = await _firestore
        .collection('family_groups')
        .doc(groupId)
        .collection('locations')
        .doc(deviceId)
        .get();

    if (!doc.exists) return null;

    return LocationShare.fromFirestore(doc);
  }

  /// Get locations of all family members with their member info
  Stream<List<MemberWithLocation>> streamMembersWithLocations() {
    final groupId = _groupService.getCurrentGroupId();
    if (groupId == null) {
      return Stream.value([]);
    }

    return _groupService.streamMembers().asyncMap((members) async {
      final List<MemberWithLocation> membersWithLocations = [];

      for (final member in members) {
        final location = await getMemberLocation(member.deviceId);
        membersWithLocations.add(
          MemberWithLocation(member: member, location: location),
        );
      }

      return membersWithLocations;
    });
  }

  /// Calculate distance from current device to a member
  Future<double?> getDistanceToMember(String memberDeviceId) async {
    try {
      final myPosition = await _locationService.getCurrentLocation();
      if (myPosition == null) return null;

      final memberLocation = await getMemberLocation(memberDeviceId);
      if (memberLocation == null) return null;

      return Geolocator.distanceBetween(
        myPosition.latitude,
        myPosition.longitude,
        memberLocation.latitude,
        memberLocation.longitude,
      );
    } catch (e) {
      print('Error calculating distance: $e');
      return null;
    }
  }

  /// Check if any children exceed their safe distance
  Future<List<DistanceAlert>> checkChildrenDistances() async {
    final alerts = <DistanceAlert>[];

    try {
      final members = await _groupService.getMembers();
      final children = members.where((m) => m.isChild).toList();

      for (final child in children) {
        if (child.safeDistanceMeters == null) continue;

        final distance = await getDistanceToMember(child.deviceId);
        if (distance == null) continue;

        if (distance > child.safeDistanceMeters!) {
          alerts.add(
            DistanceAlert(
              childMember: child,
              currentDistance: distance,
              safeDistance: child.safeDistanceMeters!,
              timestamp: DateTime.now(),
            ),
          );
        }
      }
    } catch (e) {
      print('Error checking children distances: $e');
    }

    return alerts;
  }

  /// Check distances and trigger notifications for children exceeding safe distance
  Future<void> _checkAndAlertDistances() async {
    try {
      // Only check if we're an admin/parent
      final isAdmin = await _groupService.isAdmin();
      if (!isAdmin) return;

      final alerts = await checkChildrenDistances();

      for (final alert in alerts) {
        final childId = alert.childMember.deviceId;

        // Only alert if not already alerted
        if (!_alertedChildren.contains(childId)) {
          await _notificationService.showDistanceAlert(
            child: alert.childMember,
            currentDistance: alert.currentDistance,
            safeDistance: alert.safeDistance,
          );
          _alertedChildren.add(childId);
        }
      }

      // Clear alerts for children who are back in safe zone
      final currentAlertedIds = alerts
          .map((a) => a.childMember.deviceId)
          .toSet();
      _alertedChildren.removeWhere((id) => !currentAlertedIds.contains(id));
    } catch (e) {
      print('Error checking and alerting distances: $e');
    }
  }

  /// Dispose and cleanup
  Future<void> dispose() async {
    await stopSharing();
  }
}

/// Helper class to combine member info with their location
class MemberWithLocation {
  final FamilyMember member;
  final LocationShare? location;

  MemberWithLocation({required this.member, this.location});

  double? get distanceFromMe => null; // Will be calculated by UI

  bool get hasLocation => location != null;

  bool get isLocationStale => location?.isStale() ?? true;
}

/// Distance alert for children exceeding safe distance
class DistanceAlert {
  final FamilyMember childMember;
  final double currentDistance;
  final double safeDistance;
  final DateTime timestamp;

  DistanceAlert({
    required this.childMember,
    required this.currentDistance,
    required this.safeDistance,
    required this.timestamp,
  });

  double get exceedBy => currentDistance - safeDistance;

  String get message =>
      '${childMember.displayName} is ${(currentDistance / 1000).toStringAsFixed(2)} km away '
      '(safe distance: ${(safeDistance / 1000).toStringAsFixed(2)} km)';
}
