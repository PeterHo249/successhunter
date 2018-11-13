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
  /// Variable
  var documentIds = <String>[];
  var goals = <Goal>[];
  final SlidableController slidableController = SlidableController();
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  /// Business process
  Color _getGoalStateColor(int state) {
    switch (state) {
      case ActivityState.done:
        return Colors.green[200];
      case ActivityState.doing:
        return Colors.white;
      case ActivityState.failed:
        return Colors.red[100];
    }

    return Colors.amber;
  }

  /// Build layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: Theme.Colors.primaryGradient,
      ),
      child: StreamBuilder(
        stream: DataFeeder.instance.getGoalList(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );

          if (snapshot.data.documents.length == 0) {
            return InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoalForm(),
                  ),
                );
                setState(() {});
              },
              child: Center(
                child: Container(
                  height: 150.0,
                  width: screenWidth - 20,
                  child: Card(
                    elevation: 5.0,
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

          return _buildSlidableList(context);
        },
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, int index) {
    Goal item = goals[index];

    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GoalDetail(
                  documentId: documentIds[index],
                ),
          ),
        );
        setState(() {});
      },
      child: Card(
        color: _getGoalStateColor(item.state),
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
                        width: screenWidth - 130.0,
                        child: Text(
                          item.title,
                          style: Theme.header4Style,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: screenWidth - 130.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                            .typeDecorations[ActivityTypeEnum.getIndex(item.type)]
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
    return Slidable.builder(
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
      actionDelegate: SlideActionBuilderDelegate(
        builder: (context, index, animation, renderingMode) {
          return IconSlideAction(
            caption: 'Edit',
            color: Colors.blue,
            icon: Icons.edit,
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GoalForm(
                          documentId: documentIds[index],
                        ),
                  ),
                ),
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
              DataFeeder.instance.deleteGoal(documentIds[index]);
            },
          );
        },
        actionCount: 1,
      ),
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
