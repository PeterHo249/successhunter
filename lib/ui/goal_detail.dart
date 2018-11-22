import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/ui/goal_form.dart';
import 'package:successhunter/ui/milestone_form.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/utils/formatter.dart';
import 'package:share/share.dart';

class GoalDetail extends StatefulWidget {
  final String documentId;

  GoalDetail({this.documentId});

  @override
  _GoalDetailState createState() => _GoalDetailState();
}

class _GoalDetailState extends State<GoalDetail> {
  /// Variable
  Goal item;
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  /// Business process
  void _handlePopupMenuChoice(String choice) {
    // TODO: Implement here
    switch (choice) {
      case GoalDetailPopupChoiceEnum.addMilestone:
        Navigator.push(
          this.context,
          MaterialPageRoute(
              builder: (context) => MilestoneForm(
                    documentId: widget.documentId,
                  )),
        );
        break;
      case GoalDetailPopupChoiceEnum.completeGoal:
        item.state = ActivityState.done;
        item.currentValue = item.targetValue;
        DataFeeder.instance.overwriteGoal(widget.documentId, item);
        break;
      case GoalDetailPopupChoiceEnum.editGoal:
        Navigator.push(
          this.context,
          MaterialPageRoute(
              builder: (context) => GoalForm(
                    documentId: widget.documentId,
                  )),
        );
        break;
      case GoalDetailPopupChoiceEnum.shareGoal:
        Share.share(
          'I\'m try to attain goal ${item.title} before ${Formatter.getDateString(item.targetDate)}. Do you want take it with me?',
        );
        break;
    }

    print(choice);
  }

  Color _getStateColor(int state) {
    switch (state) {
      case ActivityState.done:
        return Colors.green;
      case ActivityState.doing:
        return Colors.amber;
      case ActivityState.failed:
        return Colors.red;
    }

    return Colors.amber;
  }

  IconData _getStateIcon(int state) {
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

  /// Build Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: DataFeeder.instance.getGoal(widget.documentId),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData)
          return Container(
            decoration: BoxDecoration(
              gradient: Theme.Colors.primaryGradient,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );

        item = Goal.fromJson(json.decode(json.encode(snapshot.data.data)));
        item.milestones.sort((Milestone a, Milestone b) {
          return a.targetDate.compareTo(b.targetDate);
        });

        return Scaffold(
          appBar: AppBar(
            title: Text('My Goal'),
            backgroundColor: Theme.Colors.loginGradientStart,
            elevation: 0.0,
            actions: <Widget>[
              _buildPopupMenu(context),
            ],
          ),
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: Theme.Colors.primaryGradient,
                ),
              ),
              Card(
                color: Helper.getStateBackgroundColor(item.state),
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 130.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0, right: 10.0, left: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Stack(
                              alignment: AlignmentDirectional.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: 70.0,
                                    ),
                                    Container(
                                      color: Colors.grey,
                                      width: 5.0,
                                      height: 50.0,
                                    ),
                                  ],
                                ),
                                item.buildCircularIcon(),
                              ],
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: screenWidth - 130.0,
                                    child: Text(
                                      item.title,
                                      style: Theme.header2Style,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: screenWidth - 130.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 50.0,
                                          child: Text(
                                            '${item.targetValue} ${item.unit}',
                                            style: Theme.contentStyle,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Text(
                                          '${item.targetDate.difference(DateTime.now()).inDays} day(s) remain',
                                          style: Theme.contentStyle,
                                        ),
                                        Text(
                                          '${Formatter.getDateString(item.targetDate)}',
                                          style: Theme.contentStyle,
                                        ),
                                      ],
                                    ),
                                  ),
                                  LinearPercentIndicator(
                                    width: screenWidth - 130.0,
                                    percent: item.getDonePercent(),
                                    backgroundColor: Colors.grey[300],
                                    progressColor: TypeDecorationEnum
                                        .typeDecorations[
                                            ActivityTypeEnum.getIndex(item.type)]
                                        .backgroundColor,
                                    animation: true,
                                    animationDuration: 1000,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: screenHeight - 220.0,
                      child: ListView(
                        children: _buildMilestoneList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _handlePopupMenuChoice,
      icon: Icon(Icons.menu),
      itemBuilder: (BuildContext context) {
        return GoalDetailPopupChoiceEnum.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  List<Widget> _buildMilestoneList() {
    final List<Milestone> milestones = item.milestones;

    List<Widget> milestoneTiles = <Widget>[];

    for (int i = milestones.length - 1; i >= 0; i--) {
      Widget tile = Slidable.builder(
        key: Key(milestones[i].title),
        delegate: SlidableDrawerDelegate(),
        controller: SlidableController(),
        actionExtentRatio: 0.25,
        slideToDismissDelegate: SlideToDismissDrawerDelegate(
          dismissThresholds: <SlideActionType, double>{
            SlideActionType.primary: 1.0,
          },
          onDismissed: (actionType) {
            if (actionType == SlideActionType.secondary) {
              item.milestones.removeAt(i);
              DataFeeder.instance.overwriteGoal(widget.documentId, item);
            }
          },
        ),
        actionDelegate: SlideActionBuilderDelegate(
          builder: (context, index, animation, renderingMode) {
            return IconSlideAction(
              caption: 'Complete',
              color: Colors.green,
              icon: Icons.check,
              onTap: () {
                item.completeMilestone(i);
                DataFeeder.instance.overwriteGoal(widget.documentId, item);
                setState(() {});
              },
            );
          },
          actionCount: milestones[i].state != ActivityState.doing ? 0 : 1,
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
                item.milestones.removeAt(i);
                DataFeeder.instance.overwriteGoal(widget.documentId, item);
              },
            );
          },
          actionCount: milestones[i].state != ActivityState.doing ? 0 : 1,
        ),
        child: Container(
          height: 100.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 100.0,
                child: Center(
                  child: Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        width: 5.0,
                        color: Colors.grey,
                      ),
                      Container(
                        width: 30.0,
                        height: 30.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _getStateColor(milestones[i].state),
                        ),
                        child: Icon(
                          _getStateIcon(milestones[i].state),
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth - 130.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: screenWidth - 130.0,
                      child: Text(
                        milestones[i].title,
                        style: Theme.header4Style,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${milestones[i].targetValue} ${item.unit}',
                          style: Theme.contentStyle,
                        ),
                        Text(
                          Formatter.getDateString(milestones[i].targetDate),
                          style: Theme.contentStyle,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
      milestoneTiles.add(tile);
    }

    Widget startTile = Container(
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 100.0,
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 5.0,
                        height: 50.0,
                        color: Colors.grey,
                      ),
                      Container(),
                    ],
                  ),
                  Container(
                    width: 30.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: screenWidth - 130.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: screenWidth - 130.0,
                  child: Text(
                    'Start Goal',
                    style: Theme.header4Style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(),
                    Text(
                      Formatter.getDateString(item.startDate),
                      style: Theme.contentStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
    milestoneTiles.add(startTile);

    return milestoneTiles;
  }
}
