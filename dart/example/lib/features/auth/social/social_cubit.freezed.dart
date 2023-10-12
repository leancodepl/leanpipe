// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$SocialState {
  AuthFlowInfo? get flowInfo => throw _privateConstructorUsedError;
  Map<String, KratosError> get fieldErrors =>
      throw _privateConstructorUsedError;
  SocialGeneralError? get generalError => throw _privateConstructorUsedError;
  bool get inProgress => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)
        idle,
    required TResult Function(
            OidcProvider provider,
            String? email,
            String? givenName,
            String? familyName,
            bool? regulationsAccepted,
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)
        traitsStep,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        idle,
    TResult? Function(
            OidcProvider provider,
            String? email,
            String? givenName,
            String? familyName,
            bool? regulationsAccepted,
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        traitsStep,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        idle,
    TResult Function(
            OidcProvider provider,
            String? email,
            String? givenName,
            String? familyName,
            bool? regulationsAccepted,
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        traitsStep,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SocialIdleState value) idle,
    required TResult Function(SocialTraitsState value) traitsStep,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SocialIdleState value)? idle,
    TResult? Function(SocialTraitsState value)? traitsStep,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SocialIdleState value)? idle,
    TResult Function(SocialTraitsState value)? traitsStep,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SocialStateCopyWith<SocialState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialStateCopyWith<$Res> {
  factory $SocialStateCopyWith(
          SocialState value, $Res Function(SocialState) then) =
      _$SocialStateCopyWithImpl<$Res, SocialState>;
  @useResult
  $Res call(
      {AuthFlowInfo? flowInfo,
      Map<String, KratosError> fieldErrors,
      SocialGeneralError? generalError,
      bool inProgress});
}

/// @nodoc
class _$SocialStateCopyWithImpl<$Res, $Val extends SocialState>
    implements $SocialStateCopyWith<$Res> {
  _$SocialStateCopyWithImpl(this._value, this._then);

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
              as SocialGeneralError?,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialIdleStateCopyWith<$Res>
    implements $SocialStateCopyWith<$Res> {
  factory _$$SocialIdleStateCopyWith(
          _$SocialIdleState value, $Res Function(_$SocialIdleState) then) =
      __$$SocialIdleStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {AuthFlowInfo? flowInfo,
      Map<String, KratosError> fieldErrors,
      SocialGeneralError? generalError,
      bool inProgress});
}

/// @nodoc
class __$$SocialIdleStateCopyWithImpl<$Res>
    extends _$SocialStateCopyWithImpl<$Res, _$SocialIdleState>
    implements _$$SocialIdleStateCopyWith<$Res> {
  __$$SocialIdleStateCopyWithImpl(
      _$SocialIdleState _value, $Res Function(_$SocialIdleState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? flowInfo = freezed,
    Object? fieldErrors = null,
    Object? generalError = freezed,
    Object? inProgress = null,
  }) {
    return _then(_$SocialIdleState(
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
              as SocialGeneralError?,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SocialIdleState implements SocialIdleState {
  const _$SocialIdleState(
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
  final SocialGeneralError? generalError;
  @override
  @JsonKey()
  final bool inProgress;

  @override
  String toString() {
    return 'SocialState.idle(flowInfo: $flowInfo, fieldErrors: $fieldErrors, generalError: $generalError, inProgress: $inProgress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialIdleState &&
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
  _$$SocialIdleStateCopyWith<_$SocialIdleState> get copyWith =>
      __$$SocialIdleStateCopyWithImpl<_$SocialIdleState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)
        idle,
    required TResult Function(
            OidcProvider provider,
            String? email,
            String? givenName,
            String? familyName,
            bool? regulationsAccepted,
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)
        traitsStep,
  }) {
    return idle(flowInfo, fieldErrors, generalError, inProgress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        idle,
    TResult? Function(
            OidcProvider provider,
            String? email,
            String? givenName,
            String? familyName,
            bool? regulationsAccepted,
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        traitsStep,
  }) {
    return idle?.call(flowInfo, fieldErrors, generalError, inProgress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        idle,
    TResult Function(
            OidcProvider provider,
            String? email,
            String? givenName,
            String? familyName,
            bool? regulationsAccepted,
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        traitsStep,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(flowInfo, fieldErrors, generalError, inProgress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SocialIdleState value) idle,
    required TResult Function(SocialTraitsState value) traitsStep,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SocialIdleState value)? idle,
    TResult? Function(SocialTraitsState value)? traitsStep,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SocialIdleState value)? idle,
    TResult Function(SocialTraitsState value)? traitsStep,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class SocialIdleState implements SocialState {
  const factory SocialIdleState(
      {final AuthFlowInfo? flowInfo,
      final Map<String, KratosError> fieldErrors,
      final SocialGeneralError? generalError,
      final bool inProgress}) = _$SocialIdleState;

  @override
  AuthFlowInfo? get flowInfo;
  @override
  Map<String, KratosError> get fieldErrors;
  @override
  SocialGeneralError? get generalError;
  @override
  bool get inProgress;
  @override
  @JsonKey(ignore: true)
  _$$SocialIdleStateCopyWith<_$SocialIdleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SocialTraitsStateCopyWith<$Res>
    implements $SocialStateCopyWith<$Res> {
  factory _$$SocialTraitsStateCopyWith(
          _$SocialTraitsState value, $Res Function(_$SocialTraitsState) then) =
      __$$SocialTraitsStateCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {OidcProvider provider,
      String? email,
      String? givenName,
      String? familyName,
      bool? regulationsAccepted,
      AuthFlowInfo? flowInfo,
      Map<String, KratosError> fieldErrors,
      SocialGeneralError? generalError,
      bool inProgress});
}

/// @nodoc
class __$$SocialTraitsStateCopyWithImpl<$Res>
    extends _$SocialStateCopyWithImpl<$Res, _$SocialTraitsState>
    implements _$$SocialTraitsStateCopyWith<$Res> {
  __$$SocialTraitsStateCopyWithImpl(
      _$SocialTraitsState _value, $Res Function(_$SocialTraitsState) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? provider = null,
    Object? email = freezed,
    Object? givenName = freezed,
    Object? familyName = freezed,
    Object? regulationsAccepted = freezed,
    Object? flowInfo = freezed,
    Object? fieldErrors = null,
    Object? generalError = freezed,
    Object? inProgress = null,
  }) {
    return _then(_$SocialTraitsState(
      provider: null == provider
          ? _value.provider
          : provider // ignore: cast_nullable_to_non_nullable
              as OidcProvider,
      email: freezed == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String?,
      givenName: freezed == givenName
          ? _value.givenName
          : givenName // ignore: cast_nullable_to_non_nullable
              as String?,
      familyName: freezed == familyName
          ? _value.familyName
          : familyName // ignore: cast_nullable_to_non_nullable
              as String?,
      regulationsAccepted: freezed == regulationsAccepted
          ? _value.regulationsAccepted
          : regulationsAccepted // ignore: cast_nullable_to_non_nullable
              as bool?,
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
              as SocialGeneralError?,
      inProgress: null == inProgress
          ? _value.inProgress
          : inProgress // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SocialTraitsState implements SocialTraitsState {
  const _$SocialTraitsState(
      {required this.provider,
      required this.email,
      required this.givenName,
      required this.familyName,
      required this.regulationsAccepted,
      this.flowInfo,
      final Map<String, KratosError> fieldErrors = const {},
      this.generalError,
      this.inProgress = false})
      : _fieldErrors = fieldErrors;

  @override
  final OidcProvider provider;
  @override
  final String? email;
  @override
  final String? givenName;
  @override
  final String? familyName;
  @override
  final bool? regulationsAccepted;
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
  final SocialGeneralError? generalError;
  @override
  @JsonKey()
  final bool inProgress;

  @override
  String toString() {
    return 'SocialState.traitsStep(provider: $provider, email: $email, givenName: $givenName, familyName: $familyName, regulationsAccepted: $regulationsAccepted, flowInfo: $flowInfo, fieldErrors: $fieldErrors, generalError: $generalError, inProgress: $inProgress)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialTraitsState &&
            (identical(other.provider, provider) ||
                other.provider == provider) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.givenName, givenName) ||
                other.givenName == givenName) &&
            (identical(other.familyName, familyName) ||
                other.familyName == familyName) &&
            (identical(other.regulationsAccepted, regulationsAccepted) ||
                other.regulationsAccepted == regulationsAccepted) &&
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
      provider,
      email,
      givenName,
      familyName,
      regulationsAccepted,
      flowInfo,
      const DeepCollectionEquality().hash(_fieldErrors),
      generalError,
      inProgress);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialTraitsStateCopyWith<_$SocialTraitsState> get copyWith =>
      __$$SocialTraitsStateCopyWithImpl<_$SocialTraitsState>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)
        idle,
    required TResult Function(
            OidcProvider provider,
            String? email,
            String? givenName,
            String? familyName,
            bool? regulationsAccepted,
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)
        traitsStep,
  }) {
    return traitsStep(provider, email, givenName, familyName,
        regulationsAccepted, flowInfo, fieldErrors, generalError, inProgress);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        idle,
    TResult? Function(
            OidcProvider provider,
            String? email,
            String? givenName,
            String? familyName,
            bool? regulationsAccepted,
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        traitsStep,
  }) {
    return traitsStep?.call(provider, email, givenName, familyName,
        regulationsAccepted, flowInfo, fieldErrors, generalError, inProgress);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        idle,
    TResult Function(
            OidcProvider provider,
            String? email,
            String? givenName,
            String? familyName,
            bool? regulationsAccepted,
            AuthFlowInfo? flowInfo,
            Map<String, KratosError> fieldErrors,
            SocialGeneralError? generalError,
            bool inProgress)?
        traitsStep,
    required TResult orElse(),
  }) {
    if (traitsStep != null) {
      return traitsStep(provider, email, givenName, familyName,
          regulationsAccepted, flowInfo, fieldErrors, generalError, inProgress);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(SocialIdleState value) idle,
    required TResult Function(SocialTraitsState value) traitsStep,
  }) {
    return traitsStep(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(SocialIdleState value)? idle,
    TResult? Function(SocialTraitsState value)? traitsStep,
  }) {
    return traitsStep?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(SocialIdleState value)? idle,
    TResult Function(SocialTraitsState value)? traitsStep,
    required TResult orElse(),
  }) {
    if (traitsStep != null) {
      return traitsStep(this);
    }
    return orElse();
  }
}

abstract class SocialTraitsState implements SocialState {
  const factory SocialTraitsState(
      {required final OidcProvider provider,
      required final String? email,
      required final String? givenName,
      required final String? familyName,
      required final bool? regulationsAccepted,
      final AuthFlowInfo? flowInfo,
      final Map<String, KratosError> fieldErrors,
      final SocialGeneralError? generalError,
      final bool inProgress}) = _$SocialTraitsState;

  OidcProvider get provider;
  String? get email;
  String? get givenName;
  String? get familyName;
  bool? get regulationsAccepted;
  @override
  AuthFlowInfo? get flowInfo;
  @override
  Map<String, KratosError> get fieldErrors;
  @override
  SocialGeneralError? get generalError;
  @override
  bool get inProgress;
  @override
  @JsonKey(ignore: true)
  _$$SocialTraitsStateCopyWith<_$SocialTraitsState> get copyWith =>
      throw _privateConstructorUsedError;
}
