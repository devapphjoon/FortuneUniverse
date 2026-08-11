import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdManager {
  static Future<void> init() async {
    await MobileAds.instance.initialize();
    // 앱 시작 시 전면광고를 백그라운드에서 미리 로드해둡니다.
    loadInterstitialAd();
  }

  // 안드로이드/iOS 구글 공식 테스트 배너 ID
  static String get bannerAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    }
    return '';
  }

  // 안드로이드/iOS 구글 공식 테스트 전면광고 ID
  static String get interstitialAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-3940256099942544/4411468910';
    }
    return '';
  }

  // 안드로이드/iOS 구글 공식 테스트 보상형광고 ID
  static String get rewardedAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-3940256099942544/5224354917';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-3940256099942544/1712485313';
    }
    return '';
  }

  // 안드로이드/iOS 구글 공식 테스트 네이티브광고 ID
  static String get nativeAdUnitId {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'ca-app-pub-3940256099942544/2247696110';
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return 'ca-app-pub-3940256099942544/3986624511';
    }
    return '';
  }

  static InterstitialAd? _preloadedInterstitialAd;
  static bool _isInterstitialAdLoading = false;

  // 전면 광고 미리 불러오기 (구글 정책: 화면 전환 시 딜레이 없이 즉시 표출하기 위함)
  static void loadInterstitialAd() {
    if (_preloadedInterstitialAd != null || _isInterstitialAdLoading) return;
    
    _isInterstitialAdLoading = true;
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _preloadedInterstitialAd = ad;
          _isInterstitialAdLoading = false;
        },
        onAdFailedToLoad: (LoadAdError error) {
          debugPrint('InterstitialAd failed to load: $error');
          _isInterstitialAdLoading = false;
        },
      ),
    );
  }

  // 전면 광고 즉시 호출 유틸리티 (미리 로드된 광고가 있으면 띄우고, 없으면 그냥 패스)
  static void showInterstitialAd({VoidCallback? onAdDismissed}) {
    if (_preloadedInterstitialAd == null) {
      debugPrint('Warning: Interstitial ad was not preloaded.');
      if (onAdDismissed != null) onAdDismissed();
      // 혹시 모르니 다음을 위해 미리 로드 시도
      loadInterstitialAd();
      return;
    }

    _preloadedInterstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        ad.dispose();
        _preloadedInterstitialAd = null;
        if (onAdDismissed != null) onAdDismissed();
        // 하나 썼으니 다음 광고를 미리 로드해둠
        loadInterstitialAd(); 
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        ad.dispose();
        _preloadedInterstitialAd = null;
        if (onAdDismissed != null) onAdDismissed();
        loadInterstitialAd();
      },
    );
    _preloadedInterstitialAd!.show();
    _preloadedInterstitialAd = null; // 중복 호출 방지
  }

  // 보상형 광고 즉시 호출 유틸리티 (구글 정책에 맞춘 시청 여부 확인 팝업 포함)
  static void showRewardedAd({
    required Function(RewardItem) onUserEarnedReward,
    VoidCallback? onAdDismissed,
    bool showPrompt = true, // 기본적으로 시청 의사 확인 팝업을 띄움
    String? customTitle,
    String? customMessage,
  }) {
    if (showPrompt) {
      Get.defaultDialog(
        title: customTitle ?? '광고 시청',
        middleText: customMessage ?? '동영상 광고를 시청하고 보상을 획득하시겠습니까?',
        textConfirm: '시청하기',
        textCancel: '취소',
        confirmTextColor: Colors.white,
        onConfirm: () {
          Get.back(); // 팝업 닫기
          _loadAndShowRewarded(onUserEarnedReward: onUserEarnedReward, onAdDismissed: onAdDismissed);
        },
      );
    } else {
      _loadAndShowRewarded(onUserEarnedReward: onUserEarnedReward, onAdDismissed: onAdDismissed);
    }
  }

  static void _loadAndShowRewarded({
    required Function(RewardItem) onUserEarnedReward,
    VoidCallback? onAdDismissed,
  }) {
    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false); // 로딩 표시
    RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          Get.back(); // 로딩 닫기
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (RewardedAd ad) {
              ad.dispose();
              if (onAdDismissed != null) onAdDismissed();
            },
            onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
              ad.dispose();
              if (onAdDismissed != null) onAdDismissed();
            },
          );
          ad.show(onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
            onUserEarnedReward(rewardItem);
          });
        },
        onAdFailedToLoad: (LoadAdError error) {
          Get.back(); // 로딩 닫기
          debugPrint('RewardedAd failed to load: $error');
          Get.snackbar('알림', '현재 시청 가능한 광고가 없습니다. 잠시 후 다시 시도해주세요.');
          if (onAdDismissed != null) onAdDismissed();
        },
      ),
    );
  }
}
