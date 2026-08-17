import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:monetization_module/monetization_module.dart';
import '../models/fortune_models.dart';
import '../ui/glass_widgets.dart';
import 'package:contact_module/contact_module.dart';
import '../services/daily_limit_service.dart';
import 'package:screenshot/screenshot.dart';
import '../services/share_service.dart';
import '../core/services/audio_service.dart';

class TarotScreen extends StatefulWidget {
  const TarotScreen({super.key});

  @override
  State<TarotScreen> createState() => _TarotScreenState();
}

class _TarotScreenState extends State<TarotScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isFlipped = false;
  TarotCard? _drawnCard;
  final DailyLimitService _limitService = Get.find<DailyLimitService>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _loadTarotCard();
  }

  Future<void> _loadTarotCard() async {
    final String response = await rootBundle.loadString('assets/data/tarot.json');
    final List<dynamic> data = json.decode(response);
    final cards = data.map((e) => TarotCard.fromJson(e)).toList();
    setState(() {
      _drawnCard = cards[Random().nextInt(cards.length)];
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _performFlipCard() {
    AudioService().playSfx('sfx_card_flip.wav');
    setState(() {
      _isFlipped = true;
    });
    _controller.forward().then((_) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        Get.off(() => TarotResultScreen(card: _drawnCard!));
      });
    });
  }

  void _flipCard() {
    if (_isFlipped || _drawnCard == null) return;
    
    if (_limitService.canDrawTarotForFree) {
      _limitService.consumeTarotDraw();
      _performFlipCard();
    } else {
      AdManager.showRewardedAd(
        showPrompt: true, // 광고 시청 의사를 묻는 다이얼로그 표시
        customTitle: 'free_chances_empty_title'.tr,
        customMessage: 'free_chances_empty_tarot'.tr,
        onUserEarnedReward: (reward) {
          _performFlipCard();
        },
        onAdDismissed: () {}
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('tarot_screen_title'.tr, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              final int left = _limitService.tarotDrawsLeft.value;
              return Text(
                'free_chances_left'.trParams({'left': left.toString()}),
                style: const TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold),
              );
            }),
            const SizedBox(height: 30),
            Text(
              'tarot_instruction'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, height: 1.5),
            ),
            const SizedBox(height: 60),
            GestureDetector(
              onTap: _flipCard,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  final angle = _animation.value * pi;
                  final isBackVisible = angle < pi / 2;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateY(angle),
                    child: isBackVisible ? _buildCardBack() : _buildCardFront(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardBack() {
    return Container(
      width: 220,
      height: 330, // 2:3 ratio
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.4), blurRadius: 30, spreadRadius: 5)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset('assets/images/tarot_back.jpg', fit: BoxFit.cover),
      ),
    );
  }

  String _getCardImagePath(int id) {
    final Map<int, String> imageMap = {
      0: 'assets/images/tarot_0_fool.jpg',
      1: 'assets/images/tarot_1_magician.jpg',
      2: 'assets/images/tarot_2_high_priestess.jpg',
      3: 'assets/images/tarot_3_empress.jpg',
      4: 'assets/images/tarot_4_emperor.jpg',
      5: 'assets/images/tarot_5_hierophant.jpg',
      6: 'assets/images/tarot_6_lovers.jpg',
      7: 'assets/images/tarot_7_chariot.jpg',
      8: 'assets/images/tarot_8_strength.jpg',
      9: 'assets/images/tarot_9_hermit.jpg',
      10: 'assets/images/tarot_10_wheel.jpg',
      11: 'assets/images/tarot_11_justice.jpg',
      12: 'assets/images/tarot_12_hanged_man.jpg',
      13: 'assets/images/tarot_13_death.jpg',
      14: 'assets/images/tarot_14_temperance.jpg',
      15: 'assets/images/tarot_15_devil.jpg',
      16: 'assets/images/tarot_16_tower.jpg',
      17: 'assets/images/tarot_17_star.jpg',
      18: 'assets/images/tarot_18_moon.jpg',
      19: 'assets/images/tarot_19_sun.jpg',
      20: 'assets/images/tarot_20_judgement.jpg',
      21: 'assets/images/tarot_21_world.jpg',
    };
    return imageMap[id] ?? 'assets/images/tarot_back.jpg';
  }

  Widget _buildCardFront() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(pi),
      child: Container(
        width: 220,
        height: 330,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 30, spreadRadius: 5)
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                _drawnCard != null ? _getCardImagePath(_drawnCard!.id) : 'assets/images/tarot_back.jpg',
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TarotResultScreen extends StatefulWidget {
  final TarotCard card;
  const TarotResultScreen({super.key, required this.card});

  @override
  State<TarotResultScreen> createState() => _TarotResultScreenState();
}

class _TarotResultScreenState extends State<TarotResultScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();
  bool _isPremiumUnlocked = false;

  void _unlockPremium() {
    AdManager.showRewardedAd(
      showPrompt: false,
      onUserEarnedReward: (reward) {
        setState(() {
          _isPremiumUnlocked = true;
        });
      },
    );
  }
  
  String _getCardImagePath(int id) {
    final Map<int, String> imageMap = {
      0: 'assets/images/tarot_0_fool.jpg',
      1: 'assets/images/tarot_1_magician.jpg',
      2: 'assets/images/tarot_2_high_priestess.jpg',
      3: 'assets/images/tarot_3_empress.jpg',
      4: 'assets/images/tarot_4_emperor.jpg',
      5: 'assets/images/tarot_5_hierophant.jpg',
      6: 'assets/images/tarot_6_lovers.jpg',
      7: 'assets/images/tarot_7_chariot.jpg',
      8: 'assets/images/tarot_8_strength.jpg',
      9: 'assets/images/tarot_9_hermit.jpg',
      10: 'assets/images/tarot_10_wheel.jpg',
      11: 'assets/images/tarot_11_justice.jpg',
      12: 'assets/images/tarot_12_hanged_man.jpg',
      13: 'assets/images/tarot_13_death.jpg',
      14: 'assets/images/tarot_14_temperance.jpg',
      15: 'assets/images/tarot_15_devil.jpg',
      16: 'assets/images/tarot_16_tower.jpg',
      17: 'assets/images/tarot_17_star.jpg',
      18: 'assets/images/tarot_18_moon.jpg',
      19: 'assets/images/tarot_19_sun.jpg',
      20: 'assets/images/tarot_20_judgement.jpg',
      21: 'assets/images/tarot_21_world.jpg',
    };
    return imageMap[id] ?? 'assets/images/tarot_back.jpg';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('tarot_result_title'.tr, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            // 공유용 포토카드 컨테이너
            Screenshot(
              controller: _screenshotController,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1E1E3F), Color(0xFF0F172A)],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.8), width: 2),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFFD4AF37).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 5)),
                  ],
                ),
              child: Column(
                children: [
                  // 카드 이미지 영역
                  Container(
                    width: 160,
                    height: 240,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 15, offset: const Offset(0, 10)),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            _getCardImagePath(widget.card.id),
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  
                  // 카드 타이틀
                  Text(
                    widget.card.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFD4AF37), letterSpacing: 1.5),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Divider(color: Colors.white24),
                  ),
                  
                  // 기본 의미
                  Text(
                    'tarot_basic_meaning'.tr,
                    style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.card.basicMeaning,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // 프리미엄 결과
                  if (_isPremiumUnlocked)
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.favorite, color: Colors.pinkAccent, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'tarot_love_luck'.tr,
                                style: const TextStyle(color: Colors.pinkAccent, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.card.premiumLove,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.6),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'tarot_wealth_luck'.tr,
                                style: const TextStyle(color: Colors.amber, fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.card.premiumWealth,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.6),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.lock_outline, color: Color(0xFFD4AF37), size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'tarot_premium_teaser'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
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
                label: Text('ad_premium_tarot'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
            GlassButton(
              text: 'share_tarot_sns'.tr,
              icon: Icons.share,
              onPressed: () {
                ShareService.shareScreenshot(_screenshotController, 'share_tarot_hashtag'.tr);
              },
            ),
          ],
        ),
      ),
    );
  }
}
