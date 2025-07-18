// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercises_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExercisesListState {
  List<String> get categories => throw _privateConstructorUsedError;
  String get selectedCategory => throw _privateConstructorUsedError;
  List<ExerciseModel> get exercises => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isError => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of ExercisesListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExercisesListStateCopyWith<ExercisesListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExercisesListStateCopyWith<$Res> {
  factory $ExercisesListStateCopyWith(
          ExercisesListState value, $Res Function(ExercisesListState) then) =
      _$ExercisesListStateCopyWithImpl<$Res, ExercisesListState>;
  @useResult
  $Res call(
      {List<String> categories,
      String selectedCategory,
      List<ExerciseModel> exercises,
      bool isLoading,
      bool isError,
      String? errorMessage});
}

/// @nodoc
class _$ExercisesListStateCopyWithImpl<$Res, $Val extends ExercisesListState>
    implements $ExercisesListStateCopyWith<$Res> {
  _$ExercisesListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExercisesListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? selectedCategory = null,
    Object? exercises = null,
    Object? isLoading = null,
    Object? isError = null,
    Object? errorMessage = freezed,
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
      exercises: null == exercises
          ? _value.exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<ExerciseModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExercisesListStateImplCopyWith<$Res>
    implements $ExercisesListStateCopyWith<$Res> {
  factory _$$ExercisesListStateImplCopyWith(_$ExercisesListStateImpl value,
          $Res Function(_$ExercisesListStateImpl) then) =
      __$$ExercisesListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<String> categories,
      String selectedCategory,
      List<ExerciseModel> exercises,
      bool isLoading,
      bool isError,
      String? errorMessage});
}

/// @nodoc
class __$$ExercisesListStateImplCopyWithImpl<$Res>
    extends _$ExercisesListStateCopyWithImpl<$Res, _$ExercisesListStateImpl>
    implements _$$ExercisesListStateImplCopyWith<$Res> {
  __$$ExercisesListStateImplCopyWithImpl(_$ExercisesListStateImpl _value,
      $Res Function(_$ExercisesListStateImpl) _then)
      : super(_value, _then);

  /// Create a copy of ExercisesListState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? categories = null,
    Object? selectedCategory = null,
    Object? exercises = null,
    Object? isLoading = null,
    Object? isError = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ExercisesListStateImpl(
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedCategory: null == selectedCategory
          ? _value.selectedCategory
          : selectedCategory // ignore: cast_nullable_to_non_nullable
              as String,
      exercises: null == exercises
          ? _value._exercises
          : exercises // ignore: cast_nullable_to_non_nullable
              as List<ExerciseModel>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isError: null == isError
          ? _value.isError
          : isError // ignore: cast_nullable_to_non_nullable
              as bool,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ExercisesListStateImpl implements _ExercisesListState {
  const _$ExercisesListStateImpl(
      {final List<String> categories = const [
        'Full body',
        'Chest',
        'Back',
        'Arms',
        'Legs',
        'Core'
      ],
      this.selectedCategory = 'Full body',
      final List<ExerciseModel> exercises = const [],
      this.isLoading = false,
      this.isError = false,
      this.errorMessage})
      : _categories = categories,
        _exercises = exercises;

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
  final List<ExerciseModel> _exercises;
  @override
  @JsonKey()
  List<ExerciseModel> get exercises {
    if (_exercises is EqualUnmodifiableListView) return _exercises;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exercises);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isError;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ExercisesListState(categories: $categories, selectedCategory: $selectedCategory, exercises: $exercises, isLoading: $isLoading, isError: $isError, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExercisesListStateImpl &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.selectedCategory, selectedCategory) ||
                other.selectedCategory == selectedCategory) &&
            const DeepCollectionEquality()
                .equals(other._exercises, _exercises) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isError, isError) || other.isError == isError) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_categories),
      selectedCategory,
      const DeepCollectionEquality().hash(_exercises),
      isLoading,
      isError,
      errorMessage);

  /// Create a copy of ExercisesListState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExercisesListStateImplCopyWith<_$ExercisesListStateImpl> get copyWith =>
      __$$ExercisesListStateImplCopyWithImpl<_$ExercisesListStateImpl>(
          this, _$identity);
}

abstract class _ExercisesListState implements ExercisesListState {
  const factory _ExercisesListState(
      {final List<String> categories,
      final String selectedCategory,
      final List<ExerciseModel> exercises,
      final bool isLoading,
      final bool isError,
      final String? errorMessage}) = _$ExercisesListStateImpl;

  @override
  List<String> get categories;
  @override
  String get selectedCategory;
  @override
  List<ExerciseModel> get exercises;
  @override
  bool get isLoading;
  @override
  bool get isError;
  @override
  String? get errorMessage;

  /// Create a copy of ExercisesListState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExercisesListStateImplCopyWith<_$ExercisesListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
