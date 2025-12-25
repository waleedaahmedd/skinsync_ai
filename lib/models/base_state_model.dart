import 'package:flutter/foundation.dart';

/// Base class for all states
@immutable
class BaseStateModel {
  final bool loading;
  final String? errorMessage;

  const BaseStateModel({this.loading = false, this.errorMessage});

  /// Copy with to create a new instance with updated fields
  BaseStateModel copyWith({bool? loading, String? errorMessage}) {
    return BaseStateModel(
      loading: loading ?? this.loading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
