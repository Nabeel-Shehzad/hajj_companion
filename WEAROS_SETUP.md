# WearOS Companion App Setup Guide

## 🎯 Project Architecture

This project now supports both **Mobile** and **WearOS** platforms with a shared codebase.

```
hajj_companion/
├── lib/
│   ├── core/                    # Shared business logic
│   │   ├── models/              # Data models
│   │   ├── services/            # Business services
│   │   ├── database/            # Drift database
│   │   └── utils/               # Utilities
│   ├── mobile/                  # Phone-specific UI
│   │   └── screens/             # Mobile screens
│   ├── wear/                    # Watch-specific UI
│   │   └── screens/             # WearOS screens
│   ├── main_mobile.dart         # Mobile entry point
│   └── main_wear.dart           # WearOS entry point
├── android/                     # Mobile Android module
└── wear/                        # WearOS Android module
```

## 📱 Features by Platform

### Mobile App (Full-Featured)
- ✅ Digital permit entry & display
- ✅ AI chatbot with Gemini
- ✅ Family group management
- ✅ Ritual guidance with GPS
- ✅ Comprehensive settings
- ✅ Location tracking & maps

### WearOS App (Optimized for Watch)
- ✅ Quick permit display (wrist raise gesture)
- ✅ Ritual dua notifications
- ✅ Distance alerts for children
- ✅ Minimal interaction required
- ✅ Ambient mode support
- ✅ Rotary input support

## 🛠️ Setup Instructions

### 1. Prerequisites
```bash
Flutter SDK: 3.10.1+
Android Studio (with WearOS emulator)
Physical WearOS device (optional but recommended)
```

### 2. Create WearOS Emulator
1. Open Android Studio
2. Tools → Device Manager → Create Virtual Device
3. Choose **Wear OS** category
4. Select device (e.g., "Wear OS Small Round")
5. Download and select system image (API 30+)
6. Finish setup

### 3. Build Mobile App
```bash
# Run on phone/emulator
flutter run -t lib/main_mobile.dart
```

### 4. Build WearOS App
```bash
# Run on watch/emulator
flutter run -t lib/main_wear.dart
```

### 5. Install Both Apps
```bash
# Mobile
flutter build apk -t lib/main_mobile.dart
adb -s <phone_device_id> install build/app/outputs/apk/release/app-release.apk

# Wear
flutter build apk -t lib/main_wear.dart
adb -s <wear_device_id> install build/app/outputs/apk/release/app-release.apk
```

## 🔧 Development Tips

### Hot Reload on WearOS
```bash
flutter run -t lib/main_wear.dart --hot
# Press 'r' for hot reload
# Press 'R' for hot restart
```

### Debug on Physical Watch
1. Enable Developer Options on watch (tap build number 7 times)
2. Enable ADB debugging
3. Connect via Wi-Fi or Bluetooth
4. Run: `adb connect <watch_ip>:5555`

### Screen Sizes
- Small Round: 320x320 (1.4")
- Large Round: 454x454 (1.6")
- Small Square: 280x280
- Target smallest: 320x320

### Best Practices for WearOS
- ✅ Large tap targets (min 48x48 dp)
- ✅ Simple navigation (max 2 levels deep)
- ✅ Dark theme (battery saving on OLED)
- ✅ Quick interactions (<3 seconds)
- ✅ Haptic feedback for confirmations
- ✅ Support rotary input (crown)

## 🎨 WearOS Design Guidelines

### Layout Constraints
```dart
// Minimum touch target
const kMinTouchTarget = 48.0;

// Screen insets for round displays
const kRoundInset = 16.0;

// Maximum items per screen
const kMaxItemsPerScreen = 3;

// Text sizes
const kTitleSize = 18.0;
const kBodySize = 14.0;
```

### Navigation Patterns
- **Single tap** - Primary action
- **Long press** - Secondary action
- **Swipe right** - Back/Cancel
- **Swipe left** - Next/Confirm
- **Crown rotation** - Scroll list

### Battery Optimization
- Use ambient mode for always-on display
- Minimize GPS polling frequency
- Reduce animation complexity
- Use dark colors (OLED power saving)

## 📊 Data Sync Strategy

### Mobile ↔ WearOS Communication
```
Phone App                    WearOS App
├── Create permit           ├── Read permit
├── Manage family           ├── Show alerts
├── Configure settings      ├── Apply settings
└── Sync data ──────────────→ └── Display data
```

### Sync Methods (Future Implementation)
1. **Local Sync** - Via Bluetooth/Wi-Fi (phone ↔ watch)
2. **Cloud Sync** - Via Firebase (when online)
3. **Manual Sync** - User-triggered backup/restore

## 🧪 Testing Checklist

### WearOS Emulator
- [ ] Permit display renders correctly
- [ ] QR code is scannable
- [ ] Dua cards are readable
- [ ] Haptic feedback works
- [ ] Navigation is smooth
- [ ] Rotary input works (if supported)

### Physical Watch
- [ ] GPS accuracy tested in field
- [ ] Battery consumption acceptable
- [ ] Always-on display works
- [ ] Wrist gestures detected
- [ ] Notifications appear promptly

## 🚀 Deployment

### Generate Signed APKs
```bash
# Mobile (Google Play Store)
flutter build appbundle -t lib/main_mobile.dart --release

# WearOS (Google Play Store - Wear section)
flutter build appbundle -t lib/main_wear.dart --release
```

### Version Management
Keep versions synchronized in `pubspec.yaml`:
```yaml
version: 1.0.0+1  # Same for both mobile and wear
```

## 📚 Resources

- [WearOS Design Guidelines](https://developer.android.com/design/ui/wear)
- [Flutter WearOS Support](https://docs.flutter.dev/deployment/android#building-for-wear-os)
- [WearOS Best Practices](https://developer.android.com/training/wearables/apps/always-on)

## 🐛 Troubleshooting

### "Device not found"
```bash
adb devices  # Check connected devices
adb kill-server && adb start-server  # Restart ADB
```

### "Widgets not rendering"
- Check screen size constraints
- Verify BoxFit.contain on images
- Use FittedBox for text scaling

### "GPS not working on watch"
- Ensure location permissions granted
- WearOS needs paired phone for assisted GPS
- Test outdoors for clear sky view

---

**Author:** Nabeel Shehzad  
**Last Updated:** February 28, 2026  
**Status:** ✅ WearOS Support Active
