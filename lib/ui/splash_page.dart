import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/helper.dart' as Helper;

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  // Variable
  double screenWidth;
  double screenHeight;
  // Business
  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            _buildHeaderSection(context),
            Container(
              width: screenWidth,
              height: screenHeight,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.Colors.mainColor),
                ),
              ),
            ),
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
}