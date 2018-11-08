import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/goal_form.dart';
import 'package:successhunter/ui/milestone_form.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/utils/formatter.dart';

class GoalDetail extends StatefulWidget {
  final String documentId;

  GoalDetail({this.documentId});

  @override
  _GoalDetailState createState() => _GoalDetailState();
}

class _GoalDetailState extends State<GoalDetail> {
  Goal item;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataFeeder.instance.getGoal(widget.documentId),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        item = Goal.fromJson(json.decode(json.encode(snapshot.data.data)));

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
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 130.0,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            item.buildCircularIcon(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(
                                    width: 280.0,
                                    child: Text(
                                      item.title,
                                      style: TextStyle(
                                          fontFamily: 'WorkSansBold',
                                          fontSize: 18.0),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Container(
                                    width: 280.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                            '${item.targetValue} ${item.unit}'),
                                        Text(
                                            '${item.targetDate.difference(DateTime.now()).inDays} day(s) remain'),
                                        Text(
                                            '${Formatter.getDateString(item.targetDate)}'),
                                      ],
                                    ),
                                  ),
                                  LinearPercentIndicator(
                                    width: 280.0,
                                    percent: item.getDonePercent(),
                                    backgroundColor: Colors.grey[300],
                                    progressColor: TypeDecorationEnum
                                        .typeDecorations[
                                            GoalTypeEnum.getIndex(item.type)]
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
                      height: 540.0,
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

  void _handlePopupMenuChoice(String choice) {
    // TODO: Implement here
    switch (choice) {
      case GoalDetailPopupChoiceEnum.addMilestone:
        Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => MilestoneForm(documentId: widget.documentId,)),
        );
        break;
      case GoalDetailPopupChoiceEnum.completeGoal:
        item.isDone = true;
        DataFeeder.instance.overwriteGoal(widget.documentId, item);
        break;
      case GoalDetailPopupChoiceEnum.editGoal:
        Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => GoalForm(documentId: widget.documentId,)),
        );
        break;
      case GoalDetailPopupChoiceEnum.shareGoal:
        break;
    }

    print(choice);
  }

  List<Widget> _buildMilestoneList() {
    final List<Milestone> milestones = item.milestones;

    List<Widget> milestoneTiles = <Widget>[];

    for (int i = milestones.length - 1; i >= 0; i--) {
      Widget tile = Container(
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
                        color:
                            milestones[i].isDone ? Colors.green : Colors.amber,
                      ),
                      child: Icon(
                        milestones[i].isDone ? Icons.check : Icons.flag,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 280.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 280.0,
                    child: Text(
                      milestones[i].title,
                      style:
                          TextStyle(fontFamily: 'WorkSansBold', fontSize: 15.0),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text('${milestones[i].targetValue} ${item.unit}'),
                      Text(Formatter.getDateString(milestones[i].targetDate)),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
                  Container(
                    width: 5.0,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: <Color>[Colors.grey, Colors.white],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.0, 1.0],
                      ),
                    ),
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
            width: 280.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 280.0,
                  child: Text(
                    'Start Goal',
                    style:
                        TextStyle(fontFamily: 'WorkSansBold', fontSize: 15.0),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(),
                    Text(Formatter.getDateString(item.startDate)),
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
