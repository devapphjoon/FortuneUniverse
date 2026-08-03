import 'package:flutter/material.dart';
import '../developer_info.dart';
import '../contact_actions.dart';

class DeveloperContactScreen extends StatelessWidget {
  final String title;
  
  const DeveloperContactScreen({
    super.key,
    this.title = '개발자 연락처',
  });

  @override
  Widget build(BuildContext context) {
    final devInfo = DeveloperDataManager.getDeveloperInfo();
    // 실제 앱에서는 package_info_plus 등으로 패키지명을 가져오지만 임시로 하드코딩
    const String dummyPackageName = "com.hjoon.app";

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildProfile(context, devInfo),
          const SizedBox(height: 32),
          _buildContactOption(
            context,
            icon: Icons.email,
            title: '이메일 문의',
            subtitle: devInfo.email,
            onTap: () => sendEmail(context, devInfo.email),
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            context,
            icon: Icons.shop,
            title: 'Play Store 개발자 페이지',
            subtitle: '다른 앱들도 확인해보세요',
            onTap: () => openDeveloperPage(context, devInfo.playStoreUrl),
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            context,
            icon: Icons.star,
            title: '앱 평가하기',
            subtitle: '리뷰는 큰 힘이 됩니다',
            onTap: () => rateApp(context, dummyPackageName),
          ),
          const SizedBox(height: 16),
          _buildContactOption(
            context,
            icon: Icons.share,
            title: '앱 공유하기',
            subtitle: '주변에 이 앱을 추천해주세요',
            onTap: () => shareApp(context, dummyPackageName),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile(BuildContext context, DeveloperInfo info) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              info.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '앱 개발자',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption(BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
