import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectorCard extends StatelessWidget {
  final BoxDecoration? customDecoration;
  final TextStyle? customTitleStyle;
  final Color? customIconColor;
  final Color? customIconBackgroundColor;
  final Color? customTrailingColor;
  final bool showDialogTitle;

  const LanguageSelectorCard({
    super.key,
    this.customDecoration,
    this.customTitleStyle,
    this.customIconColor,
    this.customIconBackgroundColor,
    this.customTrailingColor,
    this.showDialogTitle = false,
  });

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: showDialogTitle ? Text('language'.tr) : null,
          contentPadding: showDialogTitle ? const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 24.0) : const EdgeInsets.symmetric(vertical: 20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('한국어'),
                trailing: Get.locale?.languageCode == 'ko' ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                onTap: () async {
                  Get.updateLocale(const Locale('ko', 'KR'));
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('language_code', 'ko');
                  await prefs.setString('country_code', 'KR');
                  if (context.mounted) Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('English'),
                trailing: Get.locale?.languageCode == 'en' ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary) : null,
                onTap: () async {
                  Get.updateLocale(const Locale('en', 'US'));
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('language_code', 'en');
                  await prefs.setString('country_code', 'US');
                  if (context.mounted) Navigator.pop(context);
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
    return Container(
      decoration: customDecoration ?? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: customIconBackgroundColor ?? Theme.of(context).colorScheme.secondaryContainer,
          child: Icon(Icons.language, color: customIconColor ?? Theme.of(context).colorScheme.secondary),
        ),
        title: Text('language'.tr, style: customTitleStyle ?? const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Icon(Icons.chevron_right, color: customTrailingColor ?? Colors.grey),
        onTap: () => _showLanguageDialog(context),
      ),
    );
  }
}
