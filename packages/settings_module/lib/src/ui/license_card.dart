import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LicenseCard extends StatelessWidget {
  final String appName;
  final String? applicationVersion;
  final Widget? applicationIcon;

  const LicenseCard({
    super.key,
    required this.appName,
    this.applicationVersion,
    this.applicationIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
          child: Icon(Icons.gavel, color: Theme.of(context).colorScheme.tertiary),
        ),
        title: Text('open_source_license'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          showLicensePage(
            context: context,
            applicationName: appName,
            applicationVersion: applicationVersion,
            applicationIcon: applicationIcon,
          );
        },
      ),
    );
  }
}
