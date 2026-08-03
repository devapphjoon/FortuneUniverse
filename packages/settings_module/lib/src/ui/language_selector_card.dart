import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LanguageSelectorCard extends StatelessWidget {
  const LanguageSelectorCard({super.key});

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('language'.tr),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('한국어'),
                trailing: Get.locale?.languageCode == 'ko' ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                onTap: () {
                  Get.updateLocale(const Locale('ko', 'KR'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                trailing: Get.locale?.languageCode == 'en' ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                onTap: () {
                  Get.updateLocale(const Locale('en', 'US'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(Icons.language, color: Theme.of(context).colorScheme.secondary),
        ),
        title: Text('language'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => _showLanguageDialog(context),
      ),
    );
  }
}
