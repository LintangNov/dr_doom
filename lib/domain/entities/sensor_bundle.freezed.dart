// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sensor_bundle.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SensorBundle {
  double get swipeToTapRatio;
  double get rhythmicScrollMinutes;
  bool get isLyingDown;
  bool get isVeryStill;
  double get lux;
  double get sessionMinutes;
  bool get isLateNight;
  bool get isEvening;
  bool get rapidSwitching;

  /// Create a copy of SensorBundle
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SensorBundleCopyWith<SensorBundle> get copyWith =>
      _$SensorBundleCopyWithImpl<SensorBundle>(
          this as SensorBundle, _$identity);

  /// Serializes this SensorBundle to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SensorBundle &&
            (identical(other.swipeToTapRatio, swipeToTapRatio) ||
                other.swipeToTapRatio == swipeToTapRatio) &&
            (identical(other.rhythmicScrollMinutes, rhythmicScrollMinutes) ||
                other.rhythmicScrollMinutes == rhythmicScrollMinutes) &&
            (identical(other.isLyingDown, isLyingDown) ||
                other.isLyingDown == isLyingDown) &&
            (identical(other.isVeryStill, isVeryStill) ||
                other.isVeryStill == isVeryStill) &&
            (identical(other.lux, lux) || other.lux == lux) &&
            (identical(other.sessionMinutes, sessionMinutes) ||
                other.sessionMinutes == sessionMinutes) &&
            (identical(other.isLateNight, isLateNight) ||
                other.isLateNight == isLateNight) &&
            (identical(other.isEvening, isEvening) ||
                other.isEvening == isEvening) &&
            (identical(other.rapidSwitching, rapidSwitching) ||
                other.rapidSwitching == rapidSwitching));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      swipeToTapRatio,
      rhythmicScrollMinutes,
      isLyingDown,
      isVeryStill,
      lux,
      sessionMinutes,
      isLateNight,
      isEvening,
      rapidSwitching);

  @override
  String toString() {
    return 'SensorBundle(swipeToTapRatio: $swipeToTapRatio, rhythmicScrollMinutes: $rhythmicScrollMinutes, isLyingDown: $isLyingDown, isVeryStill: $isVeryStill, lux: $lux, sessionMinutes: $sessionMinutes, isLateNight: $isLateNight, isEvening: $isEvening, rapidSwitching: $rapidSwitching)';
  }
}

/// @nodoc
abstract mixin class $SensorBundleCopyWith<$Res> {
  factory $SensorBundleCopyWith(
          SensorBundle value, $Res Function(SensorBundle) _then) =
      _$SensorBundleCopyWithImpl;
  @useResult
  $Res call(
      {double swipeToTapRatio,
      double rhythmicScrollMinutes,
      bool isLyingDown,
      bool isVeryStill,
      double lux,
      double sessionMinutes,
      bool isLateNight,
      bool isEvening,
      bool rapidSwitching});
}

/// @nodoc
class _$SensorBundleCopyWithImpl<$Res> implements $SensorBundleCopyWith<$Res> {
  _$SensorBundleCopyWithImpl(this._self, this._then);

  final SensorBundle _self;
  final $Res Function(SensorBundle) _then;

  /// Create a copy of SensorBundle
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? swipeToTapRatio = null,
    Object? rhythmicScrollMinutes = null,
    Object? isLyingDown = null,
    Object? isVeryStill = null,
    Object? lux = null,
    Object? sessionMinutes = null,
    Object? isLateNight = null,
    Object? isEvening = null,
    Object? rapidSwitching = null,
  }) {
    return _then(_self.copyWith(
      swipeToTapRatio: null == swipeToTapRatio
          ? _self.swipeToTapRatio
          : swipeToTapRatio // ignore: cast_nullable_to_non_nullable
              as double,
      rhythmicScrollMinutes: null == rhythmicScrollMinutes
          ? _self.rhythmicScrollMinutes
          : rhythmicScrollMinutes // ignore: cast_nullable_to_non_nullable
              as double,
      isLyingDown: null == isLyingDown
          ? _self.isLyingDown
          : isLyingDown // ignore: cast_nullable_to_non_nullable
              as bool,
      isVeryStill: null == isVeryStill
          ? _self.isVeryStill
          : isVeryStill // ignore: cast_nullable_to_non_nullable
              as bool,
      lux: null == lux
          ? _self.lux
          : lux // ignore: cast_nullable_to_non_nullable
              as double,
      sessionMinutes: null == sessionMinutes
          ? _self.sessionMinutes
          : sessionMinutes // ignore: cast_nullable_to_non_nullable
              as double,
      isLateNight: null == isLateNight
          ? _self.isLateNight
          : isLateNight // ignore: cast_nullable_to_non_nullable
              as bool,
      isEvening: null == isEvening
          ? _self.isEvening
          : isEvening // ignore: cast_nullable_to_non_nullable
              as bool,
      rapidSwitching: null == rapidSwitching
          ? _self.rapidSwitching
          : rapidSwitching // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [SensorBundle].
extension SensorBundlePatterns on SensorBundle {
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
    TResult Function(_SensorBundle value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorBundle() when $default != null:
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
    TResult Function(_SensorBundle value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorBundle():
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
    TResult? Function(_SensorBundle value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorBundle() when $default != null:
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
            double swipeToTapRatio,
            double rhythmicScrollMinutes,
            bool isLyingDown,
            bool isVeryStill,
            double lux,
            double sessionMinutes,
            bool isLateNight,
            bool isEvening,
            bool rapidSwitching)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SensorBundle() when $default != null:
        return $default(
            _that.swipeToTapRatio,
            _that.rhythmicScrollMinutes,
            _that.isLyingDown,
            _that.isVeryStill,
            _that.lux,
            _that.sessionMinutes,
            _that.isLateNight,
            _that.isEvening,
            _that.rapidSwitching);
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
            double swipeToTapRatio,
            double rhythmicScrollMinutes,
            bool isLyingDown,
            bool isVeryStill,
            double lux,
            double sessionMinutes,
            bool isLateNight,
            bool isEvening,
            bool rapidSwitching)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorBundle():
        return $default(
            _that.swipeToTapRatio,
            _that.rhythmicScrollMinutes,
            _that.isLyingDown,
            _that.isVeryStill,
            _that.lux,
            _that.sessionMinutes,
            _that.isLateNight,
            _that.isEvening,
            _that.rapidSwitching);
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
            double swipeToTapRatio,
            double rhythmicScrollMinutes,
            bool isLyingDown,
            bool isVeryStill,
            double lux,
            double sessionMinutes,
            bool isLateNight,
            bool isEvening,
            bool rapidSwitching)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SensorBundle() when $default != null:
        return $default(
            _that.swipeToTapRatio,
            _that.rhythmicScrollMinutes,
            _that.isLyingDown,
            _that.isVeryStill,
            _that.lux,
            _that.sessionMinutes,
            _that.isLateNight,
            _that.isEvening,
            _that.rapidSwitching);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SensorBundle implements SensorBundle {
  const _SensorBundle(
      {required this.swipeToTapRatio,
      required this.rhythmicScrollMinutes,
      required this.isLyingDown,
      required this.isVeryStill,
      required this.lux,
      required this.sessionMinutes,
      required this.isLateNight,
      required this.isEvening,
      required this.rapidSwitching});
  factory _SensorBundle.fromJson(Map<String, dynamic> json) =>
      _$SensorBundleFromJson(json);

  @override
  final double swipeToTapRatio;
  @override
  final double rhythmicScrollMinutes;
  @override
  final bool isLyingDown;
  @override
  final bool isVeryStill;
  @override
  final double lux;
  @override
  final double sessionMinutes;
  @override
  final bool isLateNight;
  @override
  final bool isEvening;
  @override
  final bool rapidSwitching;

  /// Create a copy of SensorBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SensorBundleCopyWith<_SensorBundle> get copyWith =>
      __$SensorBundleCopyWithImpl<_SensorBundle>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SensorBundleToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SensorBundle &&
            (identical(other.swipeToTapRatio, swipeToTapRatio) ||
                other.swipeToTapRatio == swipeToTapRatio) &&
            (identical(other.rhythmicScrollMinutes, rhythmicScrollMinutes) ||
                other.rhythmicScrollMinutes == rhythmicScrollMinutes) &&
            (identical(other.isLyingDown, isLyingDown) ||
                other.isLyingDown == isLyingDown) &&
            (identical(other.isVeryStill, isVeryStill) ||
                other.isVeryStill == isVeryStill) &&
            (identical(other.lux, lux) || other.lux == lux) &&
            (identical(other.sessionMinutes, sessionMinutes) ||
                other.sessionMinutes == sessionMinutes) &&
            (identical(other.isLateNight, isLateNight) ||
                other.isLateNight == isLateNight) &&
            (identical(other.isEvening, isEvening) ||
                other.isEvening == isEvening) &&
            (identical(other.rapidSwitching, rapidSwitching) ||
                other.rapidSwitching == rapidSwitching));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      swipeToTapRatio,
      rhythmicScrollMinutes,
      isLyingDown,
      isVeryStill,
      lux,
      sessionMinutes,
      isLateNight,
      isEvening,
      rapidSwitching);

  @override
  String toString() {
    return 'SensorBundle(swipeToTapRatio: $swipeToTapRatio, rhythmicScrollMinutes: $rhythmicScrollMinutes, isLyingDown: $isLyingDown, isVeryStill: $isVeryStill, lux: $lux, sessionMinutes: $sessionMinutes, isLateNight: $isLateNight, isEvening: $isEvening, rapidSwitching: $rapidSwitching)';
  }
}

/// @nodoc
abstract mixin class _$SensorBundleCopyWith<$Res>
    implements $SensorBundleCopyWith<$Res> {
  factory _$SensorBundleCopyWith(
          _SensorBundle value, $Res Function(_SensorBundle) _then) =
      __$SensorBundleCopyWithImpl;
  @override
  @useResult
  $Res call(
      {double swipeToTapRatio,
      double rhythmicScrollMinutes,
      bool isLyingDown,
      bool isVeryStill,
      double lux,
      double sessionMinutes,
      bool isLateNight,
      bool isEvening,
      bool rapidSwitching});
}

/// @nodoc
class __$SensorBundleCopyWithImpl<$Res>
    implements _$SensorBundleCopyWith<$Res> {
  __$SensorBundleCopyWithImpl(this._self, this._then);

  final _SensorBundle _self;
  final $Res Function(_SensorBundle) _then;

  /// Create a copy of SensorBundle
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? swipeToTapRatio = null,
    Object? rhythmicScrollMinutes = null,
    Object? isLyingDown = null,
    Object? isVeryStill = null,
    Object? lux = null,
    Object? sessionMinutes = null,
    Object? isLateNight = null,
    Object? isEvening = null,
    Object? rapidSwitching = null,
  }) {
    return _then(_SensorBundle(
      swipeToTapRatio: null == swipeToTapRatio
          ? _self.swipeToTapRatio
          : swipeToTapRatio // ignore: cast_nullable_to_non_nullable
              as double,
      rhythmicScrollMinutes: null == rhythmicScrollMinutes
          ? _self.rhythmicScrollMinutes
          : rhythmicScrollMinutes // ignore: cast_nullable_to_non_nullable
              as double,
      isLyingDown: null == isLyingDown
          ? _self.isLyingDown
          : isLyingDown // ignore: cast_nullable_to_non_nullable
              as bool,
      isVeryStill: null == isVeryStill
          ? _self.isVeryStill
          : isVeryStill // ignore: cast_nullable_to_non_nullable
              as bool,
      lux: null == lux
          ? _self.lux
          : lux // ignore: cast_nullable_to_non_nullable
              as double,
      sessionMinutes: null == sessionMinutes
          ? _self.sessionMinutes
          : sessionMinutes // ignore: cast_nullable_to_non_nullable
              as double,
      isLateNight: null == isLateNight
          ? _self.isLateNight
          : isLateNight // ignore: cast_nullable_to_non_nullable
              as bool,
      isEvening: null == isEvening
          ? _self.isEvening
          : isEvening // ignore: cast_nullable_to_non_nullable
              as bool,
      rapidSwitching: null == rapidSwitching
          ? _self.rapidSwitching
          : rapidSwitching // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
