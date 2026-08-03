import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LegalLinksCard extends StatelessWidget {
  final String termsUrl;
  final String privacyUrl;
  final String appName;

  const LegalLinksCard({
    super.key,
    required this.termsUrl,
    required this.privacyUrl,
    required this.appName,
  });

  Future<void> _openLink(BuildContext context, String baseUrl) async {
    // 앱 이름을 파라미터로 동적으로 붙여줌 (하나의 웹문서로 수백 개 앱 대응)
    final urlWithParam = "$baseUrl?app=${Uri.encodeComponent(appName)}";
    final uri = Uri.parse(urlWithParam);
    
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('cannot_open_page'.tr)));
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${'error_occurred'.tr}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.description),
            title: Text('terms'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
            onTap: () => _openLink(context, termsUrl),
          ),
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.privacy_tip),
            title: Text('privacy'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
            trailing: const Icon(Icons.open_in_new, size: 16, color: Colors.grey),
            onTap: () => _openLink(context, privacyUrl),
          ),
        ],
      ),
    );
  }
}
