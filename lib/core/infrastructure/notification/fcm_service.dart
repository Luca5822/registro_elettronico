import 'dart:io';
import 'dart:math';

import 'package:fimber/fimber.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:registro_elettronico/core/infrastructure/log/logger.dart';

class PushNotificationService {
  static const channelId = 'com.registroelettronico/notification';
  static const channelName = 'Registro elettronico';
  static const channelDescription = 'Send and receive notifications';

  Future initialise() async {
    Fimber.i('🔔 [FCM] Called initialisation...');

    if (Platform.isIOS) {
      await FirebaseMessaging.instance.requestPermission();
    }

    if (kDebugMode) {
      final token = await FirebaseMessaging.instance.getToken();
      Fimber.i("🔔 [FCM] Got token $token");
    }

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    var initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: initializationSettingsIOS,
    );

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    FirebaseMessaging.onMessage.listen((message) async {
      Fimber.i('🔔 [FCM] Got FCM Message $message');

      await flutterLocalNotificationsPlugin.show(
        _randomId(),
        message.notification!.title,
        message.notification!.body,
        platformChannelSpecifics,
      );
    });
  }

  int _randomId() {
    return Random().nextInt(10000) + 0;
  }
}
