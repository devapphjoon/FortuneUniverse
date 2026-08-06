import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../developer_info.dart';

class DeveloperProfileCard extends StatelessWidget {
  final DeveloperInfo info;
  final BoxDecoration? customDecoration;
  final TextStyle? customTitleStyle;
  final TextStyle? customSubtitleStyle;
  final Color? customIconColor;
  final Color? customIconBackgroundColor;

  const DeveloperProfileCard({
    super.key,
    required this.info,
    this.customDecoration,
    this.customTitleStyle,
    this.customSubtitleStyle,
    this.customIconColor,
    this.customIconBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: customDecoration ?? BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 1)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: customIconBackgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
              child: Icon(Icons.person, size: 40, color: customIconColor ?? Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(height: 16),
            Text(
              info.name,
              style: customTitleStyle ?? const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'dev_role'.tr,
              style: customSubtitleStyle ?? const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  
  final BoxDecoration? customDecoration;
  final TextStyle? customTitleStyle;
  final TextStyle? customSubtitleStyle;
  final Color? customIconColor;
  final Color? customIconBackgroundColor;
  final Color? customTrailingColor;

  const ContactOptionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.customDecoration,
    this.customTitleStyle,
    this.customSubtitleStyle,
    this.customIconColor,
    this.customIconBackgroundColor,
    this.customTrailingColor,
  });

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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: customIconBackgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: customIconColor ?? Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: customTitleStyle ?? const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: customSubtitleStyle),
        trailing: Icon(Icons.chevron_right, color: customTrailingColor ?? Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
