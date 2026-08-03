import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../auth_manager.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onLoginSuccess;

  const SocialLoginButtons({super.key, required this.onLoginSuccess});

  Widget _buildLoginButton(
      BuildContext context, String provider, Color bgColor, Color textColor, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            foregroundColor: textColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: Icon(icon),
          label: Text('login_with_$provider'.tr, style: const TextStyle(fontWeight: FontWeight.bold)),
          onPressed: () async {
            // 로딩 오버레이는 이 버튼을 호출하는 곳이나 여기서 띄울 수 있습니다.
            Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
            final success = await AuthManager().loginWith(provider);
            Get.back(); // 로딩 닫기
            if (success) {
              onLoginSuccess();
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildLoginButton(context, 'kakao', const Color(0xFFFEE500), Colors.black87, Icons.chat_bubble),
        _buildLoginButton(context, 'naver', const Color(0xFF03C75A), Colors.white, Icons.person),
        _buildLoginButton(context, 'google', Colors.white, Colors.black87, Icons.language),
        _buildLoginButton(context, 'apple', Colors.black, Colors.white, Icons.apple),
      ],
    );
  }
}
