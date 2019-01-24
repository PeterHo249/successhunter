import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:successhunter/model/coop.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/ui/coop/coop_detail.dart';
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
    Map<String, dynamic> notification = message['notification'];
    Map<String, dynamic> data = message['data'];
    String category = data['category'];

    switch (category) {
      case 'Coop':
        String status = data['status'];
        String coopId = data['coopId'];
        String content = notification['body'];
        switch (status) {
          case InvitationStatusEnum.beInvited:
            showInvitationDialog(context, coopId, content);
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
        switch (status) {
          case InvitationStatusEnum.beInvited:
            String coopId = message['coopId'];
            var inviterInfo = await DataFeeder.instance
                .getInfoFuture(uid: message['inviterUid']);
            var coopItem = await DataFeeder.instance.getCoopFuture(coopId);
            var content =
                'You are invited to attain goal ${coopItem.data['title']} with ${inviterInfo.data['displayName']}. Do you accept?';
            showInvitationDialog(context, coopId, content);
            break;

          case InvitationStatusEnum.notified:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CoopDetail(
                          documentId: message['documentId'],
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
        switch (status) {
          case InvitationStatusEnum.beInvited:
            String coopId = message['coopId'];
            var inviterInfo = await DataFeeder.instance
                .getInfoFuture(uid: message['inviterUid']);
            var coopItem = await DataFeeder.instance.getCoopFuture(coopId);
            var content =
                'You are invited to attain goal ${coopItem.data['title']} with ${inviterInfo.data['displayName']}. Do you accept?';
            showInvitationDialog(context, coopId, content);
            break;
          case InvitationStatusEnum.notified:
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CoopDetail(
                          documentId: message['documentId'],
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

  showInvitationDialog(
      BuildContext context, String coopId, String content) async {
    var rawData = await DataFeeder.instance.getCoopFuture(coopId);
    CoopGoal item = CoopGoal.fromJson(json.decode(json.encode(rawData.data)));

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Invitation',
              style: Theme.header2Style,
            ),
            content: Text(
              content,
              style: Theme.contentStyle,
            ),
            actions: <Widget>[
              RaisedButton(
                textColor: Colors.white,
                child: Text(
                  'Yes',
                  style: Theme.header4Style,
                ),
                onPressed: () {
                  item.addParticipant(gInfo.uid);
                  DataFeeder.instance.overwriteCoop(coopId, item);
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                textColor: Colors.white,
                child: Text(
                  'No',
                  style: Theme.header4Style,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
