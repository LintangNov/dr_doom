// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scroll_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScrollSession {
  Id? get id;
  DateTime get startTime;
  DateTime get endTime;
  String get appPackageName;
  double get peakDrs;
  double get avgDrs;
  int get swipeCount;
  int get tapCount;

  /// Create a copy of ScrollSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScrollSessionCopyWith<ScrollSession> get copyWith =>
      _$ScrollSessionCopyWithImpl<ScrollSession>(
          this as ScrollSession, _$identity);

  /// Serializes this ScrollSession to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScrollSession &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.appPackageName, appPackageName) ||
                other.appPackageName == appPackageName) &&
            (identical(other.peakDrs, peakDrs) || other.peakDrs == peakDrs) &&
            (identical(other.avgDrs, avgDrs) || other.avgDrs == avgDrs) &&
            (identical(other.swipeCount, swipeCount) ||
                other.swipeCount == swipeCount) &&
            (identical(other.tapCount, tapCount) ||
                other.tapCount == tapCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, startTime, endTime,
      appPackageName, peakDrs, avgDrs, swipeCount, tapCount);

  @override
  String toString() {
    return 'ScrollSession(id: $id, startTime: $startTime, endTime: $endTime, appPackageName: $appPackageName, peakDrs: $peakDrs, avgDrs: $avgDrs, swipeCount: $swipeCount, tapCount: $tapCount)';
  }
}

/// @nodoc
abstract mixin class $ScrollSessionCopyWith<$Res> {
  factory $ScrollSessionCopyWith(
          ScrollSession value, $Res Function(ScrollSession) _then) =
      _$ScrollSessionCopyWithImpl;
  @useResult
  $Res call(
      {Id? id,
      DateTime startTime,
      DateTime endTime,
      String appPackageName,
      double peakDrs,
      double avgDrs,
      int swipeCount,
      int tapCount});
}

/// @nodoc
class _$ScrollSessionCopyWithImpl<$Res>
    implements $ScrollSessionCopyWith<$Res> {
  _$ScrollSessionCopyWithImpl(this._self, this._then);

  final ScrollSession _self;
  final $Res Function(ScrollSession) _then;

  /// Create a copy of ScrollSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? appPackageName = null,
    Object? peakDrs = null,
    Object? avgDrs = null,
    Object? swipeCount = null,
    Object? tapCount = null,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as Id?,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      appPackageName: null == appPackageName
          ? _self.appPackageName
          : appPackageName // ignore: cast_nullable_to_non_nullable
              as String,
      peakDrs: null == peakDrs
          ? _self.peakDrs
          : peakDrs // ignore: cast_nullable_to_non_nullable
              as double,
      avgDrs: null == avgDrs
          ? _self.avgDrs
          : avgDrs // ignore: cast_nullable_to_non_nullable
              as double,
      swipeCount: null == swipeCount
          ? _self.swipeCount
          : swipeCount // ignore: cast_nullable_to_non_nullable
              as int,
      tapCount: null == tapCount
          ? _self.tapCount
          : tapCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [ScrollSession].
extension ScrollSessionPatterns on ScrollSession {
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
    TResult Function(_ScrollSession value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScrollSession() when $default != null:
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
    TResult Function(_ScrollSession value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScrollSession():
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
    TResult? Function(_ScrollSession value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScrollSession() when $default != null:
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
            DateTime startTime,
            DateTime endTime,
            String appPackageName,
            double peakDrs,
            double avgDrs,
            int swipeCount,
            int tapCount)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScrollSession() when $default != null:
        return $default(
            _that.id,
            _that.startTime,
            _that.endTime,
            _that.appPackageName,
            _that.peakDrs,
            _that.avgDrs,
            _that.swipeCount,
            _that.tapCount);
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
            DateTime startTime,
            DateTime endTime,
            String appPackageName,
            double peakDrs,
            double avgDrs,
            int swipeCount,
            int tapCount)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScrollSession():
        return $default(
            _that.id,
            _that.startTime,
            _that.endTime,
            _that.appPackageName,
            _that.peakDrs,
            _that.avgDrs,
            _that.swipeCount,
            _that.tapCount);
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
            DateTime startTime,
            DateTime endTime,
            String appPackageName,
            double peakDrs,
            double avgDrs,
            int swipeCount,
            int tapCount)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScrollSession() when $default != null:
        return $default(
            _that.id,
            _that.startTime,
            _that.endTime,
            _that.appPackageName,
            _that.peakDrs,
            _that.avgDrs,
            _that.swipeCount,
            _that.tapCount);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ScrollSession implements ScrollSession {
  const _ScrollSession(
      {this.id,
      required this.startTime,
      required this.endTime,
      required this.appPackageName,
      required this.peakDrs,
      required this.avgDrs,
      required this.swipeCount,
      required this.tapCount});
  factory _ScrollSession.fromJson(Map<String, dynamic> json) =>
      _$ScrollSessionFromJson(json);

  @override
  final Id? id;
  @override
  final DateTime startTime;
  @override
  final DateTime endTime;
  @override
  final String appPackageName;
  @override
  final double peakDrs;
  @override
  final double avgDrs;
  @override
  final int swipeCount;
  @override
  final int tapCount;

  /// Create a copy of ScrollSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScrollSessionCopyWith<_ScrollSession> get copyWith =>
      __$ScrollSessionCopyWithImpl<_ScrollSession>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ScrollSessionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScrollSession &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.appPackageName, appPackageName) ||
                other.appPackageName == appPackageName) &&
            (identical(other.peakDrs, peakDrs) || other.peakDrs == peakDrs) &&
            (identical(other.avgDrs, avgDrs) || other.avgDrs == avgDrs) &&
            (identical(other.swipeCount, swipeCount) ||
                other.swipeCount == swipeCount) &&
            (identical(other.tapCount, tapCount) ||
                other.tapCount == tapCount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, startTime, endTime,
      appPackageName, peakDrs, avgDrs, swipeCount, tapCount);

  @override
  String toString() {
    return 'ScrollSession(id: $id, startTime: $startTime, endTime: $endTime, appPackageName: $appPackageName, peakDrs: $peakDrs, avgDrs: $avgDrs, swipeCount: $swipeCount, tapCount: $tapCount)';
  }
}

/// @nodoc
abstract mixin class _$ScrollSessionCopyWith<$Res>
    implements $ScrollSessionCopyWith<$Res> {
  factory _$ScrollSessionCopyWith(
          _ScrollSession value, $Res Function(_ScrollSession) _then) =
      __$ScrollSessionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {Id? id,
      DateTime startTime,
      DateTime endTime,
      String appPackageName,
      double peakDrs,
      double avgDrs,
      int swipeCount,
      int tapCount});
}

/// @nodoc
class __$ScrollSessionCopyWithImpl<$Res>
    implements _$ScrollSessionCopyWith<$Res> {
  __$ScrollSessionCopyWithImpl(this._self, this._then);

  final _ScrollSession _self;
  final $Res Function(_ScrollSession) _then;

  /// Create a copy of ScrollSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? startTime = null,
    Object? endTime = null,
    Object? appPackageName = null,
    Object? peakDrs = null,
    Object? avgDrs = null,
    Object? swipeCount = null,
    Object? tapCount = null,
  }) {
    return _then(_ScrollSession(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as Id?,
      startTime: null == startTime
          ? _self.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endTime: null == endTime
          ? _self.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      appPackageName: null == appPackageName
          ? _self.appPackageName
          : appPackageName // ignore: cast_nullable_to_non_nullable
              as String,
      peakDrs: null == peakDrs
          ? _self.peakDrs
          : peakDrs // ignore: cast_nullable_to_non_nullable
              as double,
      avgDrs: null == avgDrs
          ? _self.avgDrs
          : avgDrs // ignore: cast_nullable_to_non_nullable
              as double,
      swipeCount: null == swipeCount
          ? _self.swipeCount
          : swipeCount // ignore: cast_nullable_to_non_nullable
              as int,
      tapCount: null == tapCount
          ? _self.tapCount
          : tapCount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
