import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Colors {
  const Colors();

  static const Color loginGradientStart = const Color(0xFFfbab66);
  static const Color loginGradientEnd = const Color(0xFFf7418c);
  static const Color tabItemSelected = const Color(0xff18e86c);

  static const primaryGradient = const LinearGradient(
    colors: const [loginGradientStart, loginGradientEnd],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}

const TextStyle header1Style = const TextStyle(
  fontFamily: 'WorkSansBold',
  fontSize: 25.0,
);

const TextStyle header2Style = const TextStyle(
  fontFamily: 'WorkSansBold',
  fontSize: 22.0,
);

const TextStyle header3Style = const TextStyle(
  fontFamily: 'WorkSansBold',
  fontSize: 20.0,
);

const TextStyle header4Style = const TextStyle(
  fontFamily: 'WorkSansBold',
  fontSize: 18.0,
);


const TextStyle contentStyle = const TextStyle(
  fontFamily: 'WorkSansRegular',
  fontSize: 16.0,
);
