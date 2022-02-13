import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AlertNotification {
  static final _notification = FlutterLocalNotificationsPlugin();

  // details settings of ios and android platform
  static NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'id',
        'name',
        importance: Importance.min,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static void init({bool initScheduled = false}) {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iOs = IOSInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: iOs);

    _notification.initialize(settings);
  }

  static void showNotification(
          {int id = 0, String? title, String? body, String? payload}) =>
      _notification.show(
        id,
        title,
        body,
        _notificationDetails(),
        payload: payload,
      );
}
