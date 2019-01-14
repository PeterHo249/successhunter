import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:successhunter/model/user.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

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
      WaveWidget(
        config: CustomConfig(
          gradients: [
            [Colors.white10, Colors.white70],
            [Colors.white12, Colors.white70],
            [Colors.white30, Colors.white70],
          ],
          durations: [
            30000,
            20000,
            25000,
          ],
          heightPercentages: [
            0.85,
            0.85,
            0.85,
          ],
          blur: MaskFilter.blur(BlurStyle.solid, 10),
          gradientBegin: Alignment.topCenter,
          gradientEnd: Alignment.bottomCenter,
        ),
        waveAmplitude: 8.0,
        backgroundColor: color,
        size: Size(
          width,
          height,
        ),
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
                    color.withOpacity(0.1),
                    BlendMode.dstIn,
                  ),
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

void showLevelUpDialog(
  BuildContext context,
  User info, {
  String content,
  List<String> imagePaths,
}) {
  List<Widget> imagesRow = <Widget>[];
  if (imagePaths != null) {
    imagesRow = imagePaths.map((imagePath) {
      return Container(
        height: 100.0,
        width: 100.0,
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      );
    }).toList();
  }

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
            imagePaths == null
                ? Container(
                    padding: EdgeInsets.all(10.0),
                    height: 300.0,
                    width: 200.0,
                    child: FlareActor(
                      'assets/flare/firework.flr',
                      animation: 'fired',
                      fit: BoxFit.contain,
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Wrap(
                      children: imagesRow,
                      runAlignment: WrapAlignment.center,
                      alignment: WrapAlignment.center,
                      spacing: 10.0,
                      runSpacing: 5.0,
                      crossAxisAlignment: WrapCrossAlignment.center,
                    )),
            Text(
              content == null
                  ? 'Congratulation! You\'ve just reached level ${info.level}'
                  : content,
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
