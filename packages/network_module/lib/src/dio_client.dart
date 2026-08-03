import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'interceptors/error_interceptor.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() => _instance;

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com', // 임시 테스트용 서버
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    // 로깅 인터셉터 (디버그 모드에서만 동작)
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
    }

    // 에러 공통 처리 인터셉터
    dio.interceptors.add(ErrorInterceptor());
  }
}
