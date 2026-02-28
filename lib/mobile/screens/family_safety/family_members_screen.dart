import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hajj_companion/core/models/family_member.dart';
import 'package:hajj_companion/core/models/location_share.dart';
import 'package:hajj_companion/core/services/device_id_service.dart';
import 'package:hajj_companion/core/services/family_group_service.dart';
import 'package:hajj_companion/core/services/location_sharing_service.dart';
import 'package:hajj_companion/core/services/location_service.dart';
import 'package:hajj_companion/core/services/notification_service.dart';
import 'package:hajj_companion/core/services/map_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class FamilyMembersScreen extends StatefulWidget {
  final DeviceIdService deviceIdService;
  final FamilyGroupService groupService;

  const FamilyMembersScreen({
    super.key,
    required this.deviceIdService,
    required this.groupService,
  });

  @override
  State<FamilyMembersScreen> createState() => _FamilyMembersScreenState();
}

class _FamilyMembersScreenState extends State<FamilyMembersScreen> {
  late LocationSharingService _locationSharingService;
  late LocationService _locationService;
  Position? _myPosition;
  Timer? _locationTimer;
  bool _isSharing = false;

  @override
  void initState() {
    super.initState();
    _locationService = LocationService();
    _locationSharingService = LocationSharingService(
      FirebaseFirestore.instance,
      widget.deviceIdService,
      widget.groupService,
      _locationService,
      NotificationService(),
    );
    _startLocationSharing();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    _locationSharingService.dispose();
    super.dispose();
  }

  Future<void> _startLocationSharing() async {
    try {
      await _locationSharingService.startSharing();
      setState(() => _isSharing = true);

      // Update my position periodically
      _locationTimer = Timer.periodic(const Duration(seconds: 5), (_) async {
        try {
          final position = await _locationService.getCurrentLocation();
          setState(() => _myPosition = position);
        } catch (e) {
          print('Error getting position: $e');
        }
      });

      // Get initial position
      _myPosition = await _locationService.getCurrentLocation();
      setState(() {});
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting location sharing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final myDeviceId = widget.deviceIdService.getDeviceId();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Locations'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isSharing ? Icons.stop_circle : Icons.play_circle),
            onPressed: _toggleLocationSharing,
            tooltip: _isSharing ? 'Stop sharing' : 'Start sharing',
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_isSharing)
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.orange.shade100,
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange.shade700),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Location sharing is paused',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: StreamBuilder<List<LocationShare>>(
              stream: _locationSharingService.streamFamilyLocations(),
              builder: (context, locationsSnapshot) {
                if (locationsSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (locationsSnapshot.hasError) {
                  return Center(
                    child: Text('Error: ${locationsSnapshot.error}'),
                  );
                }

                final locations = locationsSnapshot.data ?? [];

                return StreamBuilder<List<FamilyMember>>(
                  stream: widget.groupService.streamMembers(),
                  builder: (context, membersSnapshot) {
                    if (membersSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (membersSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${membersSnapshot.error}'),
                      );
                    }

                    final members = membersSnapshot.data ?? [];

                    if (members.isEmpty) {
                      return const Center(child: Text('No family members yet'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: members.length,
                      itemBuilder: (context, index) {
                        final member = members[index];
                        final location = locations.firstWhere(
                          (loc) => loc.deviceId == member.deviceId,
                          orElse: () => LocationShare(
                            deviceId: member.deviceId,
                            displayName: member.displayName,
                            latitude: 0,
                            longitude: 0,
                            accuracy: 0,
                            timestamp: DateTime.now(),
                          ),
                        );

                        final isMe = member.deviceId == myDeviceId;
                        final hasLocation = location.latitude != 0;

                        return _buildMemberCard(
                          member: member,
                          location: hasLocation ? location : null,
                          isMe: isMe,
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: StreamBuilder<List<LocationShare>>(
        stream: _locationSharingService.streamFamilyLocations(),
        builder: (context, snapshot) {
          final locations = (snapshot.data ?? [])
              .where((loc) => loc.latitude != 0 && loc.longitude != 0)
              .toList();

          if (locations.isEmpty) return const SizedBox.shrink();

          return FloatingActionButton.extended(
            onPressed: () => _openAllMembersMap(locations),
            backgroundColor: Colors.green,
            icon: const Icon(Icons.map),
            label: const Text('View All on Map'),
          );
        },
      ),
    );
  }

  Widget _buildMemberCard({
    required FamilyMember member,
    required LocationShare? location,
    required bool isMe,
  }) {
    final hasLocation = location != null;
    final isStale = location?.isStale() ?? true;

    double? distance;
    if (hasLocation && !isMe && _myPosition != null) {
      distance = Geolocator.distanceBetween(
        _myPosition!.latitude,
        _myPosition!.longitude,
        location.latitude,
        location.longitude,
      );
    }

    final isBeyondSafeDistance =
        member.isChild &&
        member.safeDistanceMeters != null &&
        distance != null &&
        distance > member.safeDistanceMeters!;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isBeyondSafeDistance ? Colors.red.shade50 : null,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isMe
              ? Colors.green
              : member.isChild
              ? Colors.blue
              : Colors.grey,
          child: Icon(
            member.isChild ? Icons.child_care : Icons.person,
            color: Colors.white,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                member.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (isMe)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'YOU',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
            if (member.isAdmin)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                margin: const EdgeInsets.only(left: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'ADMIN',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (!hasLocation)
              const Text(
                'Location not available',
                style: TextStyle(color: Colors.grey),
              )
            else ...[
              if (isStale)
                Text(
                  'Last seen ${_formatTimestamp(location.timestamp)}',
                  style: const TextStyle(color: Colors.orange),
                )
              else
                Text(
                  'Updated ${_formatTimestamp(location.timestamp)}',
                  style: const TextStyle(color: Colors.green),
                ),
              if (distance != null && !isMe) ...[
                const SizedBox(height: 2),
                Text(
                  _formatDistance(distance),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isBeyondSafeDistance ? Colors.red : Colors.black87,
                  ),
                ),
              ],
              if (member.isChild && member.safeDistanceMeters != null) ...[
                const SizedBox(height: 2),
                Text(
                  'Safe distance: ${_formatDistance(member.safeDistanceMeters!)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ],
          ],
        ),
        trailing: hasLocation && !isMe
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.directions, color: Colors.blue),
                    tooltip: 'Get directions',
                    onPressed: () => _openDirections(location),
                  ),
                  IconButton(
                    icon: const Icon(Icons.map, color: Colors.green),
                    tooltip: 'View on map',
                    onPressed: () => _openMemberLocation(location),
                  ),
                  if (isBeyondSafeDistance)
                    const Icon(Icons.warning, color: Colors.red)
                  else if (!isStale)
                    const Icon(Icons.location_on, color: Colors.green),
                ],
              )
            : isBeyondSafeDistance
            ? const Icon(Icons.warning, color: Colors.red)
            : hasLocation && !isStale
            ? const Icon(Icons.location_on, color: Colors.green)
            : null,
      ),
    );
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m away';
    } else {
      return '${(meters / 1000).toStringAsFixed(2)} km away';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  Future<void> _toggleLocationSharing() async {
    if (_isSharing) {
      await _locationSharingService.stopSharing();
      _locationTimer?.cancel();
      setState(() => _isSharing = false);
    } else {
      await _startLocationSharing();
    }
  }

  Future<void> _openMemberLocation(LocationShare location) async {
    try {
      await MapService.openMemberLocation(location);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening map: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openDirections(LocationShare location) async {
    try {
      await MapService.openDirections(
        destinationLat: location.latitude,
        destinationLng: location.longitude,
        destinationName: location.displayName,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening directions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _openAllMembersMap(List<LocationShare> locations) async {
    try {
      await MapService.openAllMembersMap(locations);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening map: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
