import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'ui/notice_dialog.dart';
import 'ui/force_update_dialog.dart';

class NoticeManager {
  /// 앱 시작 시 호출되어 공지사항이나 강제 업데이트가 있는지 확인
  static Future<void> checkNotices(BuildContext context) async {
    // 실제 운영 시에는 Firebase Remote Config 나 자체 서버 API를 호출합니다.
    // 여기서는 테스트를 위해 1초 대기 후 가짜 데이터 반환
    await Future.delayed(const Duration(seconds: 1));

    // 더미 서버 응답
    final bool hasNotice = true;
    final String noticeTitle = "notice_update_title".tr;
    final String noticeContent = "notice_update_content".tr;
    final bool isForceUpdate = false; // 강제 업데이트 여부 (true면 스토어로 유도)
    final String storeUrl = "https://play.google.com/store/apps/details?id=com.hjoon.app";

    if (!context.mounted) return;

    if (isForceUpdate) {
      Get.dialog(
        ForceUpdateDialog(
          title: "force_update_title".tr,
          content: "force_update_content".tr,
          storeUrl: storeUrl,
        ),
        barrierDismissible: false, // 바깥을 눌러서 닫을 수 없음
      );
    } else if (hasNotice) {
      Get.dialog(
        NoticeDialog(
          title: noticeTitle,
          content: noticeContent,
        ),
      );
    }
  }
}
