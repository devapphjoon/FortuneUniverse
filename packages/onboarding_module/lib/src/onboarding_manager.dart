import 'package:shared_preferences/shared_preferences.dart';

class OnboardingManager {
  static const String _key = 'has_seen_onboarding';

  /// 온보딩을 이미 보았는지 확인
  static Future<bool> hasSeenOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key) ?? false;
  }

  /// 온보딩을 보았다고 체크 (최초 1회만 표시하기 위해)
  static Future<void> markOnboardingAsSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key, true);
  }
}
