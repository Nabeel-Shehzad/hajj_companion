import 'package:url_launcher/url_launcher.dart';
import '../models/location_share.dart';

/// Service for opening Google Maps with location data
class MapService {
  /// Open Google Maps to show a specific location
  static Future<void> openLocation({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open Google Maps');
    }
  }

  /// Open Google Maps to show a specific member's location
  static Future<void> openMemberLocation(LocationShare location) async {
    await openLocation(
      latitude: location.latitude,
      longitude: location.longitude,
      label: location.displayName,
    );
  }

  /// Open Google Maps with directions from current location to target
  static Future<void> openDirections({
    required double destinationLat,
    required double destinationLng,
    String? destinationName,
  }) async {
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open Google Maps');
    }
  }

  /// Open Google Maps with all family members' locations
  /// This will center the map on the first location and add markers for others
  static Future<void> openAllMembersMap(List<LocationShare> locations) async {
    if (locations.isEmpty) {
      throw Exception('No locations to display');
    }

    // Use the first location as the center point
    final center = locations.first;

    // Create a URL with the center point
    // Note: Google Maps URL API doesn't support multiple markers directly,
    // so we'll just center on the first location. For multiple markers,
    // you'd need to use the embedded Google Maps SDK or a custom implementation.
    final Uri googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=${center.latitude},${center.longitude}',
    );

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      throw Exception('Could not open Google Maps');
    }
  }
}
