import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/model/notification.dart';
import 'package:successhunter/model/user.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_ui/custom_sliver_persistent_header_delegate.dart';
import 'package:successhunter/ui/goal/goal_detail.dart';
import 'package:successhunter/ui/goal/goal_form.dart';
import 'package:successhunter/ui/habit/habit_detail.dart';
import 'package:successhunter/ui/habit/habit_form.dart';
import 'package:successhunter/ui/info/info_page.dart';
import 'package:successhunter/utils/formatter.dart';
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/utils/enum_dictionary.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable
  double screenHeight;
  double screenWidth;

  var goals = <GoalDocument>[];

  var habits = <HabitDocument>[];

  // Business
  @override
    void initState() {
      super.initState();
    }

  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return CustomScrollView(
      slivers: <Widget>[
        _buildHeader(context),
        _buildSectionHeader(context, 'Today Task'),
        _buildTodayTaskSection(context),
        _buildSectionHeader(context, 'My Goal'),
        _buildGoalSection(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return StreamBuilder(
      stream: DataFeeder.instance.getInfo(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData || snapshot.data.data == null) {
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

        gInfo = User.fromJson(json.decode(json.encode(snapshot.data.data)));
        FirebaseNotification.instance.addFCMToken();

        return CustomSliverAppBar(
          backgroundColor: Theme.Colors.mainColor,
          foregroundColor: Colors.white,
          height: screenHeight * 0.3,
          width: screenWidth,
          flexibleChild: _buildInfoSection(context, gInfo),
          title: gInfo.displayName,
          image: AssetImage('assets/img/statistics.png'),
        );
      },
    );
  }

  Widget _buildInfoSection(BuildContext context, User info) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InfoPage()));
      },
      child: Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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

  Widget _buildTodayTaskSection(BuildContext context) {
    return StreamBuilder(
      stream: DataFeeder.instance.getTodayHabitList(),
      builder: ((context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: 120.0,
                  child: Center(
                    child: Helper.buildFlareLoading(),
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.data.documents.length == 0) {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                InkWell(
                  onTap: () {
                    Navigator.push(this.context,
                        MaterialPageRoute(builder: (context) => HabitForm()));
                  },
                  child: Container(
                    height: 120.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                        Text(
                          'You don\'t have any task today.\n Press + to add new one.',
                          style: Theme.contentStyle.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        habits = snapshot.data.documents
            .map(
              (documentSnapshot) => HabitDocument(
                    item: Habit.fromJson(
                        json.decode(json.encode(documentSnapshot.data))),
                    documentId: documentSnapshot.documentID,
                  ),
            )
            .toList();

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _buildTodayTaskTile(context, habits[index]);
            },
            childCount: habits.length,
          ),
        );
      }),
    );
  }

  Widget _buildTodayTaskTile(BuildContext context, HabitDocument document) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return HabitDetail(
                  documentId: document.documentId,
                );
              },
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: new SlideTransition(
                    position: new Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1.0, 0.0),
                    ).animate(secondaryAnimation),
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 100.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: document.documentId,
                      child: Helper.buildCircularIcon(
                          data: TypeDecorationEnum.typeDecorations[
                              ActivityTypeEnum.getIndex(document.item.type)],
                          size: 70.0),
                    ),
                    _buildTodayTaskInfo(context, document),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayTaskInfo(BuildContext context, HabitDocument document) {
    Widget result;

    String dueTimeInfo;

    switch (document.item.repetationType) {
      case RepetationTypeEnum.everyDay:
        dueTimeInfo =
            'Due every day at ${Formatter.getTimeString(document.item.dueTime)}';
        break;
      case RepetationTypeEnum.period:
        dueTimeInfo =
            'Due every ${document.item.period} day(s) at ${Formatter.getTimeString(document.item.dueTime)}';
        break;
      case RepetationTypeEnum.dayOfWeek:
        dueTimeInfo = 'Due every ';
        for (int i = 0; i < document.item.daysOfWeek.length; i++) {
          dueTimeInfo += '${document.item.daysOfWeek[i]} ';
        }
        dueTimeInfo += 'at ${Formatter.getTimeString(document.item.dueTime)}';
        break;
    }

    if (document.item.isYesNoTask) {
      result = Container(
        width: screenWidth - 100.0,
        height: 100.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: screenWidth - 200.0,
                    child: Text(
                      document.item.title,
                      style: Theme.header3Style,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    width: screenWidth - 200.0,
                    child: Text(
                      dueTimeInfo,
                      style: Theme.contentStyle,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                document.item.completeToday(context);
                gInfo.addExperience(context, 10);
                DataFeeder.instance.overwriteInfo(gInfo);
                DataFeeder.instance
                    .overwriteHabit(document.documentId, document.item);
              },
              child: Helper.buildCircularIcon(
                  data: TypeDecoration(
                    icon: Icons.remove,
                    color: Colors.white,
                    backgroundColor: Colors.amber,
                  ),
                  size: 30.0),
            ),
          ],
        ),
      );
    } else {
      result = Container(
        width: screenWidth - 100.0,
        height: 100.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: screenWidth - 200.0,
                        child: Text(
                          document.item.title,
                          style: Theme.header3Style,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(
                        width: screenWidth - 200.0,
                        child: Text(
                          dueTimeInfo,
                          style: Theme.contentStyle,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Completed:\n${document.item.currentValue}/${document.item.targetValue} ${document.item.unit}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Slider(
              value: document.item.currentValue.toDouble(),
              onChanged: (value) {
                document.item.currentValue = value.toInt();
                if (document.item.currentValue == document.item.targetValue) {
                  document.item.completeToday(context);
                  gInfo.addExperience(context, 10);
                  DataFeeder.instance.overwriteInfo(gInfo);
                }
                DataFeeder.instance
                    .overwriteHabit(document.documentId, document.item);
                setState(() {});
              },
              divisions: document.item.targetValue,
              min: 0.0,
              max: document.item.targetValue.toDouble(),
              activeColor: Colors.blue[500],
            ),
          ],
        ),
      );
    }

    return result;
  }

  Widget _buildGoalSection(BuildContext context) {
    return StreamBuilder(
      stream: DataFeeder.instance.getDoingGoalList(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  height: 120.0,
                  child: Center(
                    child: Helper.buildFlareLoading(),
                  ),
                ),
              ],
            ),
          );
        }

        if (snapshot.data.documents.length == 0) {
          return SliverList(
            delegate: SliverChildListDelegate(
              [
                InkWell(
                  onTap: () {
                    Navigator.push(this.context,
                        MaterialPageRoute(builder: (context) => GoalForm()));
                  },
                  child: Container(
                    height: 120.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.add,
                          size: 50.0,
                          color: Colors.grey,
                        ),
                        Text(
                          'You don\'t have any goal to attain.\n Press + to add new one.',
                          style: Theme.contentStyle.copyWith(
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        goals = snapshot.data.documents
            .map(
              (documentSnapshot) => GoalDocument(
                    item: Goal.fromJson(
                        json.decode(json.encode(documentSnapshot.data))),
                    documentId: documentSnapshot.documentID,
                  ),
            )
            .toList();

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _buildDoingGoalTile(context, goals[index]);
            },
            childCount: goals.length,
          ),
        );
      },
    );
  }

  Widget _buildDoingGoalTile(BuildContext context, GoalDocument document) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return GoalDetail(
                  documentId: document.documentId,
                );
              },
              transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) {
                return SlideTransition(
                  position: new Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: new SlideTransition(
                    position: new Tween<Offset>(
                      begin: Offset.zero,
                      end: const Offset(1.0, 0.0),
                    ).animate(secondaryAnimation),
                    child: child,
                  ),
                );
              },
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 100.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: document.documentId,
                      child: Helper.buildCircularIcon(
                        data: TypeDecorationEnum.typeDecorations[
                            ActivityTypeEnum.getIndex(document.item.type)],
                        size: 70.0,
                      ),
                    ),
                    _buildGoalInfo(context, document),
                  ],
                ),
              ),
            ),
            Divider(
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalInfo(BuildContext context, GoalDocument document) {
    int remainDay = document.item.targetDate
        .toLocal()
        .difference(DateTime.now().toLocal())
        .inDays;
    if (remainDay < 0) {
      remainDay = 0;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: Container(
        width: screenWidth - 100.0,
        height: 130.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              document.item.title,
              style: Theme.header2Style,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              'From ${Formatter.getDateString(document.item.startDate.toLocal())} to ${Formatter.getDateString(document.item.targetDate.toLocal())}',
              style: Theme.contentStyle,
              overflow: TextOverflow.ellipsis,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$remainDay day(s) remain',
                  style: Theme.contentStyle,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  'Target: ${document.item.targetValue} ${document.item.unit}',
                  style: Theme.contentStyle,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            LinearPercentIndicator(
              width: screenWidth - 100.0,
              lineHeight: 10.0,
              progressColor: TypeDecorationEnum
                  .typeDecorations[
                      ActivityTypeEnum.getIndex(document.item.type)]
                  .backgroundColor,
              backgroundColor: Colors.grey,
              percent: document.item.currentValue.toDouble() /
                  document.item.targetValue.toDouble(),
            ),
          ],
        ),
      ),
    );
  }
}
