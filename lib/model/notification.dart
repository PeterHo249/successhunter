import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotification {
  static final FirebaseNotification _singleton =
      FirebaseNotification._internal();

  FirebaseNotification._internal();

  static FirebaseNotification get instance => _singleton;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  Future onMessageCallback(Map<String, dynamic> message) async {
    print('on message $message');
  }

  Future onResumeCallback(Map<String, dynamic> message) async {
    print('on message $message');
  }

  Future onLaunchCallback(Map<String, dynamic> message) async {
    print('on message $message');
  }

  void iOSPermission() {
    firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(
        sound: false,
        badge: true,
        alert: true,
      ),
    );

    firebaseMessaging.onIosSettingsRegistered.listen(
      (IosNotificationSettings settings) {
        print('Settings registered: $settings');
      },
    );
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) {
      iOSPermission();
    }

    firebaseMessaging.getToken().then((token) {
      print(token);
    });

    firebaseMessaging.configure(
      onMessage: onMessageCallback,
      onResume: onResumeCallback,
      onLaunch: onLaunchCallback,
    );
  }
}
