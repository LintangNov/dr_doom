// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfile {
  Id? get id;
  int get totalXp;
  int get currentLevel;
  int get currentStreak;
  int get longestStreak;
  DateTime? get lastActiveDate;
  List<String> get unlockedBadgeIds;
  List<String> get highRiskApps;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserProfileCopyWith<UserProfile> get copyWith =>
      _$UserProfileCopyWithImpl<UserProfile>(this as UserProfile, _$identity);

  /// Serializes this UserProfile to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserProfile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            const DeepCollectionEquality()
                .equals(other.unlockedBadgeIds, unlockedBadgeIds) &&
            const DeepCollectionEquality()
                .equals(other.highRiskApps, highRiskApps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      totalXp,
      currentLevel,
      currentStreak,
      longestStreak,
      lastActiveDate,
      const DeepCollectionEquality().hash(unlockedBadgeIds),
      const DeepCollectionEquality().hash(highRiskApps));

  @override
  String toString() {
    return 'UserProfile(id: $id, totalXp: $totalXp, currentLevel: $currentLevel, currentStreak: $currentStreak, longestStreak: $longestStreak, lastActiveDate: $lastActiveDate, unlockedBadgeIds: $unlockedBadgeIds, highRiskApps: $highRiskApps)';
  }
}

/// @nodoc
abstract mixin class $UserProfileCopyWith<$Res> {
  factory $UserProfileCopyWith(
          UserProfile value, $Res Function(UserProfile) _then) =
      _$UserProfileCopyWithImpl;
  @useResult
  $Res call(
      {Id? id,
      int totalXp,
      int currentLevel,
      int currentStreak,
      int longestStreak,
      DateTime? lastActiveDate,
      List<String> unlockedBadgeIds,
      List<String> highRiskApps});
}

/// @nodoc
class _$UserProfileCopyWithImpl<$Res> implements $UserProfileCopyWith<$Res> {
  _$UserProfileCopyWithImpl(this._self, this._then);

  final UserProfile _self;
  final $Res Function(UserProfile) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? totalXp = null,
    Object? currentLevel = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastActiveDate = freezed,
    Object? unlockedBadgeIds = null,
    Object? highRiskApps = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as Id?,
      totalXp: null == totalXp
          ? _self.totalXp
          : totalXp // ignore: cast_nullable_to_non_nullable
              as int,
      currentLevel: null == currentLevel
          ? _self.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _self.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _self.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastActiveDate: freezed == lastActiveDate
          ? _self.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unlockedBadgeIds: null == unlockedBadgeIds
          ? _self.unlockedBadgeIds
          : unlockedBadgeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      highRiskApps: null == highRiskApps
          ? _self.highRiskApps
          : highRiskApps // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserProfile].
extension UserProfilePatterns on UserProfile {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_UserProfile value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserProfile() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_UserProfile value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfile():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_UserProfile value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfile() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            Id? id,
            int totalXp,
            int currentLevel,
            int currentStreak,
            int longestStreak,
            DateTime? lastActiveDate,
            List<String> unlockedBadgeIds,
            List<String> highRiskApps)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserProfile() when $default != null:
        return $default(
            _that.id,
            _that.totalXp,
            _that.currentLevel,
            _that.currentStreak,
            _that.longestStreak,
            _that.lastActiveDate,
            _that.unlockedBadgeIds,
            _that.highRiskApps);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            Id? id,
            int totalXp,
            int currentLevel,
            int currentStreak,
            int longestStreak,
            DateTime? lastActiveDate,
            List<String> unlockedBadgeIds,
            List<String> highRiskApps)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfile():
        return $default(
            _that.id,
            _that.totalXp,
            _that.currentLevel,
            _that.currentStreak,
            _that.longestStreak,
            _that.lastActiveDate,
            _that.unlockedBadgeIds,
            _that.highRiskApps);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            Id? id,
            int totalXp,
            int currentLevel,
            int currentStreak,
            int longestStreak,
            DateTime? lastActiveDate,
            List<String> unlockedBadgeIds,
            List<String> highRiskApps)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfile() when $default != null:
        return $default(
            _that.id,
            _that.totalXp,
            _that.currentLevel,
            _that.currentStreak,
            _that.longestStreak,
            _that.lastActiveDate,
            _that.unlockedBadgeIds,
            _that.highRiskApps);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserProfile implements UserProfile {
  const _UserProfile(
      {this.id,
      required this.totalXp,
      required this.currentLevel,
      required this.currentStreak,
      required this.longestStreak,
      required this.lastActiveDate,
      required final List<String> unlockedBadgeIds,
      required final List<String> highRiskApps})
      : _unlockedBadgeIds = unlockedBadgeIds,
        _highRiskApps = highRiskApps;
  factory _UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);

  @override
  final Id? id;
  @override
  final int totalXp;
  @override
  final int currentLevel;
  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final DateTime? lastActiveDate;
  final List<String> _unlockedBadgeIds;
  @override
  List<String> get unlockedBadgeIds {
    if (_unlockedBadgeIds is EqualUnmodifiableListView)
      return _unlockedBadgeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_unlockedBadgeIds);
  }

  final List<String> _highRiskApps;
  @override
  List<String> get highRiskApps {
    if (_highRiskApps is EqualUnmodifiableListView) return _highRiskApps;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highRiskApps);
  }

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserProfileCopyWith<_UserProfile> get copyWith =>
      __$UserProfileCopyWithImpl<_UserProfile>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserProfileToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserProfile &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.totalXp, totalXp) || other.totalXp == totalXp) &&
            (identical(other.currentLevel, currentLevel) ||
                other.currentLevel == currentLevel) &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            const DeepCollectionEquality()
                .equals(other._unlockedBadgeIds, _unlockedBadgeIds) &&
            const DeepCollectionEquality()
                .equals(other._highRiskApps, _highRiskApps));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      totalXp,
      currentLevel,
      currentStreak,
      longestStreak,
      lastActiveDate,
      const DeepCollectionEquality().hash(_unlockedBadgeIds),
      const DeepCollectionEquality().hash(_highRiskApps));

  @override
  String toString() {
    return 'UserProfile(id: $id, totalXp: $totalXp, currentLevel: $currentLevel, currentStreak: $currentStreak, longestStreak: $longestStreak, lastActiveDate: $lastActiveDate, unlockedBadgeIds: $unlockedBadgeIds, highRiskApps: $highRiskApps)';
  }
}

/// @nodoc
abstract mixin class _$UserProfileCopyWith<$Res>
    implements $UserProfileCopyWith<$Res> {
  factory _$UserProfileCopyWith(
          _UserProfile value, $Res Function(_UserProfile) _then) =
      __$UserProfileCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Id? id,
      int totalXp,
      int currentLevel,
      int currentStreak,
      int longestStreak,
      DateTime? lastActiveDate,
      List<String> unlockedBadgeIds,
      List<String> highRiskApps});
}

/// @nodoc
class __$UserProfileCopyWithImpl<$Res> implements _$UserProfileCopyWith<$Res> {
  __$UserProfileCopyWithImpl(this._self, this._then);

  final _UserProfile _self;
  final $Res Function(_UserProfile) _then;

  /// Create a copy of UserProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? totalXp = null,
    Object? currentLevel = null,
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? lastActiveDate = freezed,
    Object? unlockedBadgeIds = null,
    Object? highRiskApps = null,
  }) {
    return _then(_UserProfile(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as Id?,
      totalXp: null == totalXp
          ? _self.totalXp
          : totalXp // ignore: cast_nullable_to_non_nullable
              as int,
      currentLevel: null == currentLevel
          ? _self.currentLevel
          : currentLevel // ignore: cast_nullable_to_non_nullable
              as int,
      currentStreak: null == currentStreak
          ? _self.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _self.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      lastActiveDate: freezed == lastActiveDate
          ? _self.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      unlockedBadgeIds: null == unlockedBadgeIds
          ? _self._unlockedBadgeIds
          : unlockedBadgeIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      highRiskApps: null == highRiskApps
          ? _self._highRiskApps
          : highRiskApps // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

// dart format on
