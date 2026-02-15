import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class LocationShare {
  final String deviceId;
  final String displayName;
  final double latitude;
  final double longitude;
  final double accuracy;
  final DateTime timestamp;

  LocationShare({
    required this.deviceId,
    required this.displayName,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.timestamp,
  });

  // Convert Firestore document to LocationShare object
  factory LocationShare.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LocationShare(
      deviceId: doc.id,
      displayName: data['displayName'] ?? '',
      latitude: data['latitude']?.toDouble() ?? 0.0,
      longitude: data['longitude']?.toDouble() ?? 0.0,
      accuracy: data['accuracy']?.toDouble() ?? 0.0,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Convert LocationShare object to Firestore map
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'latitude': latitude,
      'longitude': longitude,
      'accuracy': accuracy,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }

  // Create LocationShare from Position object
  factory LocationShare.fromPosition({
    required String deviceId,
    required String displayName,
    required Position position,
  }) {
    return LocationShare(
      deviceId: deviceId,
      displayName: displayName,
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: position.timestamp,
    );
  }

  // Calculate distance to another location in meters
  double distanceTo(LocationShare other) {
    return Geolocator.distanceBetween(
      latitude,
      longitude,
      other.latitude,
      other.longitude,
    );
  }

  // Check if location is stale (older than threshold)
  bool isStale({Duration threshold = const Duration(minutes: 2)}) {
    return DateTime.now().difference(timestamp) > threshold;
  }

  // Create a copy with updated fields
  LocationShare copyWith({
    String? deviceId,
    String? displayName,
    double? latitude,
    double? longitude,
    double? accuracy,
    DateTime? timestamp,
  }) {
    return LocationShare(
      deviceId: deviceId ?? this.deviceId,
      displayName: displayName ?? this.displayName,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracy: accuracy ?? this.accuracy,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
