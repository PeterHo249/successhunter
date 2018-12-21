import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/model/user.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/chart/pie_chart.dart';
import 'package:successhunter/ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_sliver_persistent_header_delegate.dart';
import 'package:successhunter/ui/habit/habit_detail.dart';
import 'package:successhunter/ui/habit/habit_form.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/formatter.dart';
import 'package:successhunter/utils/helper.dart' as Helper;

class HabitPage extends StatefulWidget {
  @override
  _HabitPageState createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
  // Variable
  double screenHeight;
  double screenWidth;

  var habits = <HabitDocument>[];
  var todayHabits = <HabitDocument>[];
  var attainedHabits = <HabitDocument>[];
  var failedHabits = <HabitDocument>[];
  var notTodayHabits = <HabitDocument>[];

  final SlidableController slidableController = SlidableController();

  // Business
  @override
  void initState() {
    DataFeeder.instance.getInfo().listen(
      (documentSnapshot) {
        gInfo = User.fromJson(json.decode(json.encode(documentSnapshot.data)));
      },
    );
    super.initState();
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: DataFeeder.instance.getHabitList(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CustomScrollView(
            slivers: <Widget>[
              _buildHeader(context, Container()),
              SliverFillRemaining(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ],
          );
        }

        if (snapshot.data.documents.length == 0) {
          return CustomScrollView(
            slivers: <Widget>[
              _buildHeader(context, Container()),
              SliverFillRemaining(
                child: InkWell(
                  onTap: () {
                    Navigator.push(this.context,
                        MaterialPageRoute(builder: (context) => HabitForm()));
                  },
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
                        'You don\'t have any Habit.\n Press + to plan a new one.',
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

        todayHabits.clear();
        attainedHabits.clear();
        failedHabits.clear();
        notTodayHabits.clear();

        for (int i = 0; i < habits.length; i++) {
          switch (habits[i].item.state) {
            case ActivityState.doing:
              todayHabits.add(habits[i]);
              break;
            case ActivityState.done:
              attainedHabits.add(habits[i]);
              break;
            case ActivityState.failed:
              failedHabits.add(habits[i]);
              break;
            case ActivityState.notToday:
              notTodayHabits.add(habits[i]);
              break;
          }
        }

        return CustomScrollView(
          slivers: <Widget>[
            _buildHeader(context, _buildInfoSection(context)),
            _buildSectionHeader(context, 'Today Task'),
            _buildHabitList(context, todayHabits),
            _buildSectionHeader(context, 'Attained Today'),
            _buildHabitList(context, attainedHabits),
            _buildSectionHeader(context, 'Failed Today'),
            _buildHabitList(context, failedHabits),
            _buildSectionHeader(context, 'Not Today'),
            _buildHabitList(context, notTodayHabits),
          ],
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, Widget child) {
    return CustomSliverAppBar(
      backgroundColor: Theme.Colors.mainColor,
      foregroundColor: Colors.white,
      height: screenHeight * 0.3,
      width: screenWidth,
      flexibleChild: child,
      title: 'My Habit',
      image: AssetImage('assets/img/calendar.png'),
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
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'Total habit: ${habits.length}\n\nYou have ${todayHabits.length} tasks today\n${attainedHabits.length} done tasks\n${failedHabits.length} failed tasks\nAnd ${notTodayHabits.length} tasks don\'t due today',
                style: Theme.contentStyle.copyWith(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
            PieChart(
              size: screenHeight * 0.2,
              data: <ChartEntry>[
                ChartEntry(
                  value: todayHabits.length.toDouble(),
                  color: Helper.getStateColor(ActivityState.doing),
                ),
                ChartEntry(
                  value: attainedHabits.length.toDouble(),
                  color: Helper.getStateColor(ActivityState.done),
                ),
                ChartEntry(
                  value: failedHabits.length.toDouble(),
                  color: Helper.getStateColor(ActivityState.failed),
                ),
              ],
            )
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

  Widget _buildHabitList(BuildContext context, List<HabitDocument> docs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildHabitSlidableTile(context, docs[index]);
        },
        childCount: docs.length,
      ),
    );
  }

  Widget _buildHabitSlidableTile(BuildContext context, HabitDocument doc) {
    var item = doc.item;
    return Slidable.builder(
      key: Key(item.title),
      delegate: SlidableDrawerDelegate(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      child: _buildItemTile(context, doc),
      slideToDismissDelegate: SlideToDismissDrawerDelegate(
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0,
        },
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary) {
            DataFeeder.instance.deleteHabit(doc.documentId);
          }
        },
      ),
      actionDelegate: SlideActionBuilderDelegate(
        builder: (context, index, animation, renderingMode) {
          return IconSlideAction(
            caption: 'Edit',
            color: Colors.blue,
            icon: Icons.edit,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HabitForm(
                        documentId: doc.documentId,
                      ),
                ),
              );
            },
          );
        },
        actionCount: 1,
      ),
      secondaryActionDelegate: SlideActionBuilderDelegate(
        builder: (context, index, animation, renderingMode) {
          return IconSlideAction(
            caption: 'Delete',
            color: Colors.red,
            icon: Icons.delete,
            onTap: () {
              var state = Slidable.of(context);
              state.dismiss();
              DataFeeder.instance.deleteHabit(doc.documentId);
            },
          );
        },
        actionCount: 1,
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, HabitDocument document) {
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
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Container(
                        height: 100.0,
                        width: 4.0,
                        color: Helper.getStateColor(document.item.state),
                      ),
                    ),
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
    Widget iconButton;

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

    switch (document.item.state) {
      case ActivityState.doing:
        iconButton = InkWell(
          onTap: () {
            document.item.completeToday();
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
        );
        break;
      case ActivityState.done:
        iconButton = Helper.buildCircularIcon(
          data: TypeDecoration(
            icon: Icons.check,
            color: Colors.white,
            backgroundColor: Colors.green,
          ),
          size: 30.0,
        );
        break;
      case ActivityState.failed:
        iconButton = Helper.buildCircularIcon(
          data: TypeDecoration(
            icon: Icons.close,
            color: Colors.white,
            backgroundColor: Colors.red,
          ),
          size: 30.0,
        );
        break;
      case ActivityState.notToday:
        iconButton = Helper.buildCircularIcon(
          data: TypeDecoration(
            icon: Icons.remove,
            color: Colors.white,
            backgroundColor: Colors.blueGrey,
          ),
          size: 30.0,
        );
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
            iconButton,
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
                  document.item.completeToday();
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
}
