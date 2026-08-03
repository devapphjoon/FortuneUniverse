import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NoticeDialog extends StatelessWidget {
  final String title;
  final String content;

  const NoticeDialog({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.campaign, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('close_btn'.tr),
        ),
      ],
    );
  }
}
