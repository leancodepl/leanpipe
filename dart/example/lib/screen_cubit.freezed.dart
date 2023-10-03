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
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

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

  @JsonKey(ignore: true)
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
abstract class _$$DraftScreenConnectedCopyWith<$Res>
    implements $DraftScreenStateCopyWith<$Res> {
  factory _$$DraftScreenConnectedCopyWith(_$DraftScreenConnected value,
          $Res Function(_$DraftScreenConnected) then) =
      __$$DraftScreenConnectedCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String data, bool authorized});
}

/// @nodoc
class __$$DraftScreenConnectedCopyWithImpl<$Res>
    extends _$DraftScreenStateCopyWithImpl<$Res, _$DraftScreenConnected>
    implements _$$DraftScreenConnectedCopyWith<$Res> {
  __$$DraftScreenConnectedCopyWithImpl(_$DraftScreenConnected _value,
      $Res Function(_$DraftScreenConnected) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? authorized = null,
  }) {
    return _then(_$DraftScreenConnected(
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

class _$DraftScreenConnected implements DraftScreenConnected {
  const _$DraftScreenConnected({required this.data, required this.authorized});

  @override
  final String data;
  @override
  final bool authorized;

  @override
  String toString() {
    return 'DraftScreenState.connected(data: $data, authorized: $authorized)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftScreenConnected &&
            (identical(other.data, data) || other.data == data) &&
            (identical(other.authorized, authorized) ||
                other.authorized == authorized));
  }

  @override
  int get hashCode => Object.hash(runtimeType, data, authorized);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftScreenConnectedCopyWith<_$DraftScreenConnected> get copyWith =>
      __$$DraftScreenConnectedCopyWithImpl<_$DraftScreenConnected>(
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
      required final bool authorized}) = _$DraftScreenConnected;

  String get data;
  @override
  bool get authorized;
  @override
  @JsonKey(ignore: true)
  _$$DraftScreenConnectedCopyWith<_$DraftScreenConnected> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$DraftScreenDisconnectedCopyWith<$Res>
    implements $DraftScreenStateCopyWith<$Res> {
  factory _$$DraftScreenDisconnectedCopyWith(_$DraftScreenDisconnected value,
          $Res Function(_$DraftScreenDisconnected) then) =
      __$$DraftScreenDisconnectedCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool authorized, bool connecting, DraftScreenError? error});
}

/// @nodoc
class __$$DraftScreenDisconnectedCopyWithImpl<$Res>
    extends _$DraftScreenStateCopyWithImpl<$Res, _$DraftScreenDisconnected>
    implements _$$DraftScreenDisconnectedCopyWith<$Res> {
  __$$DraftScreenDisconnectedCopyWithImpl(_$DraftScreenDisconnected _value,
      $Res Function(_$DraftScreenDisconnected) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorized = null,
    Object? connecting = null,
    Object? error = freezed,
  }) {
    return _then(_$DraftScreenDisconnected(
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

class _$DraftScreenDisconnected implements DraftScreenDisconnected {
  const _$DraftScreenDisconnected(
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
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DraftScreenDisconnected &&
            (identical(other.authorized, authorized) ||
                other.authorized == authorized) &&
            (identical(other.connecting, connecting) ||
                other.connecting == connecting) &&
            (identical(other.error, error) || other.error == error));
  }

  @override
  int get hashCode => Object.hash(runtimeType, authorized, connecting, error);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DraftScreenDisconnectedCopyWith<_$DraftScreenDisconnected> get copyWith =>
      __$$DraftScreenDisconnectedCopyWithImpl<_$DraftScreenDisconnected>(
          this, _$identity);

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
      final DraftScreenError? error}) = _$DraftScreenDisconnected;

  @override
  bool get authorized;
  bool get connecting;
  DraftScreenError? get error;
  @override
  @JsonKey(ignore: true)
  _$$DraftScreenDisconnectedCopyWith<_$DraftScreenDisconnected> get copyWith =>
      throw _privateConstructorUsedError;
}
