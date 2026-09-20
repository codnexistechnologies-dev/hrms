import 'package:aeon_hrms/firebase_messaging/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

String deviceTokenToSendPushNotification = '';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> firebaseNotification(
  BuildContext context,
) async {
  /// ** Here managed the app is in different state
  /// 1. This method call when app in terminated state and you get a notification
  /// In this method , when you click on notification app open from terminated state and you can get notification data

  FirebaseMessaging.instance.getInitialMessage().then(
    (message) {
      /// here app is a background state
      print("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message?.notification != null) {
        Map<String, String> finalPayLoadData =
            Map<String, String>.from(message!.data);
        print(
            "------Killed---------finalPayLoadData--------------:: $finalPayLoadData");
      }
    },
  );

  ///2. This method only call when App in foreground it mean app must be opened
  FirebaseMessaging.onMessage.listen(
    (RemoteMessage message) {
      print("FirebaseMessaging.onMessage.listen");

      /// here app is a  live state
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print("message.data11 $message");
        print(message.contentAvailable);
        LocalNotificationService.createAndDisplayNotification(message);
      }
    },
  );

  /// 3. This method only call when App in background and not terminated
  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {
      /// here app is a background state
      print(
          "------background---------message.notification!.title--------------:: ${message.notification!.title}");
      print(
          "------background---------message.notification!.body--------------:: ${message.notification!.body}");
      print(
          "------background---------message.notification!.body--------------:: ${message.data['data']}");
      print(
          "------background---------message.notification!.body--------------:: ${message.data}");
      debugPrint("FirebaseMessaging.onMessageOpenedApp.listen");
      if (message.notification != null) {
        // ignore: unused_local_variable
        Map<String, String> finalPayLoadData =
            Map<String, String>.from(message.data);
      } else {
        print(message.data);
        print(message.notification);
      }
    },
  );

  /// Get our device token here
  final FirebaseMessaging fcm = FirebaseMessaging.instance;
  final token = await fcm.getToken();
  deviceTokenToSendPushNotification = token.toString();
  print(
      "My Device Token ==================> $deviceTokenToSendPushNotification");
}
