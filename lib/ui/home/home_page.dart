import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_sliver_persistent_header_delegate.dart';
import 'package:successhunter/ui/goal/goal_form.dart';
import 'package:successhunter/ui/habit/habit_detail.dart';
import 'package:successhunter/ui/habit/habit_form.dart';
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

  var goalDocumentIds = <String>[];
  var goals = <Goal>[];

  var habitDocumentIds = <String>[];
  var habits = <Habit>[];

  // Business

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
                // TODO: Implement avatar here
                height: screenHeight * 0.3 - 100.0,
                width: screenHeight * 0.3 - 100.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  color: Colors.grey,
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
                            lineHeight: 10.0,
                            percent: 0.5,
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
                    child: CircularProgressIndicator(),
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
            .map((documentSnapshot) =>
                Habit.fromJson(json.decode(json.encode(documentSnapshot.data))))
            .toList();

        habitDocumentIds = snapshot.data.documents
            .map((documentSnapshot) => documentSnapshot.documentID)
            .toList();

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _buildTodayTaskTile(context, habits[index], index);
            },
            childCount: habits.length,
          ),
        );
      }),
    );
  }

  Widget _buildTodayTaskTile(BuildContext context, Habit item, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HabitDetail(
                documentId: habitDocumentIds[index],
              ),
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
                    Helper.buildCircularIcon(
                      data: TypeDecorationEnum
                          .typeDecorations[ActivityTypeEnum.getIndex(item.type)],
                    ),
                    _buildTodayTaskInfo(context, item, index),
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

  Widget _buildTodayTaskInfo(BuildContext context, Habit item, int index) {
    Widget result;

    String dueTimeInfo;

    switch (item.repetationType) {
      case RepetationTypeEnum.everyDay:
        dueTimeInfo = 'Due every day at ${Formatter.getTimeString(item.dueTime)}';
        break;
      case RepetationTypeEnum.period:
        dueTimeInfo = 'Due every ${item.period} day(s) at ${Formatter.getTimeString(item.dueTime)}';
        break;
      case RepetationTypeEnum.dayOfWeek:
        dueTimeInfo = 'Due every ';
        for (int i = 0; i < item.daysOfWeek.length; i++) {
          dueTimeInfo += '${item.daysOfWeek[i]} ';
        }
        dueTimeInfo += 'at ${Formatter.getTimeString(item.dueTime)}';
        break;
    }

    if (item.isYesNoTask) {
      result = Container(
        width: screenWidth - 100.0,
        height: 80.0,
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
                  Text(
                    item.title,
                    style: Theme.header3Style,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    dueTimeInfo,
                    style: Theme.contentStyle,
                    textAlign: TextAlign.left,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                item.completeToday();
                DataFeeder.instance.overwriteHabit(habitDocumentIds[index], item);
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
        height: 80.0,
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
                      Text(
                        item.title,
                        style: Theme.header3Style,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        dueTimeInfo,
                        style: Theme.contentStyle,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                Text(
                  'Completed:\n${item.currentValue}/${item.targetValue} ${item.unit}',
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
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
                DataFeeder.instance.overwriteHabit(habitDocumentIds[index], item);
                setState(() {});
              },
              divisions: item.targetValue,
              min: 0.0,
              max: item.targetValue.toDouble(),
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
                    child: CircularProgressIndicator(),
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
            .map((documentSnapshot) =>
                Goal.fromJson(json.decode(json.encode(documentSnapshot.data))))
            .toList();

        goalDocumentIds = snapshot.data.documents
            .map((documentSnapshot) => documentSnapshot.documentID)
            .toList();

        // TODO: Implement list todo here
        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return _buildDoingGoalTile(context, goals[index], index);
            },
            childCount: goals.length,
          ),
        );
      },
    );
  }

  Widget _buildDoingGoalTile(BuildContext context, Goal item, int index) {}
}

/*
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
