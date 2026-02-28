import 'dart:io';
import 'package:flutter/foundation.dart';

/// Utility class for platform detection and configuration
class PlatformUtils {
  /// Check if running on WearOS
  static bool get isWearOS {
    if (kIsWeb) return false;
    if (!Platform.isAndroid) return false;

    // In a real implementation, this would check Android's
    // Configuration.UI_MODE_TYPE_WATCH or screen dimensions
    // For now, we'll use a simple heuristic
    return false; // Will be determined by entry point
  }

  /// Check if running on mobile (phone/tablet)
  static bool get isMobile {
    return !isWearOS && (Platform.isAndroid || Platform.isIOS);
  }

  /// Get appropriate screen constraints for platform
  static ScreenConstraints get screenConstraints {
    if (isWearOS) {
      return const ScreenConstraints(
        minTouchTarget: 48.0,
        screenInset: 16.0,
        maxItemsPerScreen: 3,
        titleSize: 18.0,
        bodySize: 14.0,
        cardRadius: 12.0,
      );
    } else {
      return const ScreenConstraints(
        minTouchTarget: 44.0,
        screenInset: 16.0,
        maxItemsPerScreen: 6,
        titleSize: 24.0,
        bodySize: 16.0,
        cardRadius: 16.0,
      );
    }
  }
}

/// Platform-specific screen constraints
class ScreenConstraints {
  final double minTouchTarget;
  final double screenInset;
  final int maxItemsPerScreen;
  final double titleSize;
  final double bodySize;
  final double cardRadius;

  const ScreenConstraints({
    required this.minTouchTarget,
    required this.screenInset,
    required this.maxItemsPerScreen,
    required this.titleSize,
    required this.bodySize,
    required this.cardRadius,
  });
}

/// Device form factor
enum DeviceFormFactor { phone, tablet, watch, unknown }

/// Get device form factor based on screen size
DeviceFormFactor getDeviceFormFactor(double shortestSide) {
  if (shortestSide < 400) {
    return DeviceFormFactor.watch;
  } else if (shortestSide < 600) {
    return DeviceFormFactor.phone;
  } else {
    return DeviceFormFactor.tablet;
  }
}
