import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_module/ui_module.dart';
import 'package:contact_module/contact_module.dart';
import 'package:settings_module/settings_module.dart';
import 'package:notice_module/notice_module.dart';
import 'package:monetization_module/monetization_module.dart';
import 'core/config/app_config.dart';
import 'core/translations/app_translations.dart';
import 'screens/home_screen.dart';
import 'root_screen.dart';
import 'screens/widgets/settings_features_card.dart';

import 'core/services/audio_service.dart';
import 'core/services/notification_service.dart';
import 'services/daily_limit_service.dart';

import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  AdManager.init(); // 애드몹 초기화 (await 제거하여 스플래시 멈춤 방지)
  
  // Initialize Services
  await AudioService().init();
  await NotificationService().init();
  
  // Load saved language
  final prefs = await SharedPreferences.getInstance();
  final String? savedLang = prefs.getString('language_code');
  final String? savedCountry = prefs.getString('country_code');
  
  Locale initialLocale;
  if (savedLang != null && savedCountry != null) {
    initialLocale = Locale(savedLang, savedCountry);
  } else {
    initialLocale = Get.deviceLocale ?? const Locale('en', 'US');
  }
  
  // Initialize DailyLimitService
  await Get.putAsync(() => DailyLimitService().init());
  
  runApp(AppFactory(initialLocale: initialLocale));
}

class AppFactory extends StatelessWidget {
  final Locale initialLocale;
  
  const AppFactory({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color(int.parse(AppConfig.theme['primaryColor']?.replaceAll('#', '0xFF') ?? '0xFF2196F3')),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Color(int.parse(AppConfig.theme['primaryColor']?.replaceAll('#', '0xFF') ?? '0xFF2196F3')),
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.dark, // 앱 전체 테마를 다크모드로 강제 고정
      translations: AppTranslations(),
      locale: initialLocale, // 저장된 언어 우선 적용
      fallbackLocale: const Locale('en', 'US'), // 기본 언어는 영어
      home: const MainScreen(), // RootScreen이 온보딩, 권한, 로그인 통제
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  
  @override
  void initState() {
    super.initState();
    // 공지사항 및 업데이트 체크
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (AppConfig.features['checkNotices'] == true) {
        NoticeManager.checkNotices(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. 공통 뼈대에 넣을 그림(실제 화면 탭들) 준비
    final List<Widget> appPages = [
      _buildHomeTab(context),
      _buildSettingsTab(context),
    ];

    // 2. 하단 탭 바 아이콘 준비
    final List<BottomNavigationBarItem> appNavItems = [
      BottomNavigationBarItem(icon: const Icon(Icons.home), label: 'tab_home'.tr),
      BottomNavigationBarItem(icon: const Icon(Icons.settings), label: 'tab_settings'.tr),
    ];


    // 4. ui_module의 AppScaffold 뼈대에 부품들을 주입(Injection)하여 화면 완성!
    return AppScaffold(
      title: AppConfig.appName,
      pages: appPages,
      navItems: appNavItems,
      drawer: null, // 햄버거 메뉴 제거
      showAppBar: false, // 상단 헤더 제거
      showBottomNav: true,
    );
  }

  // 첫 번째 탭 (홈)
  Widget _buildHomeTab(BuildContext context) {
    return const HomeScreen();
  }

  // 두 번째 탭 (설정 및 정보)
  Widget _buildSettingsTab(BuildContext context) {
    final devInfo = DeveloperDataManager.getDeveloperInfo();
    const String dummyPackageName = "com.hjoon.fortune"; // 실제 앱 패키지명

    // AppConfig 값 읽어오기
    final bool showAppVersion = AppConfig.features['showAppVersion'] ?? true;
    final bool showLegalLinks = AppConfig.features['showLegalLinks'] ?? true;
    final bool showLanguageSelector = AppConfig.features['showLanguageSelector'] ?? true;
    final bool showLicense = AppConfig.features['showLicense'] ?? true;
    final bool showContactOptions = AppConfig.features['showContactOptions'] ?? true;

    
    final String termsUrl = AppConfig.legalLinks['termsOfService'] ?? '';
    final String privacyUrl = AppConfig.legalLinks['privacyPolicy'] ?? '';
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: const Color(0xFF0F172A),
      child: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF8B5CF6).withOpacity(0.15),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.2), blurRadius: 100)
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            right: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF4C1D95).withOpacity(0.2),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF4C1D95).withOpacity(0.2), blurRadius: 100)
                ],
              ),
            ),
          ),
          SafeArea(
            child: Theme(
              data: ThemeData.dark().copyWith(
                cardColor: Colors.white.withOpacity(0.05),
                colorScheme: ThemeData.dark().colorScheme.copyWith(
                  primaryContainer: Colors.white.withOpacity(0.2), // 아이콘 배경 밝기 통일
                  secondaryContainer: Colors.white.withOpacity(0.2), // 언어 아이콘 배경 밝기 통일
                  primary: Colors.white,
                  secondary: Colors.white,
                ),
                textTheme: ThemeData.dark().textTheme.apply(
                  bodyColor: Colors.white,
                  displayColor: Colors.white,
                ),
                iconTheme: const IconThemeData(color: Colors.white),
                listTileTheme: const ListTileThemeData(
                  iconColor: Colors.white,
                  textColor: Colors.white,
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  Text('settings'.tr, style: AppTypography.heading1.copyWith(color: Colors.white)),
                  const SizedBox(height: 20),
                  
                  Text('app_features'.tr, style: AppTypography.heading2.copyWith(color: Colors.white)),
                  const SizedBox(height: 12),
                  
                  if (showLanguageSelector) ...[
                    const LanguageSelectorCard(),
                    const SizedBox(height: 12),
                  ],
                  const SettingsFeaturesCard(),
                  
                  if (showContactOptions) ...[
                    const SizedBox(height: 40),
                    Text('support_info'.tr, style: AppTypography.heading2.copyWith(color: Colors.white)),
                    const SizedBox(height: 16),
                    DeveloperProfileCard(info: devInfo),
                    const SizedBox(height: 16),
                    ContactOptionCard(
                      icon: Icons.email,
                      title: 'email_inquiry'.tr,
                      subtitle: devInfo.email,
                      onTap: () => sendEmail(context, devInfo.email),
                    ),
                    const SizedBox(height: 12),
                    ContactOptionCard(
                      icon: Icons.shop,
                      title: 'dev_page'.tr,
                      subtitle: 'dev_page_desc'.tr,
                      onTap: () => openDeveloperPage(context, devInfo.playStoreUrl),
                    ),
                    const SizedBox(height: 12),
                    ContactOptionCard(
                      icon: Icons.star,
                      title: 'rate_app'.tr,
                      subtitle: 'rate_app_desc'.tr,
                      onTap: () => rateApp(context, dummyPackageName),
                    ),
                    const SizedBox(height: 12),
                    ContactOptionCard(
                      icon: Icons.share,
                      title: 'share_app'.tr,
                      subtitle: 'share_app_desc'.tr,
                      onTap: () => shareApp(context, dummyPackageName),
                    ),
                  ],
                  
                  if (showLegalLinks || showAppVersion || showLicense) ...[
                    const SizedBox(height: 40),
                    Text('app_info'.tr, style: AppTypography.heading2.copyWith(color: Colors.white)),
                    const SizedBox(height: 16),
                    
                    if (showLegalLinks)
                      LegalLinksCard(
                        termsUrl: termsUrl,
                        privacyUrl: privacyUrl,
                        appName: AppConfig.appName,
                      ),
                      
                    if (showLegalLinks && (showAppVersion || showLicense))
                      const SizedBox(height: 12),
                      
                    if (showLicense)
                      LicenseCard(
                        appName: AppConfig.appName,
                      ),
                      
                    if (showLicense && showAppVersion)
                      const SizedBox(height: 12),
                      
                    if (showAppVersion)
                      AppVersionCard(appName: AppConfig.appName),
                  ],
                  
                  const SizedBox(height: 40), // 하단 여백
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
