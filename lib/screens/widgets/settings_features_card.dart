import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_module/settings_module.dart';
import '../../core/services/audio_service.dart';
import '../../core/services/notification_service.dart';

class SettingsFeaturesCard extends StatefulWidget {
  const SettingsFeaturesCard({super.key});

  @override
  State<SettingsFeaturesCard> createState() => _SettingsFeaturesCardState();
}

class _SettingsFeaturesCardState extends State<SettingsFeaturesCard> {
  bool _isBgmEnabled = false;
  bool _isSfxEnabled = false;
  bool _isNotificationEnabled = false;

  @override
  void initState() {
    super.initState();
    _isBgmEnabled = AudioService().isBgmEnabled;
    _isSfxEnabled = AudioService().isSfxEnabled;
    _isNotificationEnabled = NotificationService().isNotificationEnabled;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsToggleCard(
          title: 'daily_notification'.tr,
          subtitle: 'daily_notification_desc'.tr,
          icon: Icons.notifications_active,
          value: _isNotificationEnabled,
          onChanged: (val) async {
            await NotificationService().setNotificationEnabled(val);
            setState(() {
              _isNotificationEnabled = NotificationService().isNotificationEnabled;
            });
            if (context.mounted && _isNotificationEnabled) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('notification_changed'.tr)),
              );
            }
          },
        ),
        const SizedBox(height: 12),
        SettingsToggleCard(
          title: 'bgm_sound'.tr,
          subtitle: 'bgm_sound_desc'.tr,
          icon: Icons.music_note,
          value: _isBgmEnabled,
          onChanged: (val) async {
            await AudioService().setBgmEnabled(val);
            setState(() {
              _isBgmEnabled = AudioService().isBgmEnabled;
            });
          },
        ),
        const SizedBox(height: 12),
        SettingsToggleCard(
          title: 'sfx_sound'.tr,
          subtitle: 'sfx_sound_desc'.tr,
          icon: Icons.volume_up,
          value: _isSfxEnabled,
          onChanged: (val) async {
            await AudioService().setSfxEnabled(val);
            setState(() {
              _isSfxEnabled = AudioService().isSfxEnabled;
            });
          },
        ),
      ],
    );
  }
}
