// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reauthorize_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$ReauthorizeState {
  AuthFlowInfo? get flowInfo => throw _privateConstructorUsedError;
  LoginError? get error => throw _privateConstructorUsedError;
  bool get inProgress => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ReauthorizeStateCopyWith<ReauthorizeState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReauthorizeStateCopyWith<$Res> {
  factory $ReauthorizeStateCopyWith(
          ReauthorizeState value, $Res Function(ReauthorizeState) then) =
      _$ReauthorizeStateCopyWithImpl<$Res, ReauthorizeState>;
  @useResult
  $Res call({AuthFlowInfo? flowInfo, LoginError? error, bool inProgress});
}

/// @nodoc
class _$ReauthorizeStateCopyWithImpl<$Res, $Val extends ReauthorizeState>
    implements $ReauthorizeStateCopyWith<$Res> {
  _$ReauthorizeStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowInfo = freezed,
    Object? error = freezed,
    Object? inProgress = null,
  }) {
    return _then(_value.copyWith(
      flowInfo: freezed == flowInfo
          ? _value.flowInfo
          : flowInfo // ignore: cast_nullable_to_non_nullable
              as AuthFlowInfo?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as LoginError?,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReauthorizeStateImplCopyWith<$Res>
    implements $ReauthorizeStateCopyWith<$Res> {
  factory _$$ReauthorizeStateImplCopyWith(_$ReauthorizeStateImpl value,
          $Res Function(_$ReauthorizeStateImpl) then) =
      __$$ReauthorizeStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AuthFlowInfo? flowInfo, LoginError? error, bool inProgress});
}

/// @nodoc
class __$$ReauthorizeStateImplCopyWithImpl<$Res>
    extends _$ReauthorizeStateCopyWithImpl<$Res, _$ReauthorizeStateImpl>
    implements _$$ReauthorizeStateImplCopyWith<$Res> {
  __$$ReauthorizeStateImplCopyWithImpl(_$ReauthorizeStateImpl _value,
      $Res Function(_$ReauthorizeStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowInfo = freezed,
    Object? error = freezed,
    Object? inProgress = null,
  }) {
    return _then(_$ReauthorizeStateImpl(
      flowInfo: freezed == flowInfo
          ? _value.flowInfo
          : flowInfo // ignore: cast_nullable_to_non_nullable
              as AuthFlowInfo?,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as LoginError?,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$ReauthorizeStateImpl implements _ReauthorizeState {
  const _$ReauthorizeStateImpl(
      {this.flowInfo, this.error, this.inProgress = false});

  @override
  final AuthFlowInfo? flowInfo;
  @override
  final LoginError? error;
  @override
  @JsonKey()
  final bool inProgress;

  @override
  String toString() {
    return 'ReauthorizeState(flowInfo: $flowInfo, error: $error, inProgress: $inProgress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReauthorizeStateImpl &&
            (identical(other.flowInfo, flowInfo) ||
                other.flowInfo == flowInfo) &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.inProgress, inProgress) ||
                other.inProgress == inProgress));
  }

  @override
  int get hashCode => Object.hash(runtimeType, flowInfo, error, inProgress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReauthorizeStateImplCopyWith<_$ReauthorizeStateImpl> get copyWith =>
      __$$ReauthorizeStateImplCopyWithImpl<_$ReauthorizeStateImpl>(
          this, _$identity);
}

abstract class _ReauthorizeState implements ReauthorizeState {
  const factory _ReauthorizeState(
      {final AuthFlowInfo? flowInfo,
      final LoginError? error,
      final bool inProgress}) = _$ReauthorizeStateImpl;

  @override
  AuthFlowInfo? get flowInfo;
  @override
  LoginError? get error;
  @override
  bool get inProgress;
  @override
  @JsonKey(ignore: true)
  _$$ReauthorizeStateImplCopyWith<_$ReauthorizeStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
