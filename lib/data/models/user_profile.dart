import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:isar/isar.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
@Collection(ignore: {'copyWith'})
class UserProfile with _$UserProfile {
  const factory UserProfile({
    Id? id,
    required int totalXp,
    required int currentLevel,
    required int currentStreak,
    required int longestStreak,
    required DateTime? lastActiveDate,
    required List<String> unlockedBadgeIds,
    required List<String> highRiskApps,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
