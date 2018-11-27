import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_sliver_app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable
  double screenHeight;
  double screenWidth;

  // Business

  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return CustomScrollView(
      slivers: <Widget>[
        _buildHeader(context),
        _buildContent(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return CustomSliverAppBar(
      backgroundColor: Theme.Colors.mainColor,
      foregroundColor: Colors.white,
      height: screenHeight * 0.3,
      width: screenWidth,
      flexibleChild: _buildInfoSection(context),
      title: 'Display Name',
      image: AssetImage('assets/img/statistics.png'),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
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
                color: Colors.red,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Lv: 50',
                            style: Theme.contentStyle.copyWith(
                              color: Colors.white,
                              fontSize: 20.0,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Icon(
                                  FontAwesomeIcons.coins,
                                  color: Colors.yellow,
                                ),
                              ),
                              Text(
                                '3500',
                                style: Theme.contentStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
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
                                  '230/1000',
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
                            percent: 0.5,
                            progressColor: Colors.redAccent,
                            backgroundColor: Colors.blueGrey,
                            linearStrokeCap: LinearStrokeCap.round,
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
                        children: <Widget>[
                          Container(
                            width: 50.0,
                            height: 50.0,
                            color: Colors.green,
                          ),
                          Container(
                            width: 50.0,
                            height: 50.0,
                            color: Colors.green,
                          ),
                          Container(
                            width: 50.0,
                            height: 50.0,
                            color: Colors.green,
                          ),
                        ],
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

  Widget _buildContent(BuildContext context) {
    return SliverFillRemaining();
  }
}

/*
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/ui/goal_detail.dart';
import 'package:successhunter/ui/goal_form.dart';
import 'package:successhunter/ui/habit_detail.dart';
import 'package:successhunter/ui/habit_form.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'dart:core';
import 'package:successhunter/utils/formatter.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  /// Variable
  var documentIds = <String>[];
  var goals = <Goal>[];

  var habits = <Habit>[];
  var habitDocumentIds = <String>[];

  double screenWidth = 0.0;
  double screenHeight = 0.0;

  /// Business process

  /// Build layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: Theme.Colors.primaryGradient,
      ),
      child: ListView(
        children: <Widget>[
          _buildInfoCard(context),
          _buildGoalCard(context),
          _buildTaskCard(context),
        ],
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Card(
        elevation: 5.0,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: (screenWidth - 40) * 0.3,
                      width: (screenWidth - 40) * 0.3,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 30.0),
                        child: SizedBox(
                          width: (screenWidth - 40) * 0.7,
                          child: Text(
                            'Display name',
                            overflow: TextOverflow.ellipsis,
                            style: Theme.header1Style,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: SizedBox(
                          width: (screenWidth - 40) * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Lv: 13',
                                style: Theme.header4Style,
                              ),
                              Text(
                                'Gold: 1300',
                                style: Theme.header4Style,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: SizedBox(
                          width: (screenWidth - 40) * 0.7,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Exp',
                                style: Theme.header4Style,
                              ),
                              Text(
                                '80/150',
                                style: Theme.header4Style,
                              ),
                            ],
                          ),
                        ),
                      ),
                      LinearPercentIndicator(
                        width: (screenWidth - 40) * 0.7,
                        lineHeight: 10.0,
                        percent: 0.52,
                        animation: true,
                        animationDuration: 1000,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        backgroundColor: Colors.grey[300],
                        progressColor: Theme.Colors.secondaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Container(
                    height: 60.0,
                    width: 60.0,
                    color: Colors.yellow,
                  ),
                  Container(
                    height: 60.0,
                    width: 60.0,
                    color: Colors.yellow,
                  ),
                  Container(
                    height: 60.0,
                    width: 60.0,
                    color: Colors.yellow,
                  ),
                  Container(
                    height: 60.0,
                    width: 60.0,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGoalCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
      child: Card(
        elevation: 5.0,
        child: Container(
          height: 250.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Your Goals',
                  style: Theme.header2Style,
                ),
                StreamBuilder(
                  stream: DataFeeder.instance.getDoingGoalList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                    if (snapshot.data.documents.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => GoalForm(),
                              ),
                            );
                            setState(() {});
                          },
                          child: Container(
                            height: 190.0,
                            width: screenWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Icon(
                                    Icons.add,
                                    size: 60.0,
                                    color: Colors.black45,
                                  ),
                                ),
                                Text(
                                  'Plan a new goal!',
                                  style: Theme.contentStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    goals = snapshot.data.documents
                        .map((documentSnapshot) => Goal.fromJson(
                            json.decode(json.encode(documentSnapshot.data))))
                        .toList();

                    documentIds = snapshot.data.documents
                        .map((documentSnapshot) => documentSnapshot.documentID)
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 190.0,
                        child: PageView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: goals.length,
                          controller: PageController(viewportFraction: 1.0),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildGoalItem(
                                context, goals[index], documentIds[index]);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalItem(
      BuildContext context, Goal goalItem, String documentId) {
    return InkWell(
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GoalDetail(
                    documentId: documentId,
                  ),
            ),
          ),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: screenWidth - 30.0,
                child: Text(
                  goalItem.title,
                  style: Theme.header4Style,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: screenWidth - 160.0,
                    height: 100.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Start Date: ${Formatter.getDateString(goalItem.startDate)}',
                          style: Theme.contentStyle,
                        ),
                        Text(
                          'End Date: ${Formatter.getDateString(goalItem.targetDate)}',
                          style: Theme.contentStyle,
                        ),
                      ],
                    ),
                  ),
                  CircularPercentIndicator(
                    radius: 100.0,
                    lineWidth: 10.0,
                    percent: goalItem.getDonePercent(),
                    circularStrokeCap: CircularStrokeCap.round,
                    backgroundColor: Colors.grey[300],
                    progressColor: Colors.blue[500],
                    animation: true,
                    animationDuration: 1500,
                    center: Text('${goalItem.getDonePercent() * 100} %'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1.0, horizontal: 5.0),
      child: Card(
        elevation: 5.0,
        child: Container(
          height: 250.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Today Task',
                  style: Theme.header2Style,
                ),
                StreamBuilder(
                  stream: DataFeeder.instance.getTodayHabitList(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                    if (snapshot.data.documents.length == 0) {
                      return Padding(
                        padding: const EdgeInsets.only(
                          top: 10.0,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HabitForm(),
                              ),
                            );
                            setState(() {});
                          },
                          child: Container(
                            height: 190.0,
                            width: screenWidth,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Icon(
                                    Icons.add,
                                    size: 60.0,
                                    color: Colors.black45,
                                  ),
                                ),
                                Text(
                                  'Create a new habit!',
                                  style: Theme.contentStyle,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    habits = snapshot.data.documents
                        .map((documentSnapshot) => Habit.fromJson(
                            json.decode(json.encode(documentSnapshot.data))))
                        .toList();

                    habitDocumentIds = snapshot.data.documents
                        .map((documentSnapshot) => documentSnapshot.documentID)
                        .toList();

                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        height: 190.0,
                        child: PageView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: habits.length,
                          controller: PageController(viewportFraction: 1.0),
                          itemBuilder: (BuildContext context, int index) {
                            return _buildTaskItem(context, habits[index],
                                habitDocumentIds[index]);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, Habit item, String documentId) {
    Widget secondRow;

    if (item.isYesNoTask) {
      secondRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Due time: ${Formatter.getTimeString(item.dueTime)}',
            style: Theme.contentStyle,
          ),
          InkWell(
            onTap: () {
              item.completeToday();
              DataFeeder.instance.overwriteHabit(documentId, item);
              setState(() {});
            },
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.state == ActivityState.doing
                    ? Colors.amber
                    : Colors.green,
              ),
              child: Icon(
                item.state == ActivityState.done ? Icons.check : Icons.remove,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      secondRow = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Due time: ${Formatter.getTimeString(item.dueTime)}',
                style: Theme.contentStyle,
              ),
              Text(
                '${item.currentValue}/${item.targetValue} ${item.unit}',
                style: Theme.contentStyle,
              ),
            ],
          ),
          Slider(
            value: item.currentValue.toDouble(),
            onChanged: (value) {
              item.currentValue = value.toInt();
              if (item.currentValue == item.targetValue) {
                item.completeToday();
              }
              DataFeeder.instance.overwriteHabit(documentId, item);
              setState(() {});
            },
            divisions: item.targetValue,
            min: 0.0,
            max: item.targetValue.toDouble(),
            activeColor: Colors.blue[500],
          ),
        ],
      );
    }

    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitDetail(
                  documentId: documentId,
                ),
          ),
        );
        setState(() {});
      },
      child: Container(
        height: 190.0,
        width: screenWidth - 30.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: screenWidth - 30.0,
                child: Text(
                  item.title,
                  style: Theme.header4Style,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              secondRow,
            ],
          ),
        ),
      ),
    );
  }
}
*/
