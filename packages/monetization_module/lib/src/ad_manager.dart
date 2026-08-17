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
      Get.dialog(
        Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E2E), // 신비로운 다크 테마 배경
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF9D4EDD).withOpacity(0.5), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF9D4EDD).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars_rounded, color: Color(0xFFE0AAFF), size: 56),
                const SizedBox(height: 20),
                Text(
                  customTitle ?? 'ad_watch_title'.tr,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  customMessage ?? 'ad_watch_desc'.tr,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('ad_watch_cancel'.tr, style: const TextStyle(color: Colors.white60, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _loadAndShowRewarded(onUserEarnedReward: onUserEarnedReward, onAdDismissed: onAdDismissed);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8B5CF6),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          elevation: 8,
                          shadowColor: const Color(0xFF8B5CF6).withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text('ad_watch_confirm'.tr, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
          Get.snackbar('alert'.tr, 'ad_no_ads_msg'.tr);
          if (onAdDismissed != null) onAdDismissed();
        },
      ),
    );
  }
}
