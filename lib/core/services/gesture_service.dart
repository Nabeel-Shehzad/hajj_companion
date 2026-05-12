import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';

/// Detects when user raises wrist to display permit (for smartwatch)
/// Also detects shake gestures (for mobile phone demo)
class GestureService {
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  final _gestureController = StreamController<WristGesture>.broadcast();
//Creates a stream controller to send detected gesture events to different parts of the app
  
  Stream<WristGesture> get gestureStream => _gestureController.stream;
//exposes the gesture stream so other files can listen to detected gestures.
  bool _isMonitoring = false;
  DateTime? _lastGestureTime;
//Stores previous accelerometer values to compare them with the new values
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
    //Stores the accelerometer subscription in a variable so it can be stopped later.
    //Starts a stream that continuously receives accelerometer sensor data.
    //Sets the sensor reading speed to a normal interval.
  //begins listening to incoming accelerometer events.
        accelerometerEventStream( samplingPeriod: SensorInterval.normalInterval,
        ).listen (_handleAccelerometerEvent,
        onError: (error)
        //Every new sensor reading is sent to the _handleAccelerometerEvent method to analyze the movement.
         {
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
        return;// Skip processing if we're still within the debounce period
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
enum WristGesture { //enum to represent different wrist gestures that can be detected by the service.
  raised, // Wrist raised to view permit
  lowered, // Wrist lowered
}
