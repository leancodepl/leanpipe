// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'screen_cubit.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DraftScreenState {
  bool get authorized => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String data, bool authorized) connected,
    required TResult Function(
            bool authorized, bool connecting, DraftScreenError? error)
        disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data, bool authorized)? connected,
    TResult? Function(
            bool authorized, bool connecting, DraftScreenError? error)?
        disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data, bool authorized)? connected,
    TResult Function(bool authorized, bool connecting, DraftScreenError? error)?
        disconnected,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DraftScreenConnected value) connected,
    required TResult Function(DraftScreenDisconnected value) disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DraftScreenConnected value)? connected,
    TResult? Function(DraftScreenDisconnected value)? disconnected,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DraftScreenConnected value)? connected,
    TResult Function(DraftScreenDisconnected value)? disconnected,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  /// Create a copy of DraftScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DraftScreenStateCopyWith<DraftScreenState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DraftScreenStateCopyWith<$Res> {
  factory $DraftScreenStateCopyWith(
          DraftScreenState value, $Res Function(DraftScreenState) then) =
      _$DraftScreenStateCopyWithImpl<$Res, DraftScreenState>;
  @useResult
  $Res call({bool authorized});
}

/// @nodoc
class _$DraftScreenStateCopyWithImpl<$Res, $Val extends DraftScreenState>
    implements $DraftScreenStateCopyWith<$Res> {
  _$DraftScreenStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DraftScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorized = null,
  }) {
    return _then(_value.copyWith(
      authorized: null == authorized
          ? _value.authorized
          : authorized // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DraftScreenConnectedImplCopyWith<$Res>
    implements $DraftScreenStateCopyWith<$Res> {
  factory _$$DraftScreenConnectedImplCopyWith(_$DraftScreenConnectedImpl value,
          $Res Function(_$DraftScreenConnectedImpl) then) =
      __$$DraftScreenConnectedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String data, bool authorized});
}

/// @nodoc
class __$$DraftScreenConnectedImplCopyWithImpl<$Res>
    extends _$DraftScreenStateCopyWithImpl<$Res, _$DraftScreenConnectedImpl>
    implements _$$DraftScreenConnectedImplCopyWith<$Res> {
  __$$DraftScreenConnectedImplCopyWithImpl(_$DraftScreenConnectedImpl _value,
      $Res Function(_$DraftScreenConnectedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DraftScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? authorized = null,
  }) {
    return _then(_$DraftScreenConnectedImpl(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as String,
      authorized: null == authorized
          ? _value.authorized
          : authorized // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$DraftScreenConnectedImpl implements DraftScreenConnected {
  const _$DraftScreenConnectedImpl(
      {required this.data, required this.authorized});

  @override
  final String data;
  @override
  final bool authorized;

  @override
  String toString() {
    return 'DraftScreenState.connected(data: $data, authorized: $authorized)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftScreenConnectedImpl &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.authorized, authorized) ||
                other.authorized == authorized));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data, authorized);

  /// Create a copy of DraftScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftScreenConnectedImplCopyWith<_$DraftScreenConnectedImpl>
      get copyWith =>
          __$$DraftScreenConnectedImplCopyWithImpl<_$DraftScreenConnectedImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String data, bool authorized) connected,
    required TResult Function(
            bool authorized, bool connecting, DraftScreenError? error)
        disconnected,
  }) {
    return connected(data, authorized);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data, bool authorized)? connected,
    TResult? Function(
            bool authorized, bool connecting, DraftScreenError? error)?
        disconnected,
  }) {
    return connected?.call(data, authorized);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data, bool authorized)? connected,
    TResult Function(bool authorized, bool connecting, DraftScreenError? error)?
        disconnected,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(data, authorized);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DraftScreenConnected value) connected,
    required TResult Function(DraftScreenDisconnected value) disconnected,
  }) {
    return connected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DraftScreenConnected value)? connected,
    TResult? Function(DraftScreenDisconnected value)? disconnected,
  }) {
    return connected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DraftScreenConnected value)? connected,
    TResult Function(DraftScreenDisconnected value)? disconnected,
    required TResult orElse(),
  }) {
    if (connected != null) {
      return connected(this);
    }
    return orElse();
  }
}

abstract class DraftScreenConnected implements DraftScreenState {
  const factory DraftScreenConnected(
      {required final String data,
      required final bool authorized}) = _$DraftScreenConnectedImpl;

  String get data;
  @override
  bool get authorized;

  /// Create a copy of DraftScreenState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftScreenConnectedImplCopyWith<_$DraftScreenConnectedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DraftScreenDisconnectedImplCopyWith<$Res>
    implements $DraftScreenStateCopyWith<$Res> {
  factory _$$DraftScreenDisconnectedImplCopyWith(
          _$DraftScreenDisconnectedImpl value,
          $Res Function(_$DraftScreenDisconnectedImpl) then) =
      __$$DraftScreenDisconnectedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool authorized, bool connecting, DraftScreenError? error});
}

/// @nodoc
class __$$DraftScreenDisconnectedImplCopyWithImpl<$Res>
    extends _$DraftScreenStateCopyWithImpl<$Res, _$DraftScreenDisconnectedImpl>
    implements _$$DraftScreenDisconnectedImplCopyWith<$Res> {
  __$$DraftScreenDisconnectedImplCopyWithImpl(
      _$DraftScreenDisconnectedImpl _value,
      $Res Function(_$DraftScreenDisconnectedImpl) _then)
      : super(_value, _then);

  /// Create a copy of DraftScreenState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorized = null,
    Object? connecting = null,
    Object? error = freezed,
  }) {
    return _then(_$DraftScreenDisconnectedImpl(
      authorized: null == authorized
          ? _value.authorized
          : authorized // ignore: cast_nullable_to_non_nullable
              as bool,
      connecting: null == connecting
          ? _value.connecting
          : connecting // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as DraftScreenError?,
    ));
  }
}

/// @nodoc

class _$DraftScreenDisconnectedImpl implements DraftScreenDisconnected {
  const _$DraftScreenDisconnectedImpl(
      {required this.authorized, this.connecting = false, this.error});

  @override
  final bool authorized;
  @override
  @JsonKey()
  final bool connecting;
  @override
  final DraftScreenError? error;

  @override
  String toString() {
    return 'DraftScreenState.disconnected(authorized: $authorized, connecting: $connecting, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftScreenDisconnectedImpl &&
            (identical(other.authorized, authorized) ||
                other.authorized == authorized) &&
            (identical(other.connecting, connecting) ||
                other.connecting == connecting) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, authorized, connecting, error);

  /// Create a copy of DraftScreenState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftScreenDisconnectedImplCopyWith<_$DraftScreenDisconnectedImpl>
      get copyWith => __$$DraftScreenDisconnectedImplCopyWithImpl<
          _$DraftScreenDisconnectedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String data, bool authorized) connected,
    required TResult Function(
            bool authorized, bool connecting, DraftScreenError? error)
        disconnected,
  }) {
    return disconnected(authorized, connecting, error);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String data, bool authorized)? connected,
    TResult? Function(
            bool authorized, bool connecting, DraftScreenError? error)?
        disconnected,
  }) {
    return disconnected?.call(authorized, connecting, error);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String data, bool authorized)? connected,
    TResult Function(bool authorized, bool connecting, DraftScreenError? error)?
        disconnected,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(authorized, connecting, error);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DraftScreenConnected value) connected,
    required TResult Function(DraftScreenDisconnected value) disconnected,
  }) {
    return disconnected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DraftScreenConnected value)? connected,
    TResult? Function(DraftScreenDisconnected value)? disconnected,
  }) {
    return disconnected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DraftScreenConnected value)? connected,
    TResult Function(DraftScreenDisconnected value)? disconnected,
    required TResult orElse(),
  }) {
    if (disconnected != null) {
      return disconnected(this);
    }
    return orElse();
  }
}

abstract class DraftScreenDisconnected implements DraftScreenState {
  const factory DraftScreenDisconnected(
      {required final bool authorized,
      final bool connecting,
      final DraftScreenError? error}) = _$DraftScreenDisconnectedImpl;

  @override
  bool get authorized;
  bool get connecting;
  DraftScreenError? get error;

  /// Create a copy of DraftScreenState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DraftScreenDisconnectedImplCopyWith<_$DraftScreenDisconnectedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
