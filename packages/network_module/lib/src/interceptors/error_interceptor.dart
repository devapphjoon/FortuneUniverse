import 'package:dio/dio.dart';
import 'package:get/get.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage = "network_error_unknown".tr;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = "network_error_timeout".tr;
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 404) {
          errorMessage = "network_error_404".tr;
        } else if (statusCode == 500) {
          errorMessage = "network_error_500".tr;
        } else {
          errorMessage = '${"network_error_server".tr} ($statusCode)';
        }
        break;
      case DioExceptionType.connectionError:
        errorMessage = "network_error_connection".tr;
        break;
      default:
        break;
    }

    // 전역으로 에러 스낵바 띄우기
    Get.snackbar(
      "error_occurred".tr,
      errorMessage,
      snackPosition: SnackPosition.BOTTOM,
    );

    super.onError(err, handler);
  }
}
