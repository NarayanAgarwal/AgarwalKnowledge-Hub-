import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  bool _useMock = false;

  void enableMockMode() {
    _useMock = true;
  }

  Future<void> initialize() async {
    if (_useMock) {
      print("NotificationService: Initialized in mock mode.");
      return;
    }

    try {
      // Request permission
      await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      // Get FCM token
      String? token = await _fcm.getToken();
      print("FCM Token: $token");

      // Set up listeners
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print("Received foreground push notification: ${message.notification?.title}");
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("Push notification clicked to open app: ${message.notification?.title}");
      });
    } catch (e) {
      print("NotificationService error: $e");
    }
  }

  Future<void> subscribeToTopic(String topic) async {
    if (_useMock) return;
    try {
      await _fcm.subscribeToTopic(topic);
    } catch (e) {
      // Handle
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (_useMock) return;
    try {
      await _fcm.unsubscribeFromTopic(topic);
    } catch (e) {
      // Handle
    }
  }
}
