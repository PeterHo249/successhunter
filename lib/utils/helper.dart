import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/enum_dictionary.dart';

Color getStateColor(int state) {
  switch (state) {
    case ActivityState.done:
      return Colors.green;
    case ActivityState.doing:
      return Colors.amber;
    case ActivityState.failed:
      return Colors.red;
  }

  return Colors.grey;
}

Widget buildHeaderBackground(BuildContext context,
    {Color color, double height, double width, ImageProvider image}) {
  if (height == null) {
    height = MediaQuery.of(context).size.height * 0.3;
  }
  if (width == null) {
    width = MediaQuery.of(context).size.width;
  }
  if (color == null) {
    color = Theme.Colors.mainColor;
  }

  return Stack(
    alignment: Alignment.topCenter,
    children: <Widget>[
      Container(
        color: Colors.white,
        height: height,
        width: width,
      ),
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          image: image == null ? null : DecorationImage(
            image: image,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(color.withOpacity(0.4), BlendMode.dstIn)
          ),
          gradient: LinearGradient(
            colors: [
              color,
              TinyColor(color).lighten(30).color,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
            tileMode: TileMode.clamp,
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
      ),
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color.withAlpha(180),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(180.0),
            bottomRight: Radius.circular(180.0),
          ),
        ),
      ),
      Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color.withAlpha(80),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(100.0),
            bottomRight: Radius.circular(100.0),
          ),
        ),
      ),
    ],
  );
}

void showInSnackBar(ScaffoldState scaffoldState, String message) {
  final snackBar = SnackBar(
    content: Text(
      message,
      style: Theme.contentStyle.copyWith(
        color: Colors.white,
      ),
    ),
    backgroundColor: Colors.grey[700],
    duration: Duration(seconds: 3),
  );

  scaffoldState.showSnackBar(snackBar);
}

Widget buildCircularIcon({@required TypeDecoration data, double size: 80.0,}) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: data.backgroundColor,
    ),
    child: Icon(
      data.icon,
      color: data.color,
      size: size * 0.4,
    ),
  );
}