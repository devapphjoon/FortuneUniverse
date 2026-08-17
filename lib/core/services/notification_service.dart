import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isNotificationEnabled = true;

  bool get isNotificationEnabled => _isNotificationEnabled;

  Future<void> init() async {
    tz.initializeTimeZones();
    // 한국 시간대 설정 (필요에 따라 변경)
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
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
    
    // 알림 초기 기본값을 true로 설정
    _isNotificationEnabled = prefs.getBool('isNotificationEnabled') ?? true;
    final bool isFirstRun = prefs.getBool('isFirstRun_notification') ?? true;

    // 첫 실행이면서 알림이 활성화되어 있다면 권한을 요청합니다.
    if (isFirstRun && _isNotificationEnabled) {
      final granted = await requestPermissions();
      if (!granted) {
        _isNotificationEnabled = false;
        await prefs.setBool('isNotificationEnabled', false);
      }
      await prefs.setBool('isFirstRun_notification', false);
    }

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
    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
          id: 0,
          title: 'noti_fortune_title'.tr,
          body: 'noti_fortune_body'.tr,
          scheduledDate: _nextInstanceOfNineAM(),
          notificationDetails: NotificationDetails(
              android: AndroidNotificationDetails(
                  'daily_fortune_channel_id', 
                  'daily_notification'.tr,
                  channelDescription: 'daily_notification_desc'.tr,
                  importance: Importance.max,
                  priority: Priority.high,
              ),
              iOS: DarwinNotificationDetails(),
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      print('Failed to schedule daily notification: $e');
    }
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
