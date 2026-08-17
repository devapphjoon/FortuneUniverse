import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class AppConfig {
  static late Map<String, dynamic> _config;

  static Future<void> load() async {
    try {
      final configString = await rootBundle.loadString('assets/app_config.json');
      _config = jsonDecode(configString);
    } catch (e) {
      debugPrint('Failed to load app_config.json: $e');
      _config = {};
    }
  }

  static String get appName => _config['appName'] ?? 'Unknown App';
  static String get apiBaseUrl => _config['apiBaseUrl'] ?? '';
  static Map<String, dynamic> get theme => _config['theme'] ?? {};
  
  // 앱마다 다르게 껐다 켤 수 있는 기능 스위치 (Feature Flags)
  static const Map<String, dynamic> features = {
    'showAppVersion': true,
    'showLegalLinks': true,
    'showLanguageSelector': true,
    'showLicense': true,
    'showContactOptions': true,
  };
  
  // 파이어베이스 등에 올려둔 공통 약관 주소 템플릿
  static const Map<String, dynamic> legalLinks = {
    'privacyPolicy': 'https://app.notion.com/p/Privacy-Policy-for-Fortune-Universe-3b9a22ab016f80c98689da581fab4547?source=copy_link',
  };
}
