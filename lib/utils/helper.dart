import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:successhunter/model/user.dart';
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

IconData getStateIcon(int state) {
  switch (state) {
    case ActivityState.done:
      return Icons.check;
    case ActivityState.doing:
      return Icons.flag;
    case ActivityState.failed:
      return Icons.clear;
  }

  return Icons.flag;
}

String getStateString(int state) {
  switch (state) {
    case ActivityState.done:
      return 'Attained';
    case ActivityState.doing:
      return 'In Process';
    case ActivityState.failed:
      return 'Failed';
  }

  return 'Error';
}

Widget buildFlareLoading() {
  return Container(
    height: 30.0,
    width: 170.0,
    child: FlareActor(
      'assets/flare/loading.flr',
      animation: 'loading',
    ),
  );
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
          image: image == null
              ? null
              : DecorationImage(
                  image: image,
                  fit: BoxFit.contain,
                  colorFilter: ColorFilter.mode(
                      color.withOpacity(0.4), BlendMode.dstIn)),
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

Widget buildCircularIcon({
  @required TypeDecoration data,
  double size: 80.0,
}) {
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

void showLevelUpDialog(BuildContext context, User info) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Level Up',
          style: Theme.header2Style,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10.0),
              height: 300.0,
              width: 200.0,
              child: FlareActor(
                'assets/flare/firework.flr',
                animation: 'fired',
                fit: BoxFit.contain,
              ),
            ),
            Text(
              'Congratulation! You\'ve just reached level ${info.level}',
              style: Theme.contentStyle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: <Widget>[
          RaisedButton(
            textColor: Colors.white,
            child: Text(
              'Ok',
              style: Theme.header4Style,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          RaisedButton(
            textColor: Colors.white,
            child: Text(
              'Share',
              style: Theme.header4Style,
            ),
            onPressed: () {
              Navigator.of(context).pop();
              Share.share('I\'ve just reached level ${info.level}. Hurrrray!');
            },
          ),
        ],
      );
    },
  );
}
