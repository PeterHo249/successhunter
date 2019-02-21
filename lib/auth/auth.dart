// Login package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'dart:async';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  static final Auth _singleton = Auth._internal();

  Auth._internal();

  static Auth get instance => _singleton;

  Future<Null> signInWithFacebook() async {
    var result = await facebookLogin
        .logInWithReadPermissions(['email', 'public_profile']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _auth
            .signInWithFacebook(accessToken: result.accessToken.token)
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
  }

  Future<FirebaseUser> createNewUser({@required String email, @required String password, @required String displayName}) async {
    final FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = displayName;
    await user.updateProfile(userUpdateInfo);
    user.sendEmailVerification();
    return user;
  }

  Future<FirebaseUser> signInWithEmail({@required String email, @required String password}) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(email: email, password: password);

    return user;
  }

  Future<FirebaseUser> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken,
    );

    print('User auth: ${user.displayName}');
    return user;
  }

  Future<Null> signOut() async {
    await _auth.signOut();
    print('User signed out');
  }
}
