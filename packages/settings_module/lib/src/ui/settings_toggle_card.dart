import 'package:flutter/material.dart';

class SettingsToggleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  
  // Custom styling hooks
  final BoxDecoration? customDecoration;
  final TextStyle? customTitleStyle;
  final TextStyle? customSubtitleStyle;
  final Color? customIconColor;
  final Color? customIconBackgroundColor;
  final Color? customActiveColor;
  final Color? customInactiveTrackColor;

  const SettingsToggleCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.customDecoration,
    this.customTitleStyle,
    this.customSubtitleStyle,
    this.customIconColor,
    this.customIconBackgroundColor,
    this.customActiveColor,
    this.customInactiveTrackColor,
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
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: CircleAvatar(
          backgroundColor: customIconBackgroundColor ?? Theme.of(context).colorScheme.primaryContainer,
          child: Icon(icon, color: customIconColor ?? Theme.of(context).colorScheme.primary),
        ),
        title: Text(title, style: customTitleStyle ?? const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: customSubtitleStyle),
        value: value,
        onChanged: onChanged,
        activeColor: customActiveColor,
        inactiveTrackColor: customInactiveTrackColor,
      ),
    );
  }
}
