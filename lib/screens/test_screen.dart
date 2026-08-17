import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:monetization_module/monetization_module.dart';
import '../models/fortune_models.dart';
import '../ui/glass_widgets.dart';
import 'package:contact_module/contact_module.dart';
import 'package:screenshot/screenshot.dart';
import '../services/share_service.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String? _testTitle;
  String? _testDesc;
  List<TestQuestion> _questions = [];
  List<TestResult> _results = [];
  int _currentIndex = 0;
  final Map<String, int> _scores = {};

  @override
  void initState() {
    super.initState();
    _loadTestData();
  }

  Future<void> _loadTestData() async {
    final String response = await rootBundle.loadString('assets/data/test.json');
    final Map<String, dynamic> data = json.decode(response);
    
    setState(() {
      _testTitle = getLocalized(data['title']);
      _testDesc = getLocalized(data['description']);
      _questions = (data['questions'] as List).map((e) => TestQuestion.fromJson(e)).toList();
      _results = (data['results'] as List).map((e) => TestResult.fromJson(e)).toList();
    });
  }

  Future<void> _answerQuestion(String scoreType) async {
    _scores[scoreType] = (_scores[scoreType] ?? 0) + 1;
    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      // 분석 중인 느낌을 주기 위한 지연 효과
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(color: Color(0xFF8B5CF6)),
        ),
      );
      
      await Future.delayed(const Duration(milliseconds: 1500));
      
      // 결과 도출 (가장 많이 나온 점수)
      String topScoreType = _scores.entries.reduce((a, b) => a.value > b.value ? a : b).key;
      TestResult finalResult = _results.firstWhere((r) => r.id == topScoreType, orElse: () => _results.first);
      Get.off(() => TestResultScreen(result: finalResult));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFF0F172A),
        body: Center(child: CircularProgressIndicator(color: Color(0xFF8B5CF6))),
      );
    }

    final question = _questions[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(_testTitle ?? 'home_test_title'.tr, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
              LinearProgressIndicator(
                value: (_currentIndex + 1) / _questions.length,
                backgroundColor: Colors.white.withOpacity(0.2),
                color: const Color(0xFF8B5CF6),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 40),
              Text(
                'Q${_currentIndex + 1}.',
                style: const TextStyle(color: Color(0xFF8B5CF6), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                question.question,
                style: const TextStyle(color: Colors.white, fontSize: 22, height: 1.4),
              ),
              const SizedBox(height: 40),
              ...question.options.map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    onTap: () => _answerQuestion(option.scoreType),
                    child: Text(
                      option.text,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class TestResultScreen extends StatefulWidget {
  final TestResult result;
  const TestResultScreen({super.key, required this.result});

  @override
  State<TestResultScreen> createState() => _TestResultScreenState();
}

class _TestResultScreenState extends State<TestResultScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('test_result_title'.tr, style: const TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            // 공유용 포토카드 컨테이너 (인스타 스토리용)
            Screenshot(
              controller: _screenshotController,
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2E0854), Color(0xFF0F172A)], // 신비로운 오로라/보라색 그라데이션
                  ),
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(color: const Color(0xFF9D4EDD).withOpacity(0.5), width: 2),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF9D4EDD).withOpacity(0.3), blurRadius: 25, offset: const Offset(0, 10)),
                  ],
                ),
              child: Column(
                children: [
                  // 수호 동물 이미지 (추후 AI 이미지로 대체)
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.05),
                      border: Border.all(color: const Color(0xFF9D4EDD).withOpacity(0.5), width: 2),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF9D4EDD).withOpacity(0.2), blurRadius: 20, spreadRadius: 5),
                      ],
                      image: DecorationImage(
                        image: AssetImage(
                          widget.result.id == 'A' ? 'assets/images/spirit_panther.jpg' :
                          widget.result.id == 'B' ? 'assets/images/spirit_deer.jpg' :
                          widget.result.id == 'C' ? 'assets/images/spirit_eagle.jpg' :
                          'assets/images/spirit_cat.jpg'
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // 수호 동물 타이틀
                  Text(
                    widget.result.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: Divider(color: Colors.white24),
                  ),
                  
                  // 성향 분석
                  Text(
                    'test_analysis_title'.tr,
                    style: const TextStyle(color: Color(0xFFE0AAFF), fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.result.basicDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 17, height: 1.6, fontWeight: FontWeight.w500),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // 프리미엄 궁합
                  if (_isPremiumUnlocked)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE0AAFF).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.auto_awesome, color: Color(0xFFE0AAFF), size: 24),
                              const SizedBox(width: 8),
                              Text(
                                'test_match_title'.tr,
                                style: const TextStyle(color: Color(0xFFE0AAFF), fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.result.premiumMatch,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white, fontSize: 16, height: 1.6),
                          ),
                        ],
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE0AAFF).withOpacity(0.3)),
                      ),
                      child: Column(
                        children: [
                          const Icon(Icons.lock_outline, color: Color(0xFFE0AAFF), size: 32),
                          const SizedBox(height: 8),
                          Text(
                            'test_premium_teaser'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white70, fontSize: 15),
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
                label: Text('ad_premium_test'.tr, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9D4EDD),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 10,
                  shadowColor: const Color(0xFF9D4EDD).withOpacity(0.5),
                ),
              ),
            ],
            
            const SizedBox(height: 32),
            GlassButton(
              text: 'share_test_sns'.tr,
              icon: Icons.share,
              onPressed: () {
                ShareService.shareScreenshot(_screenshotController, 'share_test_hashtag'.tr);
              },
            ),
          ],
        ),
      ),
    );
  }
}
