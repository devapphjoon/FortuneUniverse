import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  static late Map<String, dynamic> _config;

  static Future<void> load() async {
    final configString = await rootBundle.loadString('assets/app_config.json');
    _config = jsonDecode(configString);
  }

  static String get appName => _config['appName'] ?? 'Unknown App';
  static String get apiBaseUrl => _config['apiBaseUrl'] ?? '';
  static Map<String, dynamic> get theme => _config['theme'] ?? {};
  
  // 앱마다 다르게 껐다 켤 수 있는 기능 스위치 (Feature Flags)
  static const Map<String, dynamic> features = {
    'enableNotifications': true,
    'enablePayments': false,
    'showDarkModeToggle': true,
    'showAppVersion': true,
    'showLegalLinks': true,
    'showLanguageSelector': true,
    'showLicense': true,
    'showAds': true,
    'checkNotices': true,
  };
  
  // 파이어베이스 등에 올려둔 공통 약관 주소 템플릿
  static const Map<String, dynamic> legalLinks = {
    'termsOfService': 'https://my-firebase-app.web.app/terms',
    'privacyPolicy': 'https://my-firebase-app.web.app/privacy',
  };
}
