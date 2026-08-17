import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:monetization_module/monetization_module.dart';
import 'package:screenshot/screenshot.dart';
import '../models/fortune_models.dart';
import '../core/services/audio_service.dart';
import '../ui/glass_widgets.dart';
import '../services/daily_limit_service.dart';
import '../services/share_service.dart';

class FortuneCookieScreen extends StatefulWidget {
  const FortuneCookieScreen({super.key});

  @override
  State<FortuneCookieScreen> createState() => _FortuneCookieScreenState();
}

class _FortuneCookieScreenState extends State<FortuneCookieScreen> with TickerProviderStateMixin {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isOpened = false;
  bool _isPremiumUnlocked = false;
  bool _isBreaking = false;
  bool _isSplitting = false;
  bool _showFlash = false;
  FortuneCookie? _cookie;
  late AnimationController _idleController;
  late Animation<double> _idleAnimation;
  late AnimationController _breakController;
  late Animation<double> _shakeAnimation;
  late AnimationController _splitController;
  late Animation<double> _splitAnimation;
  final DailyLimitService _limitService = Get.find<DailyLimitService>();

  @override
  void initState() {
    super.initState();
    _idleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _idleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _idleController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _idleController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _idleController.forward();
        }
      });
    _idleController.forward();

    _breakController = AnimationController(
      duration: const Duration(milliseconds: 50),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(parent: _breakController, curve: Curves.linear),
    );

    _splitController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _splitAnimation = CurvedAnimation(parent: _splitController, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _idleController.dispose();
    _breakController.dispose();
    _splitController.dispose();
    super.dispose();
  }

  Future<void> _performOpenCookie() async {
    final String response = await rootBundle.loadString('assets/data/fortune.json');
    final List<dynamic> data = json.decode(response);
    final cookies = data.map((e) => FortuneCookie.fromJson(e)).toList();
    
    setState(() {
      _cookie = cookies[Random().nextInt(cookies.length)];
      _isBreaking = true;
    });

    AudioService().playSfx('sfx_cookie_crack.wav');

    _idleController.stop();
    _breakController.repeat(reverse: true);
    
    // 진동
    await Future.delayed(const Duration(milliseconds: 1500));
    
    _breakController.stop();
    AudioService().playSfx('sfx_pop.wav');
    
    setState(() {
      _isBreaking = false;
      _isSplitting = true;
    });
    
    // 쪼개지는 애니메이션 시작
    _splitController.forward();
    
    await Future.delayed(const Duration(milliseconds: 800));

    // 쪼개지는 도중에 섬광 발생
    setState(() {
      _showFlash = true;
    });
    
    await Future.delayed(const Duration(milliseconds: 400));
    
    // 번쩍이는 동안 결과 화면으로 변경
    setState(() {
      _isSplitting = false;
      _isOpened = true;
    });
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    // 섬광 사라짐
    setState(() {
      _showFlash = false;
    });
  }

  void _handleCookieTap() {
    if (_limitService.canDrawFortuneForFree) {
      _limitService.consumeFortuneDraw();
      _performOpenCookie();
    } else {
      AdManager.showRewardedAd(
        showPrompt: true, // 광고 시청 의사를 묻는 다이얼로그 표시
        customTitle: 'free_chances_empty_title'.tr,
        customMessage: 'free_chances_empty_fortune'.tr,
        onUserEarnedReward: (reward) {
          _performOpenCookie();
        },
        onAdDismissed: () {}
      );
    }
  }

  void _unlockPremium() {
    AdManager.showRewardedAd(
      showPrompt: false, // UI 레벨에서 이미 유도했으므로 바로 띄움
      onUserEarnedReward: (reward) {
        setState(() {
          _isPremiumUnlocked = true;
        });
      },
      onAdDismissed: () {
        // 광고 닫힘
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('fortune_screen_title'.tr, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Center(
            child: _isOpened ? _buildResult() : _buildUnopenedCookie(),
          ),
          
          // 폭발 효과 (화면 전체를 하얗게 덮는 섬광)
          IgnorePointer(
            child: AnimatedOpacity(
              opacity: _showFlash ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 150),
              child: Container(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnopenedCookie() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Obx(() {
          final int left = _limitService.fortuneDrawsLeft.value;
          return Text(
            'free_chances_left'.trParams({'left': left.toString()}),
            style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
          );
        }),
        const SizedBox(height: 30),
        
        // 흔들림 및 쪼개짐 애니메이션
        AnimatedBuilder(
          animation: Listenable.merge([_idleAnimation, _shakeAnimation, _splitAnimation]),
          builder: (context, child) {
            final double splitVal = _isSplitting ? _splitAnimation.value : 0.0;
            
            return GestureDetector(
              onTap: (_isBreaking || _isSplitting) ? null : _handleCookieTap,
              child: Transform.scale(
                scale: _idleAnimation.value,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Stack(
                    children: [
                      // 왼쪽 반쪽
                      Transform.translate(
                        offset: Offset((_isBreaking ? _shakeAnimation.value : 0) - (splitVal * 60), splitVal * 20),
                        child: Transform.rotate(
                          angle: -splitVal * 0.3, // 왼쪽으로 약간 기울어짐
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: _isBreaking ? Colors.red.withOpacity(0.5) : Colors.amber.withOpacity(0.2), 
                                  blurRadius: _isBreaking ? 60 : 40, 
                                  spreadRadius: _isBreaking ? 20 : 10
                                ),
                              ],
                            ),
                            child: ClipPath(
                              clipper: CookieClipper(isLeft: true),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/fortune_cookie_closed.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // 오른쪽 반쪽
                      Transform.translate(
                        offset: Offset((_isBreaking ? _shakeAnimation.value : 0) + (splitVal * 60), splitVal * 20),
                        child: Transform.rotate(
                          angle: splitVal * 0.3, // 오른쪽으로 약간 기울어짐
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipPath(
                              clipper: CookieClipper(isLeft: false),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/fortune_cookie_closed.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 40),
        Text(
          _isBreaking ? 'fortune_calling'.tr : (_isSplitting ? 'fortune_splitting'.tr : 'fortune_tap_desc'.tr),
          style: TextStyle(
            color: (_isBreaking || _isSplitting) ? Colors.amber : Colors.white70, 
            fontSize: (_isBreaking || _isSplitting) ? 20 : 16,
            fontWeight: (_isBreaking || _isSplitting) ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildResult() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          // 공유용 포토카드 영역 (이 컨테이너 자체를 캡처하면 예쁨)
          Screenshot(
            controller: _screenshotController,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFFFDFBF7), // 양피지 느낌의 밝은 배경
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 20, offset: const Offset(0, 10)),
                ],
                border: Border.all(color: const Color(0xFFD4AF37), width: 2), // 은은한 골드 테두리
              ),
            child: Column(
              children: [
                // 깨진 쿠키 이미지
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/fortune_cookie_cracked.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                
                // 운세 메시지
                Text(
                  'fortune_message_title'.tr,
                  style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 16),
                Text(
                  _cookie!.quote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF3E2723), 
                    fontSize: 22, 
                    height: 1.6, 
                    fontWeight: FontWeight.w600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.0),
                  child: Divider(color: Color(0xFFD4AF37), thickness: 1),
                ),
                
                // 프리미엄 상세 팁
                if (_isPremiumUnlocked)
                  Column(
                    children: [
                      Text(
                        'fortune_premium_title'.tr,
                        style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _cookie!.premiumDetail,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Color(0xFF5D4037), fontSize: 16, height: 1.6),
                      ),
                    ],
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.5)),
                    ),
                    child: Column(
                      children: [
                        const Icon(Icons.lock_outline, color: Color(0xFFD4AF37), size: 32),
                        const SizedBox(height: 8),
                        Text(
                          'fortune_premium_teaser'.tr,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Color(0xFF5D4037), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          ),
          
          if (!_isPremiumUnlocked) ...[
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _unlockPremium,
              icon: const Icon(Icons.play_circle_outline, color: Colors.white),
              label: Text('ad_premium_fortune'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B5CF6),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                elevation: 10,
                shadowColor: const Color(0xFF8B5CF6).withOpacity(0.5),
              ),
            ),
          ],
          
          const SizedBox(height: 32),
          // 공유 버튼
          GlassButton(
            text: 'share_fortune_sns'.tr,
            icon: Icons.share,
            onPressed: () {
              ShareService.shareScreenshot(_screenshotController, 'share_fortune_hashtag'.tr);
            },
          ),
        ],
      ),
    );
  }
}

class CookieClipper extends CustomClipper<Path> {
  final bool isLeft;
  CookieClipper({required this.isLeft});

  @override
  Path getClip(Size size) {
    Path path = Path();
    double w = size.width;
    double h = size.height;
    double mid = w / 2;

    // 지그재그 모양으로 쪼개지는 선 (쿠키의 거친 단면 표현)
    if (isLeft) {
      path.moveTo(0, 0);
      path.lineTo(mid, 0);
      path.lineTo(mid - 15, h * 0.15);
      path.lineTo(mid + 10, h * 0.35);
      path.lineTo(mid - 20, h * 0.55);
      path.lineTo(mid + 15, h * 0.75);
      path.lineTo(mid - 10, h * 0.9);
      path.lineTo(mid, h);
      path.lineTo(0, h);
      path.close();
    } else {
      path.moveTo(mid, 0);
      path.lineTo(w, 0);
      path.lineTo(w, h);
      path.lineTo(mid, h);
      path.lineTo(mid - 10, h * 0.9);
      path.lineTo(mid + 15, h * 0.75);
      path.lineTo(mid - 20, h * 0.55);
      path.lineTo(mid + 10, h * 0.35);
      path.lineTo(mid - 15, h * 0.15);
      path.lineTo(mid, 0);
      path.close();
    }
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
