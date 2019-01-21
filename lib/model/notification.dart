import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/ui/coop/coop_invitation.dart';
import 'package:successhunter/ui/goal/goal_detail.dart';
import 'package:successhunter/ui/habit/habit_detail.dart';
import 'package:successhunter/utils/enum_dictionary.dart';

class FirebaseNotification {
  static final FirebaseNotification _singleton =
      FirebaseNotification._internal();

  FirebaseNotification._internal();

  static FirebaseNotification get instance => _singleton;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  BuildContext context;
  String token;

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
    firebaseMessaging.getToken().then((token) {
      this.token = token;
      if (gInfo.fcmToken.indexOf(token) == -1) {
        gInfo.fcmToken.add(token);
        DataFeeder.instance.overwriteInfo(gInfo);
      }
    });
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) {
      FirebaseNotification.instance.iOSPermission();
    }

    FirebaseNotification.instance.firebaseMessaging.getToken().then((token) {
      print('>>>>>>>>>>>>>>>>>>>>>>>>> $token');
    });

    FirebaseNotification.instance.firebaseMessaging.configure(
      onMessage: onMessageCallback,
      onResume: onResumeCallback,
      onLaunch: onLaunchCallback,
    );
  }

  Future onMessageCallback(Map<String, dynamic> message) async {
    print('On message $message');
    Map<String, dynamic> data = message['data'];
    String category = data['category'];

    switch (category) {
      case 'Coop':
        String status = data['status'];
        String coopId = data['coopId'];
        String inviterUid = data['inviterUid'];
        switch (status) {
          case InvitationStatusEnum.beInvited:
            print('invitation from $inviterUid for $coopId');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CoopInvitation(
                          coopId: coopId,
                          inviterUid: inviterUid,
                        )));
            break;
          default:
        }
        break;
      default:
    }
  }

  Future onResumeCallback(Map<String, dynamic> message) async {
    print('On Resume $message');

    String category = message['category'];
    String documentId;
    switch (category) {
      case 'Coop':
        String status = message['status'];
        String coopId = message['coopId'];
        String inviterUid = message['inviterUid'];
        switch (status) {
          case InvitationStatusEnum.beInvited:
            print('invitation from $inviterUid for $coopId');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CoopInvitation(
                          coopId: coopId,
                          inviterUid: inviterUid,
                        )));
            break;
          default:
        }
        break;
      case 'Goal':
        documentId = message['documentId'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GoalDetail(
                      documentId: documentId,
                    )));
        break;
      case 'Habit':
        documentId = message['documentId'];
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
    String documentId;
    switch (category) {
      case 'Coop':
        String status = message['status'];
        String coopId = message['coopId'];
        String inviterUid = message['inviterUid'];
        switch (status) {
          case InvitationStatusEnum.beInvited:
            print('invitation from $inviterUid for $coopId');
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CoopInvitation(
                          coopId: coopId,
                          inviterUid: inviterUid,
                        )));
            break;
          default:
        }
        break;
      case 'Goal':
        documentId = message['documentId'];
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GoalDetail(
                      documentId: documentId,
                    )));
        break;
      case 'Habit':
        documentId = message['documentId'];
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
