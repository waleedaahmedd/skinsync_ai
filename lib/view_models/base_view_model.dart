import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../exceptions/app_exception.dart';

abstract class BaseViewModel<S> extends Notifier<S> {
  final S initialState;

  BaseViewModel({required this.initialState});

  @override
  S build() {
    init();
    ref.onDispose(dispose);
    return initialState;
  }

  @mustCallSuper
  void init() {
    log('$runtimeType INITIALIZED', name: 'RIVERPOD');
  }

  @mustCallSuper
  void dispose() {
    log('$runtimeType DISPOSED', name: 'RIVERPOD');
  }

  Future<T?> runSafely<T>(AsyncValueGetter<T> action) async {
    try {
      return await action.call();
    } on AppException catch (e, s) {
      log(e.toString(), stackTrace: s);
      onError(e.message);
      return null;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      onError(e.toString().replaceAll('Exception:', ''));
      return null;
    }
  }

  @mustCallSuper
  void onError(String message) {
    // EasyLoading.showError(message);
  }
}
