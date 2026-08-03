import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';

Future<void> sendEmail(BuildContext context, String email) async {
  final Uri emailLaunchUri = Uri(
    scheme: 'mailto',
    path: email,
    query: _encodeQueryParameters(<String, String>{
      'subject': '앱 문의사항',
      'body': '여기에 내용을 작성해주세요.',
    }),
  );

  try {
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      if (context.mounted) _showError(context, '이메일 앱을 열 수 없습니다.');
    }
  } catch (e) {
    if (context.mounted) _showError(context, '이메일 앱 열기 실패: ${e.toString()}');
  }
}

Future<void> openDeveloperPage(BuildContext context, String url) async {
  final Uri uri = Uri.parse(url);
  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) _showError(context, '페이지를 열 수 없습니다.');
    }
  } catch (e) {
    if (context.mounted) _showError(context, '개발자 페이지 열기 실패: ${e.toString()}');
  }
}

Future<void> rateApp(BuildContext context, String packageName) async {
  // 간단하게 플레이스토어 링크로 이동
  final url = "https://play.google.com/store/apps/details?id=$packageName";
  await openDeveloperPage(context, url);
}

Future<void> shareApp(BuildContext context, String packageName) async {
  final String shareText = "이 앱을 추천합니다! https://play.google.com/store/apps/details?id=$packageName";
  await Share.share(shareText);
}

void _showError(BuildContext context, String message) {
  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

String? _encodeQueryParameters(Map<String, String> params) {
  return params.entries
      .map((MapEntry<String, String> e) =>
          '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
      .join('&');
}
