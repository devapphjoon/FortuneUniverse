import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isNotificationEnabled = false;

  bool get isNotificationEnabled => _isNotificationEnabled;

  Future<void> init() async {
    tz.initializeTimeZones();
    // 한국 시간대 설정 (필요에 따라 변경)
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    final prefs = await SharedPreferences.getInstance();
    _isNotificationEnabled = prefs.getBool('isNotificationEnabled') ?? false;

    if (_isNotificationEnabled) {
      await scheduleDailyNotification();
    }
  }

  Future<bool> requestPermissions() async {
    bool granted = false;
    final androidImplementation = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImplementation != null) {
      granted = await androidImplementation.requestNotificationsPermission() ?? false;
    }
    
    final iosImplementation = _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (iosImplementation != null) {
      granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ) ?? false;
    }
    return granted;
  }

  Future<void> setNotificationEnabled(bool enabled) async {
    if (enabled) {
      final granted = await requestPermissions();
      if (!granted) return; // 권한 거부 시 활성화 안 함
    }
    
    _isNotificationEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationEnabled', enabled);

    if (enabled) {
      await scheduleDailyNotification();
    } else {
      await cancelAllNotifications();
    }
  }

  Future<void> scheduleDailyNotification() async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: 0,
        title: '오늘의 별빛 운세가 도착했어요! 🔮',
        body: '지금 접속해서 당신만의 특별한 운세를 확인해보세요.',
        scheduledDate: _nextInstanceOfNineAM(),
        notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
                'daily_fortune_channel', 
                '데일리 운세 알림',
                channelDescription: '매일 아침 9시에 오늘의 운세를 알려줍니다.',
                importance: Importance.max,
                priority: Priority.high,
            ),
            iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfNineAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 9);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
