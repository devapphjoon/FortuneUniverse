import 'package:flutter/foundation.dart';

class AuthManager {
  static final AuthManager _instance = AuthManager._internal();
  factory AuthManager() => _instance;
  
  AuthManager._internal();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  /// 서버나 로컬 저장소에서 기존 로그인 토큰을 확인합니다.
  Future<bool> checkLoginStatus() async {
    // 임시 더미 로직 (실제로는 SecureStorage 등을 확인)
    await Future.delayed(const Duration(milliseconds: 500));
    // 이전에 로그인된 상태(_isLoggedIn)를 그대로 반환합니다.
    return _isLoggedIn;
  }

  /// 소셜 로그인 처리 (구글, 카카오, 네이버, 애플)
  Future<bool> loginWith(String provider) async {
    debugPrint('로그인 시도: $provider');
    await Future.delayed(const Duration(seconds: 1)); // 통신 지연 시뮬레이션
    _isLoggedIn = true;
    return true;
  }

  /// 로그아웃
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoggedIn = false;
  }

  /// 회원 탈퇴 (앱 마켓 정책 필수 요건)
  Future<void> deleteAccount() async {
    // 실제로는 서버에 회원 탈퇴 API를 호출하고 로컬 데이터를 삭제해야 합니다.
    debugPrint('회원 탈퇴 처리 시작...');
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = false;
    debugPrint('회원 탈퇴 완료');
  }
}
