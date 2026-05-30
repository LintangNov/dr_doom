import 'package:isar_community/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id? id;

  int totalXp;
  int currentLevel;
  int currentStreak;
  int longestStreak;
  DateTime? lastActiveDate;
  List<String> unlockedBadgeIds;
  List<String> highRiskApps;

  // Keamanan & Anti-Cheat Waktu Lokal
  int? lastKnownBootTime;
  int? lastKnownUptime;
  DateTime? lastSystemTime;
  bool isTimeManipulated;

  UserProfile({
    this.id,
    required this.totalXp,
    required this.currentLevel,
    required this.currentStreak,
    required this.longestStreak,
    this.lastActiveDate,
    required this.unlockedBadgeIds,
    required this.highRiskApps,
    this.lastKnownBootTime,
    this.lastKnownUptime,
    this.lastSystemTime,
    this.isTimeManipulated = false,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as int?,
      totalXp: json['totalXp'] as int,
      currentLevel: json['currentLevel'] as int,
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      lastActiveDate: json['lastActiveDate'] != null
          ? DateTime.parse(json['lastActiveDate'] as String)
          : null,
      unlockedBadgeIds: List<String>.from(json['unlockedBadgeIds'] as List),
      highRiskApps: List<String>.from(json['highRiskApps'] as List),
      lastKnownBootTime: json['lastKnownBootTime'] as int?,
      lastKnownUptime: json['lastKnownUptime'] as int?,
      lastSystemTime: json['lastSystemTime'] != null
          ? DateTime.parse(json['lastSystemTime'] as String)
          : null,
      isTimeManipulated: json['isTimeManipulated'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'totalXp': totalXp,
      'currentLevel': currentLevel,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActiveDate': lastActiveDate?.toIso8601String(),
      'unlockedBadgeIds': unlockedBadgeIds,
      'highRiskApps': highRiskApps,
      'lastKnownBootTime': lastKnownBootTime,
      'lastKnownUptime': lastKnownUptime,
      'lastSystemTime': lastSystemTime?.toIso8601String(),
      'isTimeManipulated': isTimeManipulated,
    };
  }
}
