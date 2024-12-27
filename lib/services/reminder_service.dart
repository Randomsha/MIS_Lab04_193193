import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class ReminderService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize timezone database
  Future<void> init() async {
    tz.initializeTimeZones(); // This initializes the timezone data
    const androidInitialization = AndroidInitializationSettings('app_icon');
    const initializationSettings = InitializationSettings(
      android: androidInitialization,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Schedule reminder notification with converted TZDateTime
  Future<void> showReminder(
      String title, String body, DateTime scheduledTime) async {
    // Get the specific time zone location
    final location = tz.getLocation('Europe/Belgrade'); // Use your timezone

    // Convert DateTime to TZDateTime in the desired location
    final tzScheduledTime = tz.TZDateTime.from(scheduledTime, location);

    // Android notification details
    const androidDetails = AndroidNotificationDetails(
      'exam_reminder_channel',
      'Exam Reminder',
      channelDescription: 'Notification channel for exam reminders',
      importance: Importance.high,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(android: androidDetails);

    // Schedule the notification
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      tzScheduledTime, // Use TZDateTime here
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
    );
  }
}
