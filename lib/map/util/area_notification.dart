import 'package:flutter_local_notifications/flutter_local_notifications.dart';

NotificationDetails get _ongoing {
  const androidChannelSpecifics = AndroidNotificationDetails(
    'channel id',
    'channel name',
    importance: Importance.max,
    priority: Priority.high,
    ongoing: true,
    autoCancel: false,
  );
  const iOSChannelSpecifics = IOSNotificationDetails();
  return const NotificationDetails(
      android: androidChannelSpecifics, iOS: iOSChannelSpecifics);
}

Future showOngoingNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  int id = 0,
}) =>
    _showNotification(notifications,
        title: title, body: body, id: id, type: _ongoing);

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  required String title,
  required String body,
  required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);
