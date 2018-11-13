import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      ),
      home: _handleCurrentScreen(),
    );
  }

  Widget _handleCurrentScreen() {
    return StreamBuilder<FirebaseUser> (
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SplashPage();
        } else {
          if (snapshot.hasData) {
            DataFeeder.instance.setCollectionId(snapshot.data.uid);
            return MainPage(user: snapshot.data,);
          }
          return LoginPage();
        }
      },
    );
  }
}

