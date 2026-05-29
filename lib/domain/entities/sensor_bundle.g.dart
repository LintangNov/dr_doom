// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sensor_bundle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SensorBundle _$SensorBundleFromJson(Map<String, dynamic> json) =>
    _SensorBundle(
      swipeToTapRatio: (json['swipeToTapRatio'] as num).toDouble(),
      rhythmicScrollMinutes: (json['rhythmicScrollMinutes'] as num).toDouble(),
      isLyingDown: json['isLyingDown'] as bool,
      isVeryStill: json['isVeryStill'] as bool,
      lux: (json['lux'] as num).toDouble(),
      sessionMinutes: (json['sessionMinutes'] as num).toDouble(),
      isLateNight: json['isLateNight'] as bool,
      isEvening: json['isEvening'] as bool,
      rapidSwitching: json['rapidSwitching'] as bool,
    );

Map<String, dynamic> _$SensorBundleToJson(_SensorBundle instance) =>
    <String, dynamic>{
      'swipeToTapRatio': instance.swipeToTapRatio,
      'rhythmicScrollMinutes': instance.rhythmicScrollMinutes,
      'isLyingDown': instance.isLyingDown,
      'isVeryStill': instance.isVeryStill,
      'lux': instance.lux,
      'sessionMinutes': instance.sessionMinutes,
      'isLateNight': instance.isLateNight,
      'isEvening': instance.isEvening,
      'rapidSwitching': instance.rapidSwitching,
    };
