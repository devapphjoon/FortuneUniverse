import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  late AudioPlayer _bgmPlayer;
  late AudioPlayer _sfxPlayer;
  
  bool _isBgmEnabled = true;
  bool _isSfxEnabled = true;
  
  bool get isBgmEnabled => _isBgmEnabled;
  bool get isSfxEnabled => _isSfxEnabled;

  Future<void> init() async {
    _bgmPlayer = AudioPlayer();
    _sfxPlayer = AudioPlayer();
    
    // 무한 루프 설정
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);

    final prefs = await SharedPreferences.getInstance();
    _isBgmEnabled = prefs.getBool('isBgmEnabled') ?? true;
    _isSfxEnabled = prefs.getBool('isSfxEnabled') ?? true;

    if (_isBgmEnabled) {
      playBgm();
    }
  }

  Future<void> setBgmEnabled(bool enabled) async {
    _isBgmEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isBgmEnabled', enabled);

    if (enabled) {
      playBgm();
    } else {
      stopBgm();
    }
  }

  Future<void> setSfxEnabled(bool enabled) async {
    _isSfxEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSfxEnabled', enabled);
  }

  Future<void> playBgm() async {
    if (!_isBgmEnabled) return;
    try {
      await _bgmPlayer.play(AssetSource('audio/bgm.wav'));
    } catch (e) {
      print("BGM Play Error: $e");
    }
  }

  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
  }

  Future<void> playSfx(String fileName) async {
    if (!_isSfxEnabled) return;
    try {
      await _sfxPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      print("SFX Play Error: $e");
    }
  }
}
