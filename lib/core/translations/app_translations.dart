import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'ko_KR': {
          'tab_home': '홈',
          'tab_center': '가운데 메뉴',
          'tab_settings': '설정',
          
          'settings': '설정',
          'app_features': '앱 기능',
          'dark_mode': '다크 모드',
          'dark_mode_desc': '어두운 테마를 사용합니다',
          'light_mode': '라이트 모드',
          'light_mode_desc': '밝은 테마를 사용합니다',
          'push_notification': '푸시 알림 수신',
          'push_notification_desc': '새로운 소식을 받아봅니다',
          
          'support_info': '고객 지원 및 정보',
          'email_inquiry': '이메일 문의',
          'dev_page': 'Play Store 개발자 페이지',
          'dev_page_desc': '다른 앱들도 확인해보세요',
          'rate_app': '앱 평가하기',
          'rate_app_desc': '리뷰는 큰 힘이 됩니다',
          'share_app': '앱 공유하기',
          'share_app_desc': '주변에 이 앱을 추천해주세요',
          
          'app_info': '앱 정보',
          'terms': '이용약관',
          'privacy': '개인정보처리방침',
          'app_version': '앱 버전 정보',
          'language': '언어 설정 (Language)',
          'open_source_license': '오픈소스 라이선스',
          'notification_changed': '푸시 알림 수신 동의가 변경되었습니다.',
          
          'version_name': '버전 이름',
          'build_number': '빌드 번호',
          'package_name': '패키지명',
          'current_version': '현재 버전',
          'close_btn': '닫기',
          
          'cannot_open_page': '페이지를 열 수 없습니다.',
          'error_occurred': '에러 발생',
          
          'dev_intro': '안녕하세요! 저는 Flutter 개발자 Hjoon입니다.',
          'dev_role': 'Flutter 개발자',
          
          'common_menu': '공통 메뉴',
          'notice': '공지사항',
          'menu_clicked': '메뉴 클릭',
          'go_to_notice': '공지사항 화면으로 이동합니다.',
          'home_canvas': '이곳이 캔버스(앱마다 달라지는 공간)입니다!',
          'home_special_btn': '홈 전용 특수 버튼',
          'alert': '알림',
          'center_screen_free': '가운데 화면은 자유롭게 꾸밉니다!',
          
          'notice_update_title': '새로운 업데이트 알림',
          'notice_update_content': '서버 점검 및 최신 버전 업데이트가 있습니다.',
          'force_update_title': '필수 업데이트',
          'force_update_content': '원활한 서비스 이용을 위해 스토어에서 최신 버전으로 업데이트 해주세요.',
          'update_btn': '업데이트 하러가기',
          
          // Network Error
          'network_error_unknown': '알 수 없는 오류가 발생했습니다.',
          'network_error_timeout': '서버 응답 시간이 초과되었습니다.',
          'network_error_404': '요청하신 페이지를 찾을 수 없습니다.',
          'network_error_500': '서버 내부에 오류가 발생했습니다.',
          'network_error_server': '서버 통신 오류',
          'network_error_connection': '인터넷 연결을 확인해주세요.',
          
          // Auth
          'login_with_kakao': '카카오로 로그인',
          'login_with_naver': '네이버로 로그인',
          'login_with_google': '구글로 로그인',
          'login_with_apple': 'Apple로 로그인',
          
          // Permission
          'permission_title': '앱 접근 권한 안내',
          'permission_desc': '편리한 서비스 이용을 위해 다음 권한이 필요합니다.',
          'permission_camera': '카메라 (선택)',
          'permission_camera_desc': '사진 촬영 및 프로필 등록을 위해 필요합니다.',
          'permission_photo': '사진/앨범 (선택)',
          'permission_photo_desc': '저장된 사진을 불러오기 위해 필요합니다.',
          'permission_allow_btn': '확인하고 시작하기',
          'permission_denied': '권한이 거부되었습니다. 설정에서 변경할 수 있습니다.',
          
          // Onboarding
          'onboarding_title_1': '빠르고 완벽한 시작',
          'onboarding_desc_1': '앱 공장에서 찍어낸 아름다운 앱을 경험해 보세요.',
          'onboarding_title_2': '강력한 보안 및 안정성',
          'onboarding_desc_2': '모든 데이터를 안전하게 보호하며 에러 없이 동작합니다.',
          'onboarding_title_3': '글로벌 스탠다드 대응',
          'onboarding_desc_3': '다국어부터 수익화까지 완벽하게 준비된 템플릿입니다.',
          'onboarding_next_btn': '다음',
          'onboarding_start_btn': '시작하기',
        },
        'en_US': {
          'tab_home': 'Home',
          'tab_center': 'Center',
          'tab_settings': 'Settings',
          
          'settings': 'Settings',
          'app_features': 'App Features',
          'dark_mode': 'Dark Mode',
          'dark_mode_desc': 'Use dark theme',
          'light_mode': 'Light Mode',
          'light_mode_desc': 'Use bright theme',
          'push_notification': 'Push Notifications',
          'push_notification_desc': 'Receive new updates',
          
          'support_info': 'Support & Info',
          'email_inquiry': 'Email Inquiry',
          'dev_page': 'Play Store Developer Page',
          'dev_page_desc': 'Check out our other apps',
          'rate_app': 'Rate App',
          'rate_app_desc': 'Your review helps us a lot',
          'share_app': 'Share App',
          'share_app_desc': 'Recommend this app to friends',
          
          'app_info': 'App Info',
          'terms': 'Terms of Service',
          'privacy': 'Privacy Policy',
          'app_version': 'App Version',
          'language': 'Language Settings (언어 설정)',
          'open_source_license': 'Open Source Licenses',
          'notification_changed': 'Push notification settings changed.',
          
          'version_name': 'Version Name',
          'build_number': 'Build Number',
          'package_name': 'Package Name',
          'current_version': 'Current Version',
          'close_btn': 'Close',
          
          'cannot_open_page': 'Cannot open the page.',
          'error_occurred': 'An error occurred',
          
          'dev_intro': 'Hello! I am Flutter Developer Hjoon.',
          'dev_role': 'Flutter Developer',
          
          'common_menu': 'Common Menu',
          'notice': 'Notices',
          'menu_clicked': 'Menu Clicked',
          'go_to_notice': 'Moving to notices screen.',
          'home_canvas': 'This is the canvas (space that changes per app)!',
          'home_special_btn': 'Home Special Button',
          'alert': 'Alert',
          'center_screen_free': 'Center screen can be freely customized!',
          
          'notice_update_title': 'New Update Notice',
          'notice_update_content': 'Server maintenance and a new version update are available.',
          'force_update_title': 'Mandatory Update',
          'force_update_content': 'Please update to the latest version in the store for smooth service.',
          'update_btn': 'Go to Update',
          
          // Network Error
          'network_error_unknown': 'An unknown error occurred.',
          'network_error_timeout': 'Server response timed out.',
          'network_error_404': 'Page not found.',
          'network_error_500': 'Internal server error occurred.',
          'network_error_server': 'Server communication error',
          'network_error_connection': 'Please check your internet connection.',
          
          // Auth
          'login_with_kakao': 'Login with Kakao',
          'login_with_naver': 'Login with Naver',
          'login_with_google': 'Login with Google',
          'login_with_apple': 'Login with Apple',
          
          // Permission
          'permission_title': 'App Permission Guide',
          'permission_desc': 'The following permissions are required for better service.',
          'permission_camera': 'Camera (Optional)',
          'permission_camera_desc': 'Required to take photos and register profile.',
          'permission_photo': 'Photos/Albums (Optional)',
          'permission_photo_desc': 'Required to load saved photos.',
          'permission_allow_btn': 'Confirm and Start',
          'permission_denied': 'Permission denied. You can change this in settings.',
          
          // Onboarding
          'onboarding_title_1': 'Fast and Perfect Start',
          'onboarding_desc_1': 'Experience beautiful apps crafted from the App Factory.',
          'onboarding_title_2': 'Strong Security & Stability',
          'onboarding_desc_2': 'Safely protects your data and operates flawlessly.',
          'onboarding_title_3': 'Global Standard Ready',
          'onboarding_desc_3': 'Fully prepared template from I18n to monetization.',
          'onboarding_next_btn': 'Next',
          'onboarding_start_btn': 'Get Started',
        }
      };
}
