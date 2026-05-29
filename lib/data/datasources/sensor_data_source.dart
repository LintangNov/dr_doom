import '../../domain/entities/accelerometer_event.dart';
import '../../domain/entities/device_posture.dart';

abstract class SensorDataSource {
  /// Stream of accelerometer raw readings (X, Y, Z coordinates).
  Stream<AccelerometerEvent> get accelerometerEventStream;

  /// Stream of evaluated postures of the device.
  Stream<DevicePosture> get postureStream;
}
