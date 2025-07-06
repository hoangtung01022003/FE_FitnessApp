// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercises_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExercisesState {
  List<String> get categories => throw _privateConstructorUsedError;
  String get selectedCategory => throw _privateConstructorUsedError;

  /// Create a copy of ExercisesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExercisesStateCopyWith<ExercisesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExercisesStateCopyWith<$Res> {
  factory $ExercisesStateCopyWith(
          ExercisesState value, $Res Function(ExercisesState) then) =
      _$ExercisesStateCopyWithImpl<$Res, ExercisesState>;
  @useResult
  $Res call({List<String> categories, String selectedCategory});
}

/// @nodoc
class _$ExercisesStateCopyWithImpl<$Res, $Val extends ExercisesState>
    implements $ExercisesStateCopyWith<$Res> {
  _$ExercisesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExercisesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? selectedCategory = null,
  }) {
    return _then(_value.copyWith(
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedCategory: null == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExercisesStateImplCopyWith<$Res>
    implements $ExercisesStateCopyWith<$Res> {
  factory _$$ExercisesStateImplCopyWith(_$ExercisesStateImpl value,
          $Res Function(_$ExercisesStateImpl) then) =
      __$$ExercisesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> categories, String selectedCategory});
}

/// @nodoc
class __$$ExercisesStateImplCopyWithImpl<$Res>
    extends _$ExercisesStateCopyWithImpl<$Res, _$ExercisesStateImpl>
    implements _$$ExercisesStateImplCopyWith<$Res> {
  __$$ExercisesStateImplCopyWithImpl(
      _$ExercisesStateImpl _value, $Res Function(_$ExercisesStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExercisesState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? selectedCategory = null,
  }) {
    return _then(_$ExercisesStateImpl(
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedCategory: null == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ExercisesStateImpl implements _ExercisesState {
  const _$ExercisesStateImpl(
      {final List<String> categories = const [
        'Full body',
        'Foot',
        'Arm',
        'Body'
      ],
      this.selectedCategory = 'Full body'})
      : _categories = categories;

  final List<String> _categories;
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  @JsonKey()
  final String selectedCategory;

  @override
  String toString() {
    return 'ExercisesState(categories: $categories, selectedCategory: $selectedCategory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExercisesStateImpl &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory));
  }

  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_categories), selectedCategory);

  /// Create a copy of ExercisesState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExercisesStateImplCopyWith<_$ExercisesStateImpl> get copyWith =>
      __$$ExercisesStateImplCopyWithImpl<_$ExercisesStateImpl>(
          this, _$identity);
}

abstract class _ExercisesState implements ExercisesState {
  const factory _ExercisesState(
      {final List<String> categories,
      final String selectedCategory}) = _$ExercisesStateImpl;

  @override
  List<String> get categories;
  @override
  String get selectedCategory;

  /// Create a copy of ExercisesState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExercisesStateImplCopyWith<_$ExercisesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
