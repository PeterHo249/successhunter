import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/user.dart';
import 'package:successhunter/ui/goal/goal_detail.dart';
import 'package:successhunter/ui/habit/habit_detail.dart';

class FirebaseNotification {
  static final FirebaseNotification _singleton =
      FirebaseNotification._internal();

  FirebaseNotification._internal();

  static FirebaseNotification get instance => _singleton;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  BuildContext context;

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

  void addFCMToken() {
    DataFeeder.instance.getInfo().listen((DocumentSnapshot documentSnapshot) {
      User info =
          User.fromJson(json.decode(json.encode(documentSnapshot.data)));
      firebaseMessaging.getToken().then((token) {
        if (info.fcmToken.indexOf(token) == -1) {
          info.fcmToken.add(token);
          DataFeeder.instance.overwriteInfo(info);
        }
      });
    });
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) {
      FirebaseNotification.instance.iOSPermission();
    }

    FirebaseNotification.instance.firebaseMessaging.getToken().then((token) {
      print(token);
    });

    FirebaseNotification.instance.firebaseMessaging.configure(
      onMessage: onMessageCallback,
      onResume: onResumeCallback,
      onLaunch: onLaunchCallback,
    );
  }

  Future onMessageCallback(Map<String, dynamic> message) async {
    print('On message $message');
    print(context);
  }

  Future onResumeCallback(Map<String, dynamic> message) async {
    print('On Resume $message');

    String category = message['category'];
    String documentId = message['documentId'];
    switch (category) {
      case 'Goal':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GoalDetail(
                      documentId: documentId,
                    )));
        break;
      case 'Habit':
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return HabitDetail(
            documentId: documentId,
          );
        }));
        break;
      default:
    }
  }

  Future onLaunchCallback(Map<String, dynamic> message) async {
    print('On Launch $message');

    String category = message['category'];
    String documentId = message['documentId'];
    switch (category) {
      case 'Goal':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GoalDetail(
                      documentId: documentId,
                    )));
        break;
      case 'Habit':
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HabitDetail(
                      documentId: documentId,
                    )));
        break;
      default:
    }
  }
}
