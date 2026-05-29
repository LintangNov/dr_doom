import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import '../../domain/entities/accelerometer_event.dart';
import '../../domain/entities/device_posture.dart';
import 'sensor_data_source.dart';

class PowerEfficientSensorDataSource implements SensorDataSource {
  @override
  Stream<AccelerometerEvent> get accelerometerEventStream {
    // Dynamically limit sampling interval using SensorInterval.normal (50Hz / 200ms)
    // to keep CPU wake locks and battery consumption under the 3% per hour threshold.
    return accelerometerEvents(samplingPeriod: SensorInterval.normal)
        .map((event) => AccelerometerEvent(x: event.x, y: event.y, z: event.z));
  }

  @override
  Stream<DevicePosture> get postureStream {
    // Only emit events when device orientation posture physically shifts.
    return accelerometerEventStream
        .map(_evaluatePosture)
        .distinct();
  }

  DevicePosture _evaluatePosture(AccelerometerEvent event) {
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
