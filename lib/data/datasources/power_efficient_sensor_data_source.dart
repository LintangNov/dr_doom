import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart' as sensors hide AccelerometerEvent;
import '../../domain/entities/accelerometer_event.dart' as domain;
import '../../domain/entities/device_posture.dart';
import 'sensor_data_source.dart';

class PowerEfficientSensorDataSource implements SensorDataSource {
  DateTime _lastEventTime = DateTime.fromMillisecondsSinceEpoch(0);

  @override
  Stream<domain.AccelerometerEvent> get accelerometerEventStream {
    // Dynamically limit sampling interval using SensorInterval.normalInterval
    // and throttle incoming events to 1.5 seconds intervals to keep CPU wake locks
    // and battery consumption under the 3% per hour threshold.
    return sensors.accelerometerEventStream(samplingPeriod: sensors.SensorInterval.normalInterval)
        .map((event) => domain.AccelerometerEvent(x: event.x, y: event.y, z: event.z))
        .where((event) {
          final now = DateTime.now();
          if (now.difference(_lastEventTime) >= const Duration(milliseconds: 1500)) {
            _lastEventTime = now;
            return true;
          }
          return false;
        });
  }

  @override
  Stream<DevicePosture> get postureStream {
    // Only emit events when device orientation posture physically shifts.
    return accelerometerEventStream
        .map(_evaluatePosture)
        .distinct();
  }

  DevicePosture _evaluatePosture(domain.AccelerometerEvent event) {
    final double y = event.y.abs();
    final double z = event.z.abs();

    if (z > 8.0 && y < 3.0) {
      return DevicePosture.lyingDown;
    } else if (y > 8.0 && z < 3.0) {
      return DevicePosture.standing;
    }
    return DevicePosture.sitting;
  }
}
