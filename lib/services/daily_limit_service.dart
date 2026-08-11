import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyLimitService extends GetxService {
  late SharedPreferences _prefs;
  
  static const int maxFreeDraws = 3;
  
  // Observable variables
  final RxInt fortuneDrawsLeft = maxFreeDraws.obs;
  final RxInt tarotDrawsLeft = maxFreeDraws.obs;
  
  Future<DailyLimitService> init() async {
    _prefs = await SharedPreferences.getInstance();
    _checkAndResetDailyLimits();
    return this;
  }
  
  void _checkAndResetDailyLimits() {
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
      fortuneDrawsLeft.value = _prefs.getInt('fortune_draws_left') ?? maxFreeDraws;
      tarotDrawsLeft.value = _prefs.getInt('tarot_draws_left') ?? maxFreeDraws;
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
