// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'menu_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MenuState {
  String get selectedItem => throw _privateConstructorUsedError;

  /// Create a copy of MenuState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MenuStateCopyWith<MenuState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MenuStateCopyWith<$Res> {
  factory $MenuStateCopyWith(MenuState value, $Res Function(MenuState) then) =
      _$MenuStateCopyWithImpl<$Res, MenuState>;
  @useResult
  $Res call({String selectedItem});
}

/// @nodoc
class _$MenuStateCopyWithImpl<$Res, $Val extends MenuState>
    implements $MenuStateCopyWith<$Res> {
  _$MenuStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of MenuState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedItem = null,
  }) {
    return _then(_value.copyWith(
      selectedItem: null == selectedItem
          ? _value.selectedItem
          : selectedItem // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MenuStateImplCopyWith<$Res>
    implements $MenuStateCopyWith<$Res> {
  factory _$$MenuStateImplCopyWith(
          _$MenuStateImpl value, $Res Function(_$MenuStateImpl) then) =
      __$$MenuStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String selectedItem});
}

/// @nodoc
class __$$MenuStateImplCopyWithImpl<$Res>
    extends _$MenuStateCopyWithImpl<$Res, _$MenuStateImpl>
    implements _$$MenuStateImplCopyWith<$Res> {
  __$$MenuStateImplCopyWithImpl(
      _$MenuStateImpl _value, $Res Function(_$MenuStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of MenuState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedItem = null,
  }) {
    return _then(_$MenuStateImpl(
      selectedItem: null == selectedItem
          ? _value.selectedItem
          : selectedItem // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$MenuStateImpl implements _MenuState {
  const _$MenuStateImpl({this.selectedItem = 'Running'});

  @override
  @JsonKey()
  final String selectedItem;

  @override
  String toString() {
    return 'MenuState(selectedItem: $selectedItem)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MenuStateImpl &&
            (identical(other.selectedItem, selectedItem) ||
                other.selectedItem == selectedItem));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedItem);

  /// Create a copy of MenuState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MenuStateImplCopyWith<_$MenuStateImpl> get copyWith =>
      __$$MenuStateImplCopyWithImpl<_$MenuStateImpl>(this, _$identity);
}

abstract class _MenuState implements MenuState {
  const factory _MenuState({final String selectedItem}) = _$MenuStateImpl;

  @override
  String get selectedItem;

  /// Create a copy of MenuState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MenuStateImplCopyWith<_$MenuStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
