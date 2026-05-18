import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);
    await _plugin.initialize(settings);
  }

  static Future<void> showTaskSavedNotification(String title) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'tasks_channel',
        'Task Notifications',
        channelDescription: 'Notifications for study tasks and deadlines',
        importance: Importance.high,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
    await _plugin.show(0, 'Task saved', title, details);
  }
}
