import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:successhunter/auth/auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/utils/enum_dictionary.dart';

class LoginPage extends StatefulWidget {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _signupFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _loginScreenKey = GlobalKey<ScaffoldState>();

  @override
  _LoginPageState createState() =>
      _LoginPageState(_loginFormKey, _signupFormKey, _loginScreenKey);
}

class _LoginPageState extends State<LoginPage> {
  // Variable
  double screenWidth;
  double screenHeight;

  TextEditingController _loginEmailController;
  TextEditingController _loginPasswordController;

  TextEditingController _signupUsernameController;
  TextEditingController _signupEmailController;
  TextEditingController _signupPasswordController;
  TextEditingController _signupConfirmPasswordController;

  PageController _pageController;

  bool _obscureLoginPassword;
  bool _obscureSignupPassword;
  bool _obscureSignupConfirm;
  bool _loginAutoValidate;
  bool _signupAutoValidate;

  final GlobalKey<FormState> _loginFormKey;
  final GlobalKey<FormState> _signupFormKey;
  final GlobalKey<ScaffoldState> _loginScreenKey;

  _LoginPageState(
      this._loginFormKey, this._signupFormKey, this._loginScreenKey);

  // Business
  @override
  void initState() {
    super.initState();

    _loginEmailController = TextEditingController();
    _loginPasswordController = TextEditingController();

    _signupUsernameController = TextEditingController();
    _signupEmailController = TextEditingController();
    _signupPasswordController = TextEditingController();
    _signupConfirmPasswordController = TextEditingController();

    _pageController = PageController();

    _obscureLoginPassword = true;
    _obscureSignupPassword = true;
    _obscureSignupConfirm = true;
    _loginAutoValidate = false;
    _signupAutoValidate = false;

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    _pageController.dispose();

    _loginEmailController.dispose();
    _loginPasswordController.dispose();

    _signupEmailController.dispose();
    _signupUsernameController.dispose();
    _signupPasswordController.dispose();
    _signupConfirmPasswordController.dispose();

    super.dispose();
  }

  void _loginWithEmail(BuildContext context) {
    final FormState formState = _loginFormKey.currentState;

    if (formState.validate()) {
      Auth.instance
          .signInWithEmail(
            email: _loginEmailController.text,
            password: _loginPasswordController.text,
          )
          .catchError(
            (e) => Helper.showInSnackBar(
                  _loginScreenKey.currentState,
                  e.message,
                ),
          );
    } else {
      setState(() {
        _loginAutoValidate = true;
      });
    }
  }

  void _signup(BuildContext context) {
    final FormState formState = _signupFormKey.currentState;

    if (formState.validate()) {
      gDisplayName = _signupUsernameController.text;
      Auth.instance
          .createNewUser(
            email: _signupEmailController.text,
            password: _signupPasswordController.text,
            displayName: _signupUsernameController.text,
          )
          .catchError(
            (e) => Helper.showInSnackBar(
                  _loginScreenKey.currentState,
                  e.message,
                ),
          );
    } else {
      setState(() {
        _signupAutoValidate = true;
      });
    }
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      key: _loginScreenKey,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            _buildHeaderSection(context),
            _buildAuthSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Helper.buildHeaderBackground(context),
        Center(
          child: Text(
            'Success Hunter',
            style: Theme.header1Style
                .copyWith(color: Colors.white, fontSize: 30.0),
          ),
        )
      ],
    );
  }

  Widget _buildAuthSection(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: screenHeight * 0.25,
        ),
        Container(
          height: screenHeight * 0.75,
          width: screenWidth - 20.0,
          child: Card(
            elevation: 10.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: _buildAuthPageView(context),
          ),
        ),
      ],
    );
  }

  Widget _buildAuthPageView(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        _buildLoginView(context),
        _buildSignUpView(context),
      ],
    );
  }

  Widget _buildLoginView(BuildContext context) {
    return Form(
      key: _loginFormKey,
      autovalidate: _loginAutoValidate,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'LOGIN',
            style: Theme.header2Style.copyWith(
              color: Theme.Colors.mainColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              controller: _loginEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'someone@email.com',
                labelText: 'Email',
                labelStyle: Theme.contentStyle.copyWith(
                  color: Theme.Colors.thirdColor,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required.';
                }

                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value)) {
                  return 'Enter valid email.';
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              controller: _loginPasswordController,
              obscureText: _obscureLoginPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: Theme.contentStyle.copyWith(
                  color: Theme.Colors.thirdColor,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureLoginPassword = !_obscureLoginPassword;
                    });
                  },
                  child: Icon(_obscureLoginPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required.';
                }

                return null;
              },
            ),
          ),
          InkWell(
            onTap: () => _loginWithEmail(context),
            child: Container(
              width: screenWidth * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.Colors.mainColor, Theme.Colors.secondaryColor],
                  stops: [0.5, 1.0],
                  tileMode: TileMode.clamp,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.Colors.mainColor,
                    offset: Offset(1.0, 6.0),
                    blurRadius: 3.0,
                  ),
                  BoxShadow(
                    color: Theme.Colors.secondaryColor,
                    offset: Offset(1.0, 6.0),
                    blurRadius: 3.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Text(
                    'LOGIN',
                    style: Theme.header3Style.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 30.0,
            ),
            child: Text(
              'Login with:',
              style: Theme.contentStyle.copyWith(
                color: Theme.Colors.thirdColor,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: CircleBorder(),
                  color: Theme.Colors.mainColor,
                  splashColor: Theme.Colors.secondaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            backgroundColor: Colors.transparent,
                            children: [
                              Container(
                                height: 30.0,
                                width: 170.0,
                                child: FlareActor(
                                  'assets/flare/loading.flr',
                                  animation: 'loading',
                                ),
                              ),
                            ],
                          );
                        });
                    Auth.instance.signInWithGoogle().then((user) {
                      Navigator.of(context).pop();
                    }).catchError(
                      (e) {
                        Navigator.of(context).pop();
                        Helper.showInSnackBar(
                          _loginScreenKey.currentState,
                          e.message,
                        );
                      },
                    );
                  },
                ),
                RaisedButton(
                  shape: CircleBorder(),
                  color: Theme.Colors.mainColor,
                  splashColor: Theme.Colors.secondaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Icon(
                      FontAwesomeIcons.facebookF,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            backgroundColor: Colors.transparent,
                            children: [
                              Container(
                                height: 30.0,
                                width: 170.0,
                                child: FlareActor(
                                  'assets/flare/loading.flr',
                                  animation: 'loading',
                                ),
                              ),
                            ],
                          );
                        });
                    Auth.instance.signInWithFacebook().then((user) {
                      Navigator.of(context).pop();
                    }).catchError(
                      (e) {
                        Navigator.of(context).pop();
                        Helper.showInSnackBar(
                          _loginScreenKey.currentState,
                          e.message,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              _pageController.animateToPage(1,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.decelerate);
            },
            child: Text(
              'Don\'t have an account? Sign up',
              style: Theme.contentStyle.copyWith(
                color: Theme.Colors.mainColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignUpView(BuildContext context) {
    return Form(
      key: _signupFormKey,
      autovalidate: _signupAutoValidate,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'SIGN UP',
            style: Theme.header2Style.copyWith(
              color: Theme.Colors.mainColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              controller: _signupUsernameController,
              decoration: InputDecoration(
                hintText: 'Your name',
                labelText: 'Username',
                labelStyle: Theme.contentStyle.copyWith(
                  color: Theme.Colors.thirdColor,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Username is required.';
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              controller: _signupEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                hintText: 'someone@email.com',
                labelText: 'Email',
                labelStyle: Theme.contentStyle.copyWith(
                  color: Theme.Colors.thirdColor,
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required.';
                }

                Pattern pattern =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regex = new RegExp(pattern);
                if (!regex.hasMatch(value)) {
                  return 'Enter valid email.';
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              controller: _signupPasswordController,
              obscureText: _obscureSignupPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: Theme.contentStyle.copyWith(
                  color: Theme.Colors.thirdColor,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureSignupPassword = !_obscureSignupPassword;
                    });
                  },
                  child: Icon(_obscureSignupPassword
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required.';
                }

                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: TextFormField(
              controller: _signupConfirmPasswordController,
              obscureText: _obscureSignupConfirm,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: Theme.contentStyle.copyWith(
                  color: Theme.Colors.thirdColor,
                ),
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _obscureSignupConfirm = !_obscureSignupConfirm;
                    });
                  },
                  child: Icon(_obscureSignupConfirm
                      ? Icons.visibility
                      : Icons.visibility_off),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required.';
                }

                if (value != _signupPasswordController.text) {
                  return 'Password and Confirm Password should be the same.';
                }

                return null;
              },
            ),
          ),
          InkWell(
            onTap: () => _signup(context),
            child: Container(
              width: screenWidth * 0.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Theme.Colors.mainColor, Theme.Colors.secondaryColor],
                  stops: [0.5, 1.0],
                  tileMode: TileMode.clamp,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Theme.Colors.mainColor,
                    offset: Offset(1.0, 6.0),
                    blurRadius: 3.0,
                  ),
                  BoxShadow(
                    color: Theme.Colors.secondaryColor,
                    offset: Offset(1.0, 6.0),
                    blurRadius: 3.0,
                  ),
                ],
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Center(
                  child: Text(
                    'SIGN UP',
                    style: Theme.header3Style.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
