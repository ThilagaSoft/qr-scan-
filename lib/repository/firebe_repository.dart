import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseRepository
{
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static  Future<void> initFirebase() async
  {
    await Firebase.initializeApp();
    await _messaging.requestPermission();

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  static Future<void> _backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint("📩 Background message: ${message.notification?.title}");
  }

   Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint("❌ Error getting FCM token: $e");
      return null;
    }
  }

  static void configureFCMListeners(BuildContext context)
  {
    FirebaseMessaging.onMessage.listen((message)
    {
      if (message.notification != null) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(message.notification!.title ?? "New Message"),
            content: Text(message.notification!.body ?? ""),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message)
    {
      if (message.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Opened from notification: ${message.notification!.title ?? ''}")),
        );
      }
    });

    _messaging.getInitialMessage().then((message)
    {
      if (message?.notification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Launched from notification: ${message!.notification!.title ?? ''}")),
        );
      }
    });
  }

   Future<void> subscribeToTopic(String topic) =>
      _messaging.subscribeToTopic(topic);

   Future<void> unsubscribeFromTopic(String topic) =>
      _messaging.unsubscribeFromTopic(topic);
}
