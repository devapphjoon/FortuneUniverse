import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:monetization_module/monetization_module.dart';

import '../config/app_config.dart';
import '../services/audio_service.dart';
import '../services/notification_service.dart';
import '../../services/daily_limit_service.dart';

class AppBootstrapper {
  /// 앱 구동에 필요한 모든 핵심/부가 서비스들을 순차적으로,
  /// 단 하나의 에러에도 전체 시스템이 무너지지 않도록(try-catch) 초기화합니다.
  static Future<bool> initAll() async {
    bool isCriticalSuccess = true;

    // 1. 핵심 환경 설정 로드 (실패 시 치명적)
    try {
      await AppConfig.load();
    } catch (e) {
      debugPrint('[Bootstrapper] AppConfig load failed: $e');
      // 설정 로드 실패는 앱 구동 자체가 어려우므로 실패로 간주
      isCriticalSuccess = false;
    }

    // 2. 일일 제한 서비스 (필수)
    try {
      final dailyLimitService = DailyLimitService();
      await dailyLimitService.init();
      Get.put(dailyLimitService);
    } catch (e) {
      debugPrint('[Bootstrapper] DailyLimitService init failed: $e');
      isCriticalSuccess = false;
    }

    // --- 아래부터는 부가 서비스이므로 실패해도 앱 구동을 멈추지 않음 ---

    // 3. 광고 초기화
    try {
      AdManager.init(); // 내부적으로 비동기 처리됨
    } catch (e) {
      debugPrint('[Bootstrapper] AdManager init failed: $e');
    }

    // 4. 오디오 서비스
    try {
      await AudioService().init();
    } catch (e) {
      debugPrint('[Bootstrapper] AudioService init failed: $e');
    }

    // 5. 알림 서비스
    try {
      await NotificationService().init();
    } catch (e) {
      debugPrint('[Bootstrapper] NotificationService init failed: $e');
    }

    return isCriticalSuccess;
  }

  /// 기기에 저장된 사용자의 언어 설정을 불러옵니다.
  static Future<Locale> loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? savedLang = prefs.getString('language_code');
      final String? savedCountry = prefs.getString('country_code');
      
      if (savedLang != null && savedCountry != null) {
        return Locale(savedLang, savedCountry);
      }
    } catch (e) {
      debugPrint('[Bootstrapper] loadSavedLocale failed: $e');
    }
    
    // 디바이스 기본 언어 혹은 영어로 폴백
    return Get.deviceLocale ?? const Locale('en', 'US');
  }
}
