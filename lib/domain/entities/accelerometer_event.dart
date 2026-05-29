class AccelerometerEvent {
  final double x;
  final double y;
  final double z;

  const AccelerometerEvent({
    required this.x,
    required this.y,
    required this.z,
  });

  @override
  String toString() => 'AccelerometerEvent(x: $x, y: $y, z: $z)';
}
