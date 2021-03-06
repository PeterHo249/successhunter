import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:successhunter/model/notification.dart';
import 'package:successhunter/model/user.dart';
import 'package:successhunter/utils/enum_dictionary.dart';

import 'ui/login_page.dart';
import 'package:successhunter/ui/splash_page.dart';
import 'package:successhunter/ui/main_page.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'dart:async';

void main() => runApp(new IntroApp());

class IntroApp extends StatelessWidget {
  Future<bool> checkAlreadyIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAlreadyIntro') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    checkAlreadyIntro().then((value) {
      if (value) {
        runApp(MainApp());
      }
    });
    return MaterialApp(
      title: 'Success Hunter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: _buildIntro(context),
    );
  }

  Widget _buildIntro(BuildContext context) {
    return IntroViewsFlutter(
      _buildPageViewModel(context),
      onTapDoneButton: () {
        SharedPreferences.getInstance().then((SharedPreferences prefs) {
          prefs.setBool('isAlreadyIntro', true);
        });
        runApp(MainApp());
      },
      showSkipButton: false,
    );
  }

  List<PageViewModel> _buildPageViewModel(BuildContext context) {
    double size = 200.0;
    return <PageViewModel>[
      PageViewModel(
        pageColor: Colors.amber,
        title: Text('Habits'),
        mainImage: Image.asset(
          'assets/img/habit_intro.png',
          height: size,
          width: size,
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
        body: Text(
          'Scheduling good habit to do every day, period or some day in week.',
          textAlign: TextAlign.center,
        ),
      ),
      PageViewModel(
        pageColor: Colors.green[600],
        title: Text('Goals'),
        mainImage: Image.asset(
          'assets/img/goal_intro.png',
          height: size,
          width: size,
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
        body: Text(
          'Planning some goals to reach.',
          textAlign: TextAlign.center,
        ),
      ),
      PageViewModel(
        pageColor: Colors.red,
        title: Text('Coop Goals'),
        textStyle: TextStyle(
          fontSize: 40.0,
        ),
        mainImage: Image.asset(
          'assets/img/coop_intro.png',
          height: size,
          width: size,
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
        body: Text(
          'And also attaining these goal with friend.',
          textAlign: TextAlign.center,
        ),
      ),
      PageViewModel(
        pageColor: Colors.blue[600],
        title: Text('Diaries'),
        mainImage: Image.asset(
          'assets/img/diary_intro.png',
          height: size,
          width: size,
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
        body: Text(
          'Writing your diary every day and protecting it with PIN.',
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    FirebaseNotification.instance.firebaseCloudMessagingListeners();
    return MaterialApp(
      title: 'Success Hunter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: _handleCurrentScreen(),
    );
  }

  Widget _handleCurrentScreen() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashPage();
        } else {
          if (snapshot.hasData) {
            DataFeeder.instance.setCollectionId(snapshot.data.uid);
            Firestore.instance
                .collection(DataFeeder.instance.mainCollectionId)
                .document('info')
                .snapshots()
                .listen(
              (documentSnapshot) async {
                if (!documentSnapshot.exists) {
                  var batch = Firestore.instance.batch();
                  User item = User(
                    displayName: snapshot.data.displayName ?? gDisplayName,
                    uid: snapshot.data.uid,
                    email: snapshot.data.email,
                    photoUrl: snapshot.data.photoUrl ?? 'https://lh5.googleusercontent.com/-tio6TOwKjEo/AAAAAAAAAAI/AAAAAAAAAAA/ABtNlbAnR5HoPb-HUM4Ue1VLE60JSrJYEg/s96-c/photo.jpg',
                  );
                  gInfo = item;
                  batch.setData(
                    Firestore.instance
                        .collection(DataFeeder.instance.mainCollectionId)
                        .document('info'),
                    json.decode(json.encode(item)),
                  );
                  await batch
                      .commit()
                      .catchError((error) => print('error: $error'));
                }
              },
            );

            return MainPage(
              user: snapshot.data,
            );
          }
          return LoginPage();
        }
      },
    );
  }
}
