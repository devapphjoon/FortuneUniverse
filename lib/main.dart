import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. 설정 파일(Config) 로드
  await AppConfig.load();
  
  // 2. (추후) Firebase 초기화
  // await Firebase.initializeApp();

  runApp(const AppFactory());
}

class AppFactory extends StatelessWidget {
  const AppFactory({super.key});

  @override
  Widget build(BuildContext context) {
    // Config에서 정의한 테마 색상 파싱
    String hexColor = AppConfig.theme['primaryColor'] ?? '#2196F3';
    hexColor = hexColor.replaceAll('#', '0xff');
    Color primaryColor = Color(int.parse(hexColor));
    
    bool isDarkMode = AppConfig.theme['isDarkMode'] ?? false;

    return GetMaterialApp(
      title: AppConfig.appName,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          brightness: Brightness.dark,
        ),
      ),
      home: const MainPlaceholder(),
    );
  }
}

class MainPlaceholder extends StatelessWidget {
  const MainPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppConfig.appName),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '앱 공장 조립 완료!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text('API 주소: ${AppConfig.apiBaseUrl}'),
            Text('알림 기능 활성화: ${AppConfig.features['enableNotifications']}'),
            Text('결제 기능 활성화: ${AppConfig.features['enablePayments']}'),
          ],
        ),
      ),
    );
  }
}
