import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:remindme/Pages/home.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class Notificationlogic {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails(
            "Schedule Reminder", "Check your reminder")
    );
  }

  static Future init(BuildContext context, String uid) async {
    tz.initializeTimeZones();
    final android = AndroidInitializationSettings("time_workout");
    final settings = InitializationSettings(android: android);
    await _notification.initialize(
        settings, onDidReceiveBackgroundNotificationResponse: (payload) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Home()));
      onNotification.add(payload as String?);
    });
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
    required DateTime dateTime,}) async {
    if (dateTime.isBefore(DateTime.now())) {
      dateTime = dateTime.add(Duration(days: 1));
    }
    _notification.zonedSchedule(
        id, title, body, tz.TZDateTime.from(dateTime, tz.local),
        await _notificationDetails(),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
      matchDateTimeComponents: DateTimeComponents.time
    );
  }
}