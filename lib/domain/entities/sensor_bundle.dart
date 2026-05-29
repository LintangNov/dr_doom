import 'package:freezed_annotation/freezed_annotation.dart';

part 'sensor_bundle.freezed.dart';
part 'sensor_bundle.g.dart';

@freezed
abstract class SensorBundle with _$SensorBundle {
  const factory SensorBundle({
    required double swipeToTapRatio,
    required double rhythmicScrollMinutes,
    required bool isLyingDown,
    required bool isVeryStill,
    required double lux,
    required double sessionMinutes,
    required bool isLateNight,
    required bool isEvening,
    required bool rapidSwitching,
  }) = _SensorBundle;

  factory SensorBundle.fromJson(Map<String, dynamic> json) =>
      _$SensorBundleFromJson(json);
}
