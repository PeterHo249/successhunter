import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/utils/formatter.dart';
import 'package:successhunter/ui/goal_form.dart';
import 'package:successhunter/ui/goal_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalPage extends StatefulWidget {
  @override
  GoalPageState createState() {
    return new GoalPageState();
  }
}

class GoalPageState extends State<GoalPage> {
  var documentIds = <String>[];
  var goals = <Goal>[
    Goal(
      title: 'First goal',
      startDate: DateTime.now(),
      targetDate: DateTime.parse('20181106'),
    ),
    Goal(
      title: 'Second goal',
      startDate: DateTime.now(),
      targetDate: DateTime.parse('20181206'),
    ),
    Goal(
      title: 'Third goal',
      targetDate: DateTime.parse('20190112'),
      targetValue: 300,
      currentValue: 40,
      unit: 'USD',
      type: GoalTypeEnum.finance,
      milestones: <Milestone>[
        Milestone(
          title: 'First milestone',
          targetValue: 20,
          targetDate: DateTime.parse('20181108'),
          isDone: true,
        ),
        Milestone(
          title: 'Second milestone',
          targetValue: 20,
          targetDate: DateTime.parse('20181110'),
        ),
        Milestone(
          title: 'Third milestone',
          targetValue: 20,
          targetDate: DateTime.parse('20181112'),
        ),
      ],
    ),
  ];

  // Slidable controller
  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataFeeder.instance.getGoalList(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        goals = snapshot.data.documents
            .map((documentSnapshot) =>
                Goal.fromJson(json.decode(json.encode(documentSnapshot.data))))
            .toList();

        documentIds = snapshot.data.documents
            .map((documentSnapshot) => documentSnapshot.documentID)
            .toList();

        return Container(
          decoration: BoxDecoration(
            gradient: Theme.Colors.primaryGradient,
          ),
          child: _buildSlidableList(context),
        );
      },
    );
  }

  Widget _buildItemTile(BuildContext context, int index) {
    Goal item = goals[index];
    return InkWell(
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GoalDetail(documentId: documentIds[index],),
            ),
          ),
      child: Card(
        elevation: 5.0,
        child: Container(
          height: 130.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                item.buildCircularIcon(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 280.0,
                        child: Text(
                          item.title,
                          style: TextStyle(
                              fontFamily: 'WorkSansBold', fontSize: 18.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 280.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('${item.targetValue} ${item.unit}'),
                            Text(
                                '${item.targetDate.difference(DateTime.now()).inDays} day(s) remain'),
                            Text('${Formatter.getDateString(item.targetDate)}'),
                          ],
                        ),
                      ),
                      LinearPercentIndicator(
                        width: 280.0,
                        percent: item.getDonePercent(),
                        backgroundColor: Colors.grey[300],
                        progressColor: TypeDecorationEnum
                            .typeDecorations[GoalTypeEnum.getIndex(item.type)]
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
      ),
    );
  }

  Widget _buildSlidableTile(BuildContext context, int index) {
    return Slidable(
      key: Key(goals[index].title),
      delegate: SlidableDrawerDelegate(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      child: _buildItemTile(context, index),
      slideToDismissDelegate: SlideToDismissDrawerDelegate(
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0,
        },
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary) {
            DataFeeder.instance.deleteGoal(documentIds[index]);
          }
        },
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalForm(documentId: documentIds[index],),
                ),
              ),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => print('deleted'),
        ),
      ],
    );
  }

  Widget _buildSlidableList(BuildContext context) {
    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return _buildSlidableTile(context, index);
      },
    );
  }
}
