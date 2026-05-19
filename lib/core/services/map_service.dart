import 'package:url_launcher/url_launcher.dart';
import '../models/location_share.dart';

/// Service for opening Google Maps with location data
class MapService {
  /// Try to launch a list of URIs in order. Returns true if any launched.
  static Future<bool> _tryLaunchAny(List<Uri> uris) async {
    for (final uri in uris) {
      try {
        final ok = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (ok) return true;
      } catch (_) {
        // try next
      }
    }
    return false;
  }

  /// Open Google Maps to show a specific location
  static Future<void> openLocation({
    required double latitude,
    required double longitude,
    String? label,
  }) async {
    final encodedLabel = label != null ? Uri.encodeComponent(label) : '';
    final geoUri = Uri.parse(
      label != null
          ? 'geo:$latitude,$longitude?q=$latitude,$longitude($encodedLabel)'
          : 'geo:$latitude,$longitude?q=$latitude,$longitude',
    );
    final webUri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude',
    );

    final launched = await _tryLaunchAny([geoUri, webUri]);
    if (!launched) {
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
    // Native Google Maps directions intent on Android
    final nativeUri = Uri.parse(
      'google.navigation:q=$destinationLat,$destinationLng',
    );
    final webUri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=$destinationLat,$destinationLng',
    );

    final launched = await _tryLaunchAny([nativeUri, webUri]);
    if (!launched) {
      throw Exception('Could not open Google Maps');
    }
  }

  /// Open Google Maps with all family members' locations
  /// Centers on the first location (Google Maps URL API doesn't support
  /// multiple markers in a single static link).
  static Future<void> openAllMembersMap(List<LocationShare> locations) async {
    if (locations.isEmpty) {
      throw Exception('No locations to display');
    }

    final center = locations.first;
    await openLocation(
      latitude: center.latitude,
      longitude: center.longitude,
      label: center.displayName,
    );
  }
}
