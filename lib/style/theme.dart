import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color mainColor = const Color(0xff00a5ff);
  static const Color secondaryColor = const Color(0xff7deafd);
  static const Color thirdColor = const Color(0xff1cafff);
  static const Color tabItemSelected = const Color(0xff18e86c);

  static const primaryGradient = const LinearGradient(
    colors: const [mainColor, secondaryColor],
    stops: const [0.3, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

const TextStyle header1Style = const TextStyle(
  fontFamily: 'RobotoBold',
  fontSize: 25.0,
);

const TextStyle header2Style = const TextStyle(
  fontFamily: 'RobotoMedium',
  fontSize: 22.0,
);

const TextStyle header3Style = const TextStyle(
  fontFamily: 'RobotoMedium',
  fontSize: 20.0,
);

const TextStyle header4Style = const TextStyle(
  fontFamily: 'RobotoMedium',
  fontSize: 18.0,
);


const TextStyle contentStyle = const TextStyle(
  fontFamily: 'RobotoRegular',
  fontSize: 16.0,
);
