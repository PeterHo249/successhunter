import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/model/chart_data.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/user.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_ui/hero_dialog_route.dart';
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/ui/custom_ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_ui/custom_sliver_persistent_header_delegate.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/ui/chart/stacked_area_chart.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  // Variable
  double screenHeight;
  double screenWidth;
  TextEditingController controller;

  // Business
  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void showEditNameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Edit display name',
            style: Theme.header2Style,
          ),
          content: Container(
            height: 50.0,
            child: Center(
              child: TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter a new name',
                  hintStyle: Theme.contentStyle,
                ),
              ),
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              textColor: Colors.white,
              child: Text(
                'Cancel',
                style: Theme.header4Style,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              textColor: Colors.white,
              child: Text(
                'Ok',
                style: Theme.header4Style,
              ),
              onPressed: () {
                if (controller.text != null) {
                  gInfo.displayName = controller.text;
                  DataFeeder.instance.overwriteInfo(gInfo);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: DataFeeder.instance.getInfo(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                CustomSliverAppBar(
                  backgroundColor: Theme.Colors.mainColor,
                  foregroundColor: Colors.white,
                  height: screenHeight * 0.3,
                  width: screenWidth,
                  flexibleChild: Helper.buildFlareLoading(),
                  title: 'Display Name',
                  image: AssetImage('assets/img/statistics.png'),
                ),
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Something was wrong!',
                      style: Theme.contentStyle,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        gInfo = User.fromJson(json.decode(json.encode(snapshot.data.data)));

        return Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              _buildHeader(context),
              _buildSectionHeader(context, 'Avatars'),
              _buildAvatarSection(context),
              _buildSectionHeader(context, 'Achivements'),
              _buildAchivementSection(context),
              _buildSectionHeader(context, 'Goal last 10 days'),
              _buildGoalChart(context),
              _buildSectionHeader(context, 'Habit last 10 days'),
              _buildHabitChart(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CustomSliverAppBar(
      backgroundColor: Theme.Colors.mainColor,
      foregroundColor: Colors.white,
      height: screenHeight * 0.3,
      width: screenWidth,
      flexibleChild: _buildInfoSection(context, gInfo),
      title: gInfo.displayName,
      image: AssetImage('assets/img/statistics.png'),
      action: IconButton(
        icon: Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          showEditNameDialog(context);
        },
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, User info) {
    return Container(
      width: screenWidth,
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Container(
                height: screenHeight * 0.3 - 100.0,
                width: screenHeight * 0.3 - 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  image: DecorationImage(
                    image: AssetImage('assets/background/background_1.jpg'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset(
                    'assets/avatar/${info.currentAvatar}',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 15.0),
                child: Container(
                  height: screenHeight * 0.3 - 60.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Lv: ${info.level}',
                            style: Theme.contentStyle.copyWith(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Experience:',
                                  style: Theme.contentStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                                Text(
                                  '${info.experience}/${info.level * 50}',
                                  style: Theme.contentStyle.copyWith(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          LinearPercentIndicator(
                            width: screenWidth - screenHeight * 0.23,
                            lineHeight: 10.0,
                            percent: info.experience.toDouble() /
                                (info.level * 50).toDouble(),
                            progressColor: Colors.deepOrange,
                            padding: const EdgeInsets.all(0.0),
                            backgroundColor: Colors.blueGrey,
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            animation: true,
                            animationDuration: 700,
                          ),
                        ],
                      ),
                      Wrap(
                        alignment: WrapAlignment.spaceEvenly,
                        spacing: 10.0,
                        runSpacing: 5.0,
                        runAlignment: WrapAlignment.center,
                        children: info.badges
                            .sublist(info.badges.length - 4 < 0
                                ? 0
                                : info.badges.length - 4)
                            .map((badge) {
                          return Container(
                            width: 50.0,
                            height: 50.0,
                            child: Image.asset(
                              'assets/badge/$badge',
                              fit: BoxFit.contain,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverPersistentHeaderDelegate(
        minHeight: 60.0,
        maxHeight: 80.0,
        child: Container(
          color: Colors.white,
          child: Text(
            title,
            style: Theme.header2Style.copyWith(
              color: Theme.Colors.mainColor,
            ),
          ),
          alignment: Alignment(-0.9, 0.0),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      children: gInfo.availableAvatars.map((avatar) {
        return InkWell(
          onTap: () {
            gInfo.currentAvatar = avatar;
            DataFeeder.instance.overwriteInfo(gInfo);
          },
          child: Container(
            height: 100.0,
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/avatar/$avatar',
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      }).toList(),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    );
  }

  Widget _buildAchivementSection(BuildContext context) {
    return SliverGrid.count(
      crossAxisCount: 3,
      children: gInfo.badges.map((badge) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              HeroDialogRoute(
                builder: (BuildContext context) {
                  return Center(
                    child: AlertDialog(
                      title: Text(
                        'Badge',
                        style: Theme.header2Style,
                      ),
                      content: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              height: 100.0,
                              width: 100.0,
                              child: Hero(
                                tag: badge,
                                child: Image.asset(
                                  'assets/badge/$badge',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Text(
                              badgeNames[badge],
                              style: Theme.contentStyle,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ],
                        ),
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
                      ],
                    ),
                  );
                },
              ),
            );
          },
          child: Container(
            height: 100.0,
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Hero(
                tag: badge,
                child: Image.asset(
                  'assets/badge/$badge',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      }).toList(),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    );
  }

  Widget _buildGoalChart(context) {
    var data = gInfo.goalCounts ?? List<TaskCountPerDate>();
    var currentDate = DateTime.now();

    while (data.length < 10) {
      data.insert(
        0,
        TaskCountPerDate(
          date: currentDate.subtract(Duration(days: 1 + data.length)).day,
          doingCount: 0,
          attainedCount: 0,
          failedCount: 0,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          StackedAreaChart(
            data: data,
            animate: true,
            height: 200.0,
            width: 250.0,
          ),
        ],
      ),
    );
  }

  Widget _buildHabitChart(context) {
    var data = gInfo.habitCounts ?? List<TaskCountPerDate>();
    var currentDate = DateTime.now();

    while (data.length < 10) {
      data.insert(
        0,
        TaskCountPerDate(
          date: currentDate.subtract(Duration(days: 1 + data.length)).day,
          doingCount: 0,
          attainedCount: 0,
          failedCount: 0,
        ),
      );
    }

    return SliverList(
      delegate: SliverChildListDelegate(
        [
          StackedAreaChart(
            data: data,
            animate: true,
            height: 200.0,
            width: 250.0,
          ),
        ],
      ),
    );
  }
}
