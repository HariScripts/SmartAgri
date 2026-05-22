import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final FlutterLocalNotificationsPlugin localNotifications = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await localNotifications.initialize(initializationSettings);

    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'smartagri_bg_alerts',
      'SmartAgri Alerts',
      channelDescription: 'Alerts for SmartAgri sensors and crop health',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await localNotifications.show(
      999,
      '⚠️ SmartAgri Alert',
      'Low Nitrogen Detected. Apply Urea at 50 kg/hectare.',
      platformChannelSpecifics,
    );

    return Future.value(true);
  });
}

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const InitializationSettings initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
    );

    // Initialize Workmanager
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false,
    );
  }

  static Future<void> showNotification(String title, String body) async {
    const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'smartagri_alerts',
        'SmartAgri Alerts',
        channelDescription: 'Alerts for SmartAgri sensors and crop health',
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecond,
      title,
      body,
      notificationDetails,
    );
  }

  static Future<void> startBackgroundAlerts() async {
    await Workmanager().registerPeriodicTask(
      "smartagri_bg_task",
      "smartagri_bg_alert_check",
      frequency: const Duration(minutes: 15),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }
}
