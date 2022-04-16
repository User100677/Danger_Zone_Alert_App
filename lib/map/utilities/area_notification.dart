import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

NotificationDetails get _ongoing {
  const androidChannelSpecifics = AndroidNotificationDetails(
      'channel id', 'channel name',
      importance: Importance.max,
      priority: Priority.max,
      ongoing: true,
      autoCancel: true,
      playSound: false);

  const iOSChannelSpecifics = IOSNotificationDetails();
  return const NotificationDetails(
      android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
}

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);

Future<void> cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}
