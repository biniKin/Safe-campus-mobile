// import 'dart:convert';

// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// Future<void> showNotification(String title, String body) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'panic_channel',
//     'Panic Alerts',
//     importance: Importance.max,
//     priority: Priority.high,
//     playSound: true,
//   );

//   const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(android: androidPlatformChannelSpecifics);

//   await flutterLocalNotificationsPlugin.show(
//     0,
//     title,
//     body,
//     platformChannelSpecifics,
//   );
// }

// // Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
// //   await Firebase.initializeApp();
// //   final data = message.data;

// //   await showNotification(
// //     data['user']['fullName'] ?? 'Panic Alert',
// //     'Tap to view location',
// //   );
// // }

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
//   final data = message.data;

//   String title = "Panic Alert";

//   if (data.containsKey('user')) {
//     try {
//       final user = jsonDecode(data['user']);
//       title = user['fullName'] ?? title;
//     } catch (e) {
//       print("JSON decode error: $e");
//     }
//   }

//   await showNotification(
//     title,
//     'Tap to view location',
//   );
// }

import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//----------------------------------------
// Extract title (reusable in all states)
//----------------------------------------
String parseAlertTitle(Map<String, dynamic> data) {
  String title = "Panic Alert";

  if (data.containsKey('user')) {
    try {
      final user = jsonDecode(data['user']);
      title = user['fullName'] ?? title;
    } catch (e) {
      print("JSON decode error: $e");
    }
  }
  return title;
}

//----------------------------------------
// Show Notification (foreground + background)
//----------------------------------------
Future<void> showNotification(String title, String body) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'panic_channel',
    'Panic Alerts',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    0,
    title,
    body,
    details,
  );
}

//----------------------------------------
// Background Handler (needs re-init)
//----------------------------------------
Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message) async {

  await Firebase.initializeApp();

  // IMPORTANT: reinitialize local notifications for background isolate
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final title = parseAlertTitle(message.data);

  await showNotification(
    title,
    'Tap to view location',
  );
}
