import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  static final PermissionManager _instance = PermissionManager._internal();
  factory PermissionManager() => _instance;
  PermissionManager._internal();

  /// 필수 권한들 리스트
  final List<Permission> requiredPermissions = [
    Permission.camera,
    Permission.photos,
    Permission.notification,
    if (defaultTargetPlatform == TargetPlatform.iOS)
      Permission.appTrackingTransparency, // iOS 맞춤형 광고 추적 권한 (필수)
  ];

  /// 권한이 모두 허용되었는지 확인
  Future<bool> checkAllPermissionsGranted() async {
    for (var permission in requiredPermissions) {
      if (!await permission.isGranted) {
        return false;
      }
    }
    return true;
  }

  /// 권한 요청 실행
  Future<bool> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await requiredPermissions.request();
    bool allGranted = true;
    statuses.forEach((permission, status) {
      if (!status.isGranted) {
        allGranted = false;
      }
    });
    return allGranted;
  }
}
