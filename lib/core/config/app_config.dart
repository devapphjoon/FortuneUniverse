import 'dart:convert';
import 'package:flutter/services.dart';

class AppConfig {
  static late Map<String, dynamic> _config;

  static Future<void> load() async {
    final configString = await rootBundle.loadString('assets/app_config.json');
    _config = jsonDecode(configString);
  }

  static String get appName => _config['appName'] ?? 'Unknown App';
  static String get apiBaseUrl => _config['apiBaseUrl'] ?? '';
  static Map<String, dynamic> get theme => _config['theme'] ?? {};
  static Map<String, dynamic> get features => _config['features'] ?? {};
}
