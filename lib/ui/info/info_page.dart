import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/model/chart_data.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/user.dart';
import 'package:flare_flutter/flare_actor.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_sliver_persistent_header_delegate.dart';
import 'package:successhunter/ui/chart/stacked_area_chart.dart';

class InfoPage extends StatefulWidget {
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  // Variable
  double screenHeight;
  double screenWidth;
  User info;

  // Business

  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return CustomScrollView(
      slivers: <Widget>[
        _buildHeader(context),
        _buildSectionHeader(context, 'Avatars'),
        _buildSectionHeader(context, 'Achivements'),
        _buildSectionHeader(context, 'Goal last 10 days'),
        _buildSectionHeader(context, 'Habit last 10 days'),

        /*SliverList(
          delegate: SliverChildListDelegate(
            [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Avatars',
                  style: Theme.contentStyle.copyWith(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Wrap(
                spacing: 10.0,
                alignment: WrapAlignment.spaceEvenly,
                runSpacing: 5.0,
                children: <Widget>[
                  Container(
                    height: 80.0,
                    width: 80.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 80.0,
                    width: 80.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 80.0,
                    width: 80.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 80.0,
                    width: 80.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 80.0,
                    width: 80.0,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Achivements',
                  style: Theme.contentStyle.copyWith(
                    fontSize: 20.0,
                  ),
                ),
              ),
              Wrap(
                spacing: 10.0,
                alignment: WrapAlignment.spaceEvenly,
                runSpacing: 5.0,
                children: <Widget>[
                  Container(
                    height: 80.0,
                    width: 80.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 80.0,
                    width: 80.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 80.0,
                    width: 80.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 80.0,
                    width: 80.0,
                    color: Colors.grey[300],
                  ),
                  Container(
                    height: 80.0,
                    width: 80.0,
                    color: Colors.grey[300],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Your working on Goal last 10 day',
                  style: Theme.contentStyle.copyWith(
                    fontSize: 20.0,
                  ),
                ),
              ),
              StackedAreaChart(
                data: [
                  TaskCountPerDate(
                    date: 0,
                    doingCount: 5,
                    attainedCount: 2,
                    failedCount: 3,
                  ),
                  TaskCountPerDate(
                    date: 1,
                    doingCount: 6,
                    attainedCount: 3,
                    failedCount: 1,
                  ),
                  TaskCountPerDate(
                    date: 2,
                    doingCount: 1,
                    attainedCount: 4,
                    failedCount: 7,
                  ),
                ],
                animate: true,
                height: 200.0,
                width: 250.0,
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Your working on Habit last 10 day',
                  style: Theme.contentStyle.copyWith(
                    fontSize: 20.0,
                  ),
                ),
              ),
              StackedAreaChart(
                data: [
                  TaskCountPerDate(
                    date: 0,
                    doingCount: 5,
                    attainedCount: 2,
                    failedCount: 3,
                  ),
                  TaskCountPerDate(
                    date: 1,
                    doingCount: 6,
                    attainedCount: 3,
                    failedCount: 1,
                  ),
                  TaskCountPerDate(
                    date: 2,
                    doingCount: 1,
                    attainedCount: 4,
                    failedCount: 7,
                  ),
                ],
                animate: true,
                height: 200.0,
                width: 250.0,
              ),
            ],
          ),
        ),*/
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return StreamBuilder(
      stream: DataFeeder.instance.getInfo(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CustomSliverAppBar(
            backgroundColor: Theme.Colors.mainColor,
            foregroundColor: Colors.white,
            height: screenHeight * 0.3,
            width: screenWidth,
            flexibleChild: Helper.buildFlareLoading(),
            title: 'Display Name',
            image: AssetImage('assets/img/statistics.png'),
          );
        }

        info = User.fromJson(json.decode(json.encode(snapshot.data.data)));

        return CustomSliverAppBar(
          backgroundColor: Theme.Colors.mainColor,
          foregroundColor: Colors.white,
          height: screenHeight * 0.3,
          width: screenWidth,
          flexibleChild: _buildInfoSection(context, info),
          title: info.displayName,
          image: AssetImage('assets/img/statistics.png'),
        );
      },
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
}
