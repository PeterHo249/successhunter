
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_sliver_persistent_header_delegate.dart';

class GoalPage extends StatefulWidget {
  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
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
        _buildSectionHeader(context, 'Goal on Process'),
        _buildSectionHeader(context, 'Attained Goal'),
        _buildSectionHeader(context, 'Failed Goal'),
        SliverFillRemaining(),
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
      title: 'My Goal',
      image: AssetImage('assets/img/target.png'),
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

}

/*
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/helper.dart' as Helper;
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
        color: Helper.getStateBackgroundColor(item.state),
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

  Widget _buildSlidableTile(BuildContext context, int docIndex) {
    return Slidable.builder(
      key: Key(goals[docIndex].title),
      delegate: SlidableDrawerDelegate(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      child: _buildItemTile(context, docIndex),
      slideToDismissDelegate: SlideToDismissDrawerDelegate(
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0,
        },
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary) {
            DataFeeder.instance.deleteGoal(documentIds[docIndex]);
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
                          documentId: documentIds[docIndex],
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
              DataFeeder.instance.deleteGoal(documentIds[docIndex]);
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
*/
