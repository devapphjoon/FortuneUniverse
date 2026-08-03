import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionCard extends StatefulWidget {
  final String appName;
  const AppVersionCard({super.key, required this.appName});

  @override
  State<AppVersionCard> createState() => _AppVersionCardState();
}

class _AppVersionCardState extends State<AppVersionCard> {
  PackageInfo? _packageInfo;

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  void _showVersionDialog() {
    if (_packageInfo == null) return;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text(widget.appName),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${'version_name'.tr}: ${_packageInfo!.version}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('${'build_number'.tr}: ${_packageInfo!.buildNumber}'),
            const SizedBox(height: 4),
            Text('${'package_name'.tr}: ${_packageInfo!.packageName}', style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('close_btn'.tr),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_packageInfo == null) return const SizedBox.shrink();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(Icons.info_outline, color: Theme.of(context).colorScheme.primary),
        ),
        title: Text('app_version'.tr, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('${'current_version'.tr}: ${_packageInfo!.version}'),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: _showVersionDialog,
      ),
    );
  }
}
