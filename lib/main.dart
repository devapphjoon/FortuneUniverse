import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_module/ui_module.dart';
import 'core/config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  runApp(const AppFactory());
}

class AppFactory extends StatelessWidget {
  const AppFactory({super.key});

  @override
  Widget build(BuildContext context) {
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
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. 공통 뼈대에 넣을 그림(실제 화면 탭들) 준비
    final List<Widget> appPages = [
      _buildHomeTab(context),
      _buildSettingsTab(context),
    ];

    // 2. 하단 탭 바 아이콘 준비
    final List<BottomNavigationBarItem> appNavItems = const [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
    ];

    // 3. 좌측 슬라이드 메뉴(Drawer) 준비
    final Widget appDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Text('공통 메뉴', style: AppTypography.heading2.copyWith(color: Colors.white)),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('공지사항'),
            onTap: () {
              Get.back(); // 메뉴 닫기
              Get.snackbar('메뉴 클릭', '공지사항 화면으로 이동합니다.');
            },
          ),
        ],
      ),
    );

    // 4. ui_module의 AppScaffold 뼈대에 부품들을 주입(Injection)하여 화면 완성!
    return AppScaffold(
      title: AppConfig.appName,
      pages: appPages,
      navItems: appNavItems,
      drawer: appDrawer, // 만약 메뉴가 필요없는 앱이라면 이 줄만 지우거나 null을 주면 메뉴가 사라집니다.
      showBottomNav: true,
    );
  }

  // 첫 번째 탭 (홈)
  Widget _buildHomeTab(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('이곳이 캔버스(앱마다 달라지는 공간)입니다!', style: AppTypography.body),
          const SizedBox(height: 20),
          AppButton(
            text: '홈 전용 특수 버튼',
            onPressed: () => Get.snackbar('알림', '가운데 화면은 자유롭게 꾸밉니다!'),
          )
        ],
      ),
    );
  }

  // 두 번째 탭 (설정)
  Widget _buildSettingsTab(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('설정 탭', style: AppTypography.heading1),
          const SizedBox(height: 20),
          Text('알림: ${AppConfig.features['enableNotifications']}', style: AppTypography.body),
          Text('결제: ${AppConfig.features['enablePayments']}', style: AppTypography.body),
        ],
      ),
    );
  }
}
