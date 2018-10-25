import 'package:flutter/material.dart';

import 'ui/login_page.dart';



void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Success Hunter',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}

/*
class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() {
    return new MyHomePageState();
  }
}

class MyHomePageState extends State<MyHomePage> {
  Future<FirebaseUser> _signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken,
    );

    print('User auth: ${user.displayName}');
    return user;
  }

  void _signOut() {
    googleSignIn.signOut();
    print('User signed out');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auth Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: () => _signIn()
                  .then((FirebaseUser user) => print(user))
                  .catchError((e) => print(e)),
              child: Text('Sign In'),
              color: Colors.green,
            ),
            RaisedButton(
              onPressed: _signOut,
              child: Text('Sign Out'),
              color: Colors.amber,
            ),
            RaisedButton(
              onPressed: () => facebookLogin.logInWithReadPermissions(
                      ['email', 'public_profile']).then((result) {
                    switch (result.status) {
                      case FacebookLoginStatus.loggedIn:
                        _auth
                            .signInWithFacebook(
                                accessToken: result.accessToken.token)
                            .then((signedInUser) {
                          print('Signed in as ${signedInUser.displayName}');
                        }).catchError((e) => print(e));
                        break;
                      case FacebookLoginStatus.cancelledByUser:
                        print('Canceled');
                        break;
                      case FacebookLoginStatus.error:
                        print('error');
                    }
                  }).catchError((e) => print(e)),
              child: Text('Sign in with FB'),
              color: Colors.green[300],
            ),
            RaisedButton(
              onPressed: () {
                facebookLogin.logOut();
                print('Log out fb');
              },
              child: Text('Sign out FB'),
              color: Colors.amber[300],
            ),
          ],
        ),
      ),
    );
  }
}
*/
