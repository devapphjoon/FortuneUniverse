import 'dart:ui';
import 'package:flutter/material.dart';

class GlobalErrorHandler {
  static void init() {
    // Flutter 프레임워크 내에서 발생하는 렌더링 에러 등을 캐치
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.presentError(details);
      _logError('FlutterError', details.exception, details.stack);
    };

    // Dart 비동기 처리 과정 등에서 발생하는 에러를 캐치
    PlatformDispatcher.instance.onError = (error, stack) {
      _logError('PlatformDispatcherError', error, stack);
      return true; // 에러가 앱을 종료시키지 않도록 true 반환
    };
  }

  static void _logError(String type, Object error, StackTrace? stack) {
    debugPrint('==================================================');
    debugPrint('🔥 [GLOBAL ERROR CAUGHT] $type 🔥');
    debugPrint('Error: $error');
    if (stack != null) {
      debugPrint('Stack: $stack');
    }
    debugPrint('==================================================');
    // TODO: 프로덕션에서는 Firebase Crashlytics 등으로 에러 로그를 전송합니다.
  }
}
