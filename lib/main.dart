import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ui_module/ui_module.dart';
import 'package:contact_module/contact_module.dart';
import 'package:settings_module/settings_module.dart';
import 'package:notice_module/notice_module.dart';
import 'package:monetization_module/monetization_module.dart';
import 'core/config/app_config.dart';
import 'core/translations/app_translations.dart';
import 'package:auth_module/auth_module.dart';
import 'root_screen.dart';

void main() async {
// ... existing code down to _buildSettingsTab ...

  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.load();
  AdManager.init(); // 애드몹 초기화 (await 제거하여 스플래시 멈춤 방지)
  runApp(const AppFactory());
}

class AppFactory extends StatelessWidget {
  const AppFactory({super.key});

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
      themeMode: ThemeMode.system, // 시스템 설정에 따라 다크모드 적용
      translations: AppTranslations(),
      locale: Get.deviceLocale, // 기기 언어 설정 따라감
      fallbackLocale: const Locale('en', 'US'), // 기본 언어는 영어
      home: const RootScreen(), // RootScreen이 온보딩, 권한, 로그인 통제
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

    // 3. 좌측 슬라이드 메뉴(Drawer) 준비
    final Widget appDrawer = Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Text('common_menu'.tr, style: AppTypography.heading2.copyWith(color: Colors.white)),
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text('notice'.tr),
            onTap: () {
              Get.back(); // 메뉴 닫기
              Get.snackbar('menu_clicked'.tr, 'go_to_notice'.tr);
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
          Text('home_canvas'.tr, style: AppTypography.body),
          const SizedBox(height: 20),
          AppButton(
            text: 'home_special_btn'.tr,
            onPressed: () => Get.snackbar('alert'.tr, 'center_screen_free'.tr),
          ),
          
          if (AppConfig.features['showAds'] == true) ...[
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    AdManager.showInterstitialAd(
                      onAdDismissed: () => Get.snackbar('알림', '전면 광고가 종료되었습니다.'),
                    );
                  },
                  child: const Text('전면 광고 보기'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    AdManager.showRewardedAd(
                      onUserEarnedReward: (reward) {
                        Get.snackbar('보상 획득!', '${reward.amount} ${reward.type} 지급 완료!');
                      },
                      onAdDismissed: () => debugPrint('보상형 광고 창 닫힘'),
                    );
                  },
                  child: const Text('보상형 광고 보기'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const AdBannerWidget(), // 애드몹 배너 광고 부착
            const SizedBox(height: 20),
            const AdNativeWidget(), // 애드몹 네이티브 광고 부착
          ]
        ],
      ),
    );
  }

  // 두 번째 탭 (설정 및 정보)
  Widget _buildSettingsTab(BuildContext context) {
    final devInfo = DeveloperDataManager.getDeveloperInfo();
    const String dummyPackageName = "com.hjoon.app"; // 앱 패키지명

    // AppConfig 값 읽어오기
    final bool showDarkModeToggle = AppConfig.features['showDarkModeToggle'] ?? true;
    final bool showAppVersion = AppConfig.features['showAppVersion'] ?? true;
    final bool showLegalLinks = AppConfig.features['showLegalLinks'] ?? true;
    final bool showLanguageSelector = AppConfig.features['showLanguageSelector'] ?? true;
    final bool showLicense = AppConfig.features['showLicense'] ?? true;
    final bool showPushNotifications = AppConfig.features['showPushNotifications'] ?? true;
    final bool showContactOptions = AppConfig.features['showContactOptions'] ?? true;
    final bool showAccountManagement = AppConfig.features['showAccountManagement'] ?? true;
    
    final String termsUrl = AppConfig.legalLinks['termsOfService'] ?? '';
    final String privacyUrl = AppConfig.legalLinks['privacyPolicy'] ?? '';
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        Text('settings'.tr, style: AppTypography.heading1),
        const SizedBox(height: 20),
        
        Text('app_features'.tr, style: AppTypography.heading2),
        const SizedBox(height: 12),
        
        if (showLanguageSelector)
          const LanguageSelectorCard(),
          
        if (showLanguageSelector)
          const SizedBox(height: 12),
        
        if (showDarkModeToggle)
          SettingsToggleCard(
            title: isDark ? 'dark_mode'.tr : 'light_mode'.tr,
            subtitle: isDark ? 'dark_mode_desc'.tr : 'light_mode_desc'.tr,
            icon: isDark ? Icons.dark_mode : Icons.light_mode,
            value: isDark,
            onChanged: (val) {
              Get.changeThemeMode(val ? ThemeMode.dark : ThemeMode.light);
            },
          ),
          
        if (showPushNotifications) ...[
          const SizedBox(height: 12),
          SettingsToggleCard(
            title: 'push_notification'.tr,
            subtitle: 'push_notification_desc'.tr,
            icon: Icons.notifications,
            value: AppConfig.features['enableNotifications'] ?? false,
            onChanged: (val) {
              Get.snackbar('notification_changed'.tr, '');
            },
          ),
        ],
        
        if (showContactOptions) ...[
          const SizedBox(height: 40),
          Text('support_info'.tr, style: AppTypography.heading2),
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
          Text('app_info'.tr, style: AppTypography.heading2),
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
              applicationVersion: '1.0.0', // 실제로는 package_info_plus에서 가져올 수 있음
            ),
            
          if (showLicense && showAppVersion)
            const SizedBox(height: 12),
            
          if (showAppVersion)
            AppVersionCard(appName: AppConfig.appName),
        ],
        
        if (showAccountManagement) ...[
          const SizedBox(height: 40),
          const Text('계정 관리', style: AppTypography.heading2),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.black87,
            ),
            onPressed: () async {
              Get.defaultDialog(
                title: '로그아웃',
                middleText: '정말 로그아웃 하시겠습니까?',
                textConfirm: '로그아웃',
                textCancel: '취소',
                confirmTextColor: Colors.white,
                onConfirm: () async {
                  Get.back();
                  Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
                  await AuthManager().logout();
                  Get.back();
                  Get.offAll(() => const RootScreen()); // 앱 초기화면으로 강제 이동
                },
              );
            },
            child: const Text('로그아웃'),
          ),
          const SizedBox(height: 12),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () {
              Get.defaultDialog(
                title: '회원 탈퇴',
                middleText: '정말 탈퇴하시겠습니까? 모든 데이터가 삭제되며 복구할 수 없습니다.',
                textConfirm: '탈퇴하기',
                textCancel: '취소',
                confirmTextColor: Colors.white,
                buttonColor: Colors.red,
                onConfirm: () async {
                  Get.back();
                  Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
                  await AuthManager().deleteAccount();
                  Get.back();
                  Get.offAll(() => const RootScreen()); // 앱 초기화면으로 강제 이동
                },
              );
            },
            child: const Text('회원 탈퇴 (Account Deletion)'),
          ),
        ],
        
        const SizedBox(height: 40), // 하단 여백
      ],
    );
  }
}
