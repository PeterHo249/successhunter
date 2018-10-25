// Login package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Auth {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  Auth();

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

  Future<FirebaseUser> signIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken,
    );

    print('User auth: ${user.displayName}');
    return user;
  }

  void signOut() {
    googleSignIn.signOut();
    print('User signed out');
  }
}
