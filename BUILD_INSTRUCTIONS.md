# 🚀 Build & Run Instructions

## Quick Start

### Mobile App (Phone/Tablet)
```bash
# Check connected devices
flutter devices

# Run on mobile device/emulator
flutter run -t lib/main_mobile.dart

# Build APK for testing
flutter build apk -t lib/main_mobile.dart

# Build for Play Store
flutter build appbundle -t lib/main_mobile.dart
```

### WearOS App (Smartwatch)
```bash
# Run on WearOS emulator/device
flutter run -t lib/main_wear.dart

# Build APK for testing
flutter build apk -t lib/main_wear.dart

# Build for Play Store
flutter build appbundle -t lib/main_wear.dart
```

## Setup WearOS Emulator

1. **Open Android Studio**
2. **Tools → Device Manager**
3. **Create Virtual Device → Wear OS**
4. Choose a device:
   - Wear OS Small Round (320x320)
   - Wear OS Large Round (454x454)
5. **Download system image (API 30+)**
6. **Finish and start emulator**

## Install on Physical Devices

### Mobile Phone
```bash
# Build APK
flutter build apk -t lib/main_mobile.dart --release

# Install
adb -d install build/app/outputs/apk/release/app-release.apk
```

### WearOS Watch
```bash
# Enable Developer Options on watch:
# Settings → System → About → Tap Build Number 7 times

# Enable ADB debugging
# Settings → Developer Options → ADB Debugging

# Connect to watch
adb connect <watch_ip_address>:5555

# Build and install
flutter build apk -t lib/main_wear.dart --release
adb -s <watch_device_id> install build/app/outputs/apk/release/app-release.apk
```

## Development Workflow

### Hot Reload (Faster Development)
```bash
# Mobile
flutter run -t lib/main_mobile.dart --hot

# WearOS
flutter run -t lib/main_wear.dart --hot

# Press 'r' in terminal for hot reload
# Press 'R' for full restart
```

### Check for Errors
```bash
flutter analyze
dart format lib/
```

### Run Code Generation (After Drift Changes)
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Build Variants

### Debug (Development)
```bash
flutter run -t lib/main_mobile.dart --debug
```

### Profile (Performance Testing)
```bash
flutter run -t lib/main_mobile.dart --profile
```

### Release (Production)
```bash
flutter build apk -t lib/main_mobile.dart --release
flutter build appbundle -t lib/main_mobile.dart --release
```

## Signing for Release

### 1. Create Keystore
```bash
keytool -genkey -v -keystore hajj-companion-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias hajj-companion
```

### 2. Create `android/key.properties`
```properties
storePassword=<your_store_password>
keyPassword=<your_key_password>
keyAlias=hajj-companion
storeFile=../../hajj-companion-key.jks
```

### 3. Build Signed APK/AAB
```bash
# Mobile
flutter build appbundle -t lib/main_mobile.dart --release

# Wear
flutter build appbundle -t lib/main_wear.dart --release
```

## Testing on Multiple Devices

### List All Devices
```bash
flutter devices
```

### Target Specific Device
```bash
# By device ID
flutter run -t lib/main_mobile.dart -d <device_id>

# Run on all connected devices
flutter run -t lib/main_mobile.dart -d all
```

## Troubleshooting

### "No devices found"
```bash
# Check ADB
adb devices

# Restart ADB
adb kill-server
adb start-server

# For WearOS, enable Bluetooth debugging or Wi-Fi debugging
```

### "Build failed" errors
```bash
# Clean build
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Try again
flutter run -t lib/main_mobile.dart
```

### Import errors
```bash
# Make sure you're using the correct entry point:
# Mobile: lib/main_mobile.dart
# Wear: lib/main_wear.dart
# NOT: lib/main.dart (deprecated)
```

### WearOS app not installing
```bash
# Check if watch has enough storage
adb shell df

# Clear app data
adb shell pm clear com.example.hajj_companion

# Reinstall
adb install -r build/app/outputs/apk/release/app-release.apk
```

## Performance Optimization

### Reduce APK Size
```bash
flutter build apk -t lib/main_mobile.dart --release --split-per-abi
# Generates separate APKs for arm64-v8a, armeabi-v7a, x86_64
```

### Analyze App Size
```bash
flutter build apk -t lib/main_mobile.dart --analyze-size
```

## Deployment Checklist

### Before Release
- [ ] Update version in `pubspec.yaml`
- [ ] Run `flutter analyze` (0 errors)
- [ ] Test on physical devices
- [ ] Test both mobile and wear apps
- [ ] Verify GPS tracking works
- [ ] Verify Firebase sync works
- [ ] Test offline functionality
- [ ] Check battery consumption

### Play Store Upload
- [ ] Build signed AABs
- [ ] Create store listings (mobile + wear)
- [ ] Prepare screenshots (mobile + wear)
- [ ] Write changelog
- [ ] Set up content rating
- [ ] Upload to Play Console

## Environment Variables

Create `.env` file in project root:
```env
GEMINI_API_KEY=your_gemini_api_key_here
```

## Platform-Specific Notes

### Mobile
- Minimum Android SDK: 21 (Android 5.0)
- Target SDK: 34 (Android 14)
- Supports: Android 5.0+

### WearOS
- Minimum Wear SDK: 28 (Wear OS 2.0)
- Target SDK: 34 (Wear OS 4.0)
- Supports: Wear OS 2.0+
- Screen sizes: 320x320 to 454x454

## CI/CD Integration

### GitHub Actions Example
```yaml
name: Build Apps
on: [push, pull_request]

jobs:
  build-mobile:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.1'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk -t lib/main_mobile.dart --release

  build-wear:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.1'
      - run: flutter pub get
      - run: flutter build apk -t lib/main_wear.dart --release
```

---

**For more details, see [WEAROS_SETUP.md](WEAROS_SETUP.md)**
