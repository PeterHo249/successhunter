import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      home: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _isAlreadyIntro;

  @override
  void initState() {
    _isAlreadyIntro = _prefs.then((SharedPreferences prefs) {
      print('in get init state');
      return prefs.getBool('isAlreadyIntro') ?? false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('in build');
    return _buildHome(context);
  }

  Widget _buildHome(BuildContext context) {
    return FutureBuilder(
      future: _isAlreadyIntro,
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        print('in future builder');
        print(snapshot.data);
        if (ConnectionState.waiting == snapshot.connectionState) {
          return SplashPage();
        } else {
          if (snapshot.data) {
            return _handleCurrentScreen();
          } else {
            return _buildIntro(context);
          }
        }
      },
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
            DataFeeder.instance.initUserInfo(snapshot.data);
            return MainPage(
              user: snapshot.data,
            );
          }
          return LoginPage();
        }
      },
    );
  }

  Widget _buildIntro(BuildContext context) {
    print('in build intro');
    return IntroViewsFlutter(
      _buildPageViewModel(context),
      onTapDoneButton: () {
        _prefs.then((SharedPreferences prefs) {
          prefs.setBool('isAlreadyIntro', true);
        });
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => _handleCurrentScreen()));
      },
      showSkipButton: false,
    );
  }

  List<PageViewModel> _buildPageViewModel(BuildContext context) {
    return <PageViewModel>[
      PageViewModel(
        pageColor: Colors.amber,
        title: Text('Test Intro'),
        mainImage: Image.asset(
          'assets/avatar/boss_1.png',
          height: 250.0,
          width: 250.0,
          alignment: Alignment.center,
          fit: BoxFit.contain,
        ),
        body: Text('Something to intro my app'),
      ),
    ];
  }
}
