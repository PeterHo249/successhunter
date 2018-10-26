import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:successhunter/auth/auth.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Login with '),
            MaterialButton(
              onPressed: () => Auth().signOut(),
              child: Text('Log out'),
              color: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
