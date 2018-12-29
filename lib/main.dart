import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    return new MaterialApp(
      title: 'Success Hunter',
      debugShowCheckedModeBanner: false,
      theme: new ThemeData(
        primarySwatch: Colors.blue,
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
  Future checkAlreadyIntro() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _isAlreadyIntro = prefs.getBool('isAlreadyIntro') ?? false;

    if (_isAlreadyIntro) { // Change this condition to check intro
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeWidget()));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IntroPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseNotification.instance.firebaseCloudMessagingListeners();
    checkAlreadyIntro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class HomeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _handleCurrentScreen();
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

class IntroPage extends StatelessWidget {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return _buildIntro(context);
  }

  Widget _buildIntro(BuildContext context) {
    return IntroViewsFlutter(
      _buildPageViewModel(context),
      onTapDoneButton: () {
        _prefs.then((SharedPreferences prefs) {
          prefs.setBool('isAlreadyIntro', true);
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeApp()));
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
}
