import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar_community/isar.dart';

part 'scroll_session.freezed.dart';
part 'scroll_session.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
abstract class ScrollSession with _$ScrollSession {
  const factory ScrollSession({
    Id? id,
    required DateTime startTime,
    required DateTime endTime,
    required String appPackageName,
    required double peakDrs,
    required double avgDrs,
    required int swipeCount,
    required int tapCount,
  }) = _ScrollSession;

  factory ScrollSession.fromJson(Map<String, dynamic> json) =>
      _$ScrollSessionFromJson(json);
}
