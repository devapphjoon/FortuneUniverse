import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoadingOverlay {
  static bool _isShowing = false;

  static void show() {
    if (_isShowing) return;
    _isShowing = true;
    
    Get.dialog(
      PopScope(
        canPop: false, // 로딩 중에는 뒤로가기 버튼 무시
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hide() {
    if (_isShowing) {
      _isShowing = false;
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    }
  }
}
