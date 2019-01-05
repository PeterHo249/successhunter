import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:successhunter/model/notification.dart';

import 'ui/login_page.dart';
import 'package:successhunter/ui/splash_page.dart';
import 'package:successhunter/ui/main_page.dart';
import 'package:successhunter/model/data_feeder.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: 'Success Hunter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: HomeApp(),
    );
  }
}

class HomeApp extends StatefulWidget {
  _HomeAppState createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  Future<bool> checkAlreadyIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getBool('isAlreadyIntro'));
    return prefs.getBool('isAlreadyIntro') ?? false;
  }

  @override
  void initState() {
    super.initState();
    FirebaseNotification.instance.firebaseCloudMessagingListeners();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkAlreadyIntro(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashPage();
        }

        if (!snapshot.data) {
          return _buildIntro(context);
        } else {
          return _handleCurrentScreen();
        }
      },
    );
  }

  Widget _buildIntro(BuildContext context) {
    return IntroViewsFlutter(
      _buildPageViewModel(context),
      onTapDoneButton: () {
        SharedPreferences.getInstance().then((SharedPreferences prefs) {
          prefs.setBool('isAlreadyIntro', true);
          setState(() {});
        });
      },
      showSkipButton: false,
    );
  }

  List<PageViewModel> _buildPageViewModel(BuildContext context) {
    return <PageViewModel>[
      PageViewModel(
        pageColor: Colors.amber,
        title: Text('Habits'),
        mainImage: Image.asset(
          'assets/img/habit_intro.png',
          height: 250.0,
          width: 250.0,
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
          height: 300.0,
          width: 250.0,
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
        title: Text('Co-operative Goals'),
        mainImage: Image.asset(
          'assets/avatar/boss_1.png',
          height: 250.0,
          width: 250.0,
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
          height: 250.0,
          width: 250.0,
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

  Widget _handleCurrentScreen() {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashPage();
        } else {
          if (snapshot.hasData) {
            DataFeeder.instance.setCollectionId(snapshot.data.uid);
            DataFeeder.instance.initUserInfo(snapshot.data);
            FirebaseNotification.instance.addFCMToken();
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
