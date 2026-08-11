import 'package:flutter/material.dart';
import 'package:onboarding_module/onboarding_module.dart';
import 'package:permission_module/permission_module.dart';
import 'main.dart'; // MainScreen 참조용

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool _isLoading = true;
  bool _showOnboarding = false;
  bool _showPermission = false;

  @override
  void initState() {
    super.initState();
    _checkAppLaunchState();
  }

  Future<void> _checkAppLaunchState() async {
    // 1. 온보딩 확인
    bool hasSeenOnboarding = await OnboardingManager.hasSeenOnboarding();
    if (!hasSeenOnboarding) {
      setState(() {
        _showOnboarding = true;
        _isLoading = false;
      });
      return;
    }

    // 2. 필수 권한 확인
    bool hasPermissions = await PermissionManager().checkAllPermissionsGranted();
    if (!hasPermissions) {
      setState(() {
        _showPermission = true;
        _isLoading = false;
      });
      return;
    }

    // 모두 완료되었다면 메인 화면으로 이동
    setState(() {
      _isLoading = false;
    });
  }

  void _onOnboardingComplete() {
    setState(() {
      _showOnboarding = false;
      _isLoading = true;
    });
    _checkAppLaunchState(); // 다음 단계(권한) 체크
  }

  void _onPermissionsGranted() {
    setState(() {
      _showPermission = false;
      _isLoading = true;
    });
    _checkAppLaunchState(); // 다음 단계 체크
  }


  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_showOnboarding) {
      return OnboardingScreen(onComplete: _onOnboardingComplete);
    }

    if (_showPermission) {
      return PermissionRationaleScreen(onPermissionsGranted: _onPermissionsGranted);
    }



    // 모든 관문을 통과했다면 실제 메인 앱 화면 표출
    return const MainScreen();
  }
}
