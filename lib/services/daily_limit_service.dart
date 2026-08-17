import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class DailyLimitService extends GetxService with WidgetsBindingObserver {
  late SharedPreferences _prefs;
  
  static const int maxFreeDraws = 1;
  
  // Observable variables
  final RxInt fortuneDrawsLeft = maxFreeDraws.obs;
  final RxInt tarotDrawsLeft = maxFreeDraws.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkAndResetDailyLimits();
    }
  }
  
  Future<DailyLimitService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _checkAndResetDailyLimits();
    return this;
  }
  
  void _checkAndResetDailyLimits() {
    // 글로벌 유저를 위해 기기의 로컬 시간을 기준으로 자정을 판별합니다.
    final String today = DateTime.now().toIso8601String().split('T').first;
    final String? lastSavedDate = _prefs.getString('last_saved_date');
    
    if (lastSavedDate != today) {
      // It's a new day, reset limits
      _prefs.setString('last_saved_date', today);
      _prefs.setInt('fortune_draws_left', maxFreeDraws);
      _prefs.setInt('tarot_draws_left', maxFreeDraws);
      fortuneDrawsLeft.value = maxFreeDraws;
      tarotDrawsLeft.value = maxFreeDraws;
    } else {
      // Same day, load existing values
      int savedFortune = _prefs.getInt('fortune_draws_left') ?? maxFreeDraws;
      int savedTarot = _prefs.getInt('tarot_draws_left') ?? maxFreeDraws;
      
      // 업데이트 등으로 최대 횟수가 줄어들었을 경우를 대비해 상한선 적용
      if (savedFortune > maxFreeDraws) {
        savedFortune = maxFreeDraws;
        _prefs.setInt('fortune_draws_left', savedFortune);
      }
      if (savedTarot > maxFreeDraws) {
        savedTarot = maxFreeDraws;
        _prefs.setInt('tarot_draws_left', savedTarot);
      }
      
      fortuneDrawsLeft.value = savedFortune;
      tarotDrawsLeft.value = savedTarot;
    }
  }
  
  // Call this when user opens a fortune cookie
  void consumeFortuneDraw() {
    if (fortuneDrawsLeft.value > 0) {
      fortuneDrawsLeft.value--;
      _prefs.setInt('fortune_draws_left', fortuneDrawsLeft.value);
    }
  }
  
  // Call this when user draws a tarot card
  void consumeTarotDraw() {
    if (tarotDrawsLeft.value > 0) {
      tarotDrawsLeft.value--;
      _prefs.setInt('tarot_draws_left', tarotDrawsLeft.value);
    }
  }
  
  bool get canDrawFortuneForFree => fortuneDrawsLeft.value > 0;
  bool get canDrawTarotForFree => tarotDrawsLeft.value > 0;
}
