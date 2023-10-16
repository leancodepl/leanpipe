// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'register_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RegisterState {
  AuthFlowInfo? get flowInfo => throw _privateConstructorUsedError;
  Map<String, KratosError> get fieldErrors =>
      throw _privateConstructorUsedError;
  RegisterGeneralError? get generalError => throw _privateConstructorUsedError;
  bool get inProgress => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RegisterStateCopyWith<RegisterState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RegisterStateCopyWith<$Res> {
  factory $RegisterStateCopyWith(
          RegisterState value, $Res Function(RegisterState) then) =
      _$RegisterStateCopyWithImpl<$Res, RegisterState>;
  @useResult
  $Res call(
      {AuthFlowInfo? flowInfo,
      Map<String, KratosError> fieldErrors,
      RegisterGeneralError? generalError,
      bool inProgress});
}

/// @nodoc
class _$RegisterStateCopyWithImpl<$Res, $Val extends RegisterState>
    implements $RegisterStateCopyWith<$Res> {
  _$RegisterStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowInfo = freezed,
    Object? fieldErrors = null,
    Object? generalError = freezed,
    Object? inProgress = null,
  }) {
    return _then(_value.copyWith(
      flowInfo: freezed == flowInfo
          ? _value.flowInfo
          : flowInfo // ignore: cast_nullable_to_non_nullable
              as AuthFlowInfo?,
      fieldErrors: null == fieldErrors
          ? _value.fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, KratosError>,
      generalError: freezed == generalError
          ? _value.generalError
          : generalError // ignore: cast_nullable_to_non_nullable
              as RegisterGeneralError?,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RegisterStateImplCopyWith<$Res>
    implements $RegisterStateCopyWith<$Res> {
  factory _$$RegisterStateImplCopyWith(
          _$RegisterStateImpl value, $Res Function(_$RegisterStateImpl) then) =
      __$$RegisterStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthFlowInfo? flowInfo,
      Map<String, KratosError> fieldErrors,
      RegisterGeneralError? generalError,
      bool inProgress});
}

/// @nodoc
class __$$RegisterStateImplCopyWithImpl<$Res>
    extends _$RegisterStateCopyWithImpl<$Res, _$RegisterStateImpl>
    implements _$$RegisterStateImplCopyWith<$Res> {
  __$$RegisterStateImplCopyWithImpl(
      _$RegisterStateImpl _value, $Res Function(_$RegisterStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowInfo = freezed,
    Object? fieldErrors = null,
    Object? generalError = freezed,
    Object? inProgress = null,
  }) {
    return _then(_$RegisterStateImpl(
      flowInfo: freezed == flowInfo
          ? _value.flowInfo
          : flowInfo // ignore: cast_nullable_to_non_nullable
              as AuthFlowInfo?,
      fieldErrors: null == fieldErrors
          ? _value._fieldErrors
          : fieldErrors // ignore: cast_nullable_to_non_nullable
              as Map<String, KratosError>,
      generalError: freezed == generalError
          ? _value.generalError
          : generalError // ignore: cast_nullable_to_non_nullable
              as RegisterGeneralError?,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RegisterStateImpl implements _RegisterState {
  const _$RegisterStateImpl(
      {this.flowInfo,
      final Map<String, KratosError> fieldErrors = const {},
      this.generalError,
      this.inProgress = false})
      : _fieldErrors = fieldErrors;

  @override
  final AuthFlowInfo? flowInfo;
  final Map<String, KratosError> _fieldErrors;
  @override
  @JsonKey()
  Map<String, KratosError> get fieldErrors {
    if (_fieldErrors is EqualUnmodifiableMapView) return _fieldErrors;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_fieldErrors);
  }

  @override
  final RegisterGeneralError? generalError;
  @override
  @JsonKey()
  final bool inProgress;

  @override
  String toString() {
    return 'RegisterState(flowInfo: $flowInfo, fieldErrors: $fieldErrors, generalError: $generalError, inProgress: $inProgress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RegisterStateImpl &&
            (identical(other.flowInfo, flowInfo) ||
                other.flowInfo == flowInfo) &&
            const DeepCollectionEquality()
                .equals(other._fieldErrors, _fieldErrors) &&
            (identical(other.generalError, generalError) ||
                other.generalError == generalError) &&
            (identical(other.inProgress, inProgress) ||
                other.inProgress == inProgress));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      flowInfo,
      const DeepCollectionEquality().hash(_fieldErrors),
      generalError,
      inProgress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RegisterStateImplCopyWith<_$RegisterStateImpl> get copyWith =>
      __$$RegisterStateImplCopyWithImpl<_$RegisterStateImpl>(this, _$identity);
}

abstract class _RegisterState implements RegisterState {
  const factory _RegisterState(
      {final AuthFlowInfo? flowInfo,
      final Map<String, KratosError> fieldErrors,
      final RegisterGeneralError? generalError,
      final bool inProgress}) = _$RegisterStateImpl;

  @override
  AuthFlowInfo? get flowInfo;
  @override
  Map<String, KratosError> get fieldErrors;
  @override
  RegisterGeneralError? get generalError;
  @override
  bool get inProgress;
  @override
  @JsonKey(ignore: true)
  _$$RegisterStateImplCopyWith<_$RegisterStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
