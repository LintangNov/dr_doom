import 'package:isar_community/isar.dart';

part 'scroll_session.g.dart';

@collection
class ScrollSession {
  Id? id;

  DateTime startTime;
  DateTime endTime;
  String appPackageName;
  double peakDrs;
  double avgDrs;
  int swipeCount;
  int tapCount;

  // Keamanan & Evasion Checking
  bool completedCognitiveBump;
  bool isEvaded;

  ScrollSession({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.appPackageName,
    required this.peakDrs,
    required this.avgDrs,
    required this.swipeCount,
    required this.tapCount,
    this.completedCognitiveBump = false,
    this.isEvaded = false,
  });

  factory ScrollSession.fromJson(Map<String, dynamic> json) {
    return ScrollSession(
      id: json['id'] as int?,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      appPackageName: json['appPackageName'] as String,
      peakDrs: (json['peakDrs'] as num).toDouble(),
      avgDrs: (json['avgDrs'] as num).toDouble(),
      swipeCount: json['swipeCount'] as int,
      tapCount: json['tapCount'] as int,
      completedCognitiveBump: json['completedCognitiveBump'] as bool? ?? false,
      isEvaded: json['isEvaded'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'appPackageName': appPackageName,
      'peakDrs': peakDrs,
      'avgDrs': avgDrs,
      'swipeCount': swipeCount,
      'tapCount': tapCount,
      'completedCognitiveBump': completedCognitiveBump,
      'isEvaded': isEvaded,
    };
  }
}
