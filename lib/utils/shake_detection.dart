// import 'dart:async';
// import 'dart:math';
// import 'package:sensors_plus/sensors_plus.dart';

// class ShakeDetector {
//   final void Function() onShake;
//   final double shakeThresholdGravity;
//   final int shakeIntervalMs;

//   late StreamSubscription<AccelerometerEvent> _subscription;
//   int _lastShakeTimestamp = 0;

//   ShakeDetector({
//     required this.onShake,
//     this.shakeThresholdGravity = 2.0, // Threshold for shake detection
//     this.shakeIntervalMs = 500, // Minimum time interval between shakes
//   }) {
//     _initialize();
//   }

//   void _initialize() {
//     _subscription = accelerometerEvents.listen((event) {
//       final double gX = event.x / 9.8;
//       final double gY = event.y / 9.8;
//       final double gZ = event.z / 9.8;
//       final double gForce = sqrt(gX * gX + gY * gY + gZ * gZ);

//       // Log the accelerometer values for debugging (remove in production)
//       // print("Accelerometer X: $gX, Y: $gY, Z: $gZ, gForce: $gForce");

//       if (gForce > shakeThresholdGravity) {
//         final int now = DateTime.now().millisecondsSinceEpoch;
//         if (_lastShakeTimestamp + shakeIntervalMs < now) {
//           _lastShakeTimestamp = now;
//           onShake(); // Trigger the shake action
//         }
//       }
//     });
//   }

//   void stop() {
//     _subscription.cancel(); // Stop listening to accelerometer events
//   }
// }
