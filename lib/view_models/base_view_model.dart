import 'dart:developer';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../app_init.dart';
import '../exceptions/app_exception.dart';
import '../screens/update_version_screen.dart';

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

  Future<T?> runSafely<T>(AsyncValueGetter<T?> action) async {
    try {
      return await action.call();
    } on UpdateAppException catch (_) {
      navigatorKey.currentState?.pushNamedAndRemoveUntil(
        UpdateVersionScreen.routeName,
        (route) => false,
      );
      return null;
    } on SignInWithAppleException catch (e, s) {
      if (e is SignInWithAppleAuthorizationException &&
          e.code == AuthorizationErrorCode.canceled) {
        onCancel();
        return null;
      }
      log(e.toString(), stackTrace: s);
      onError('Something went wrong. Please try again.');
      FirebaseCrashlytics.instance.recordError(e, s);
      return null;
    } on GoogleSignInException catch (e, s) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        onCancel();
        return null;
      }
      log(e.description ?? 'N/A', stackTrace: s);
      onError('Something went wrong. Please try again.');
      FirebaseCrashlytics.instance.recordError(e, s);
      return null;
    } on AppException catch (e, s) {
      log(e.message, stackTrace: s);
      onError(e.message);
      FirebaseCrashlytics.instance.recordError(e, s);
      return null;
    } catch (e, s) {
      log(e.toString(), stackTrace: s);
      onError(e.toString().replaceAll('Exception:', ''));
      FirebaseCrashlytics.instance.recordError(e, s);
      return null;
    }
  }

  @mustCallSuper
  void onError(String message) {
    EasyLoading.showError(message);
  }

  void onCancel() {}
}
