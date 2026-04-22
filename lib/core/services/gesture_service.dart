import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

/// FR-03: Wrist-Raise and Shake Gesture Detection Service
/// Detects when user raises wrist to display permit (for smartwatch)
/// Also detects shake gestures (for mobile phone demo)
class GestureService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final _gestureController = StreamController<WristGesture>.broadcast();

  Stream<WristGesture> get gestureStream => _gestureController.stream;

  bool _isMonitoring = false;
  DateTime? _lastGestureTime;

  // For shake detection
  double _lastX = 0, _lastY = 0, _lastZ = 0;

  // Threshold values for wrist-raise detection (smartwatch)
  static const double _wristRaiseThreshold = 8.0; // m/s upward acceleration
  static const double _horizontalThreshold = 4.0; // m/s limit for horizontal

  // Threshold values for shake detection (mobile phone)
  static const double _shakeThreshold = 15.0; // m/s acceleration difference
  static const int _debounceMilliseconds =
      1500; // 1.5 seconds between detections

  /// Start monitoring accelerometer for wrist-raise gesture
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _accelerometerSubscription =
        accelerometerEventStream(
          samplingPeriod: SensorInterval.normalInterval,
        ).listen(
          _handleAccelerometerEvent,
          onError: (error) {
            print('Accelerometer error: $error');
          },
        );
  }

  /// Stop monitoring accelerometer
  void stopMonitoring() {
    _isMonitoring = false;
    _accelerometerSubscription?.cancel();
    _accelerometerSubscription = null;
  }

  /// Handle accelerometer events and detect gestures
  void _handleAccelerometerEvent(AccelerometerEvent event) {
    // Check if enough time has passed since last gesture (debounce)
    if (_lastGestureTime != null) {
      final timeSinceLastGesture = DateTime.now()
          .difference(_lastGestureTime!)
          .inMilliseconds;
      if (timeSinceLastGesture < _debounceMilliseconds) {
        return;
      }
    }

    // Method 1: Shake Detection (for mobile phones)
    // Detects sudden acceleration changes in any direction
    final deltaX = (event.x - _lastX).abs();
    final deltaY = (event.y - _lastY).abs();
    final deltaZ = (event.z - _lastZ).abs();

    final totalDelta = deltaX + deltaY + deltaZ;

    if (totalDelta > _shakeThreshold) {
      _lastGestureTime = DateTime.now();
      _gestureController.add(WristGesture.raised);
      print(
        '📱 Shake gesture detected! Delta: ${totalDelta.toStringAsFixed(2)} m/s² (X: $deltaX, Y: $deltaY, Z: $deltaZ)',
      );
    }

    // Method 2: Wrist-Raise Detection (for smartwatches)
    // - Z-axis (vertical) should show strong upward movement
    // - X and Y axes (horizontal) should be relatively stable
    final verticalAcceleration = event.z.abs();
    final horizontalAcceleration = (event.x.abs() + event.y.abs()) / 2;

    if (verticalAcceleration > _wristRaiseThreshold &&
        horizontalAcceleration < _horizontalThreshold) {
      _lastGestureTime = DateTime.now();
      _gestureController.add(WristGesture.raised);
      print(
        '⌚ Wrist-raise gesture detected! Z: ${event.z.toStringAsFixed(2)}, X: ${event.x.toStringAsFixed(2)}, Y: ${event.y.toStringAsFixed(2)}',
      );
    }

    // Update last values for next shake detection
    _lastX = event.x;
    _lastY = event.y;
    _lastZ = event.z;
  }

  /// Dispose resources
  void dispose() {
    stopMonitoring();
    _gestureController.close();
  }
}

/// Wrist gesture types
enum WristGesture {
  raised, // Wrist raised to view permit
  lowered, // Wrist lowered
}
