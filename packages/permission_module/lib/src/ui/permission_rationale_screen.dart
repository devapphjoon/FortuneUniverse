import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../permission_manager.dart';

class PermissionRationaleScreen extends StatelessWidget {
  final VoidCallback onPermissionsGranted;

  const PermissionRationaleScreen({super.key, required this.onPermissionsGranted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(Icons.security, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              Text(
                'permission_title'.tr,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'permission_desc'.tr,
                style: const TextStyle(fontSize: 16, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text('permission_camera'.tr),
                subtitle: Text('permission_camera_desc'.tr),
              ),
              ListTile(
                leading: const Icon(Icons.photo),
                title: Text('permission_photo'.tr),
                subtitle: Text('permission_photo_desc'.tr),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () async {
                  await PermissionManager().requestPermissions();
                  onPermissionsGranted(); // 에뮬레이터 등에서 거부되더라도 일단 다음 화면으로 넘어감
                },
                child: Text('permission_allow_btn'.tr, style: const TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
