import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/ui/chart/pie_chart.dart';

import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_ui/custom_sliver_persistent_header_delegate.dart';
import 'package:successhunter/ui/goal/goal_detail.dart';
import 'package:successhunter/ui/goal/goal_form.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/formatter.dart';

class GoalPage extends StatefulWidget {
  @override
  _GoalPageState createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  // Variable
  double screenHeight;
  double screenWidth;

  final SlidableController slidableController = SlidableController();

  var goals = <GoalDocument>[];
  var processGoals = <GoalDocument>[];
  var attainedGoals = <GoalDocument>[];
  var failedGoals = <GoalDocument>[];

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

    return StreamBuilder(
      stream: DataFeeder.instance.getGoalList(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CustomScrollView(
            slivers: <Widget>[
              _buildHeader(context, Container()),
              SliverFillRemaining(
                child: Center(
                  child: Helper.buildFlareLoading(),
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
                        MaterialPageRoute(builder: (context) => GoalForm()));
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
                        'You don\'t have any goal to attain.\n Press + to plan a new one.',
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

        goals = snapshot.data.documents
            .map(
              (documentSnapshot) => GoalDocument(
                    item: Goal.fromJson(
                        json.decode(json.encode(documentSnapshot.data))),
                    documentId: documentSnapshot.documentID,
                  ),
            )
            .toList();

        processGoals.clear();
        attainedGoals.clear();
        failedGoals.clear();

        for (int i = 0; i < goals.length; i++) {
          switch (goals[i].item.state) {
            case ActivityState.doing:
              processGoals.add(goals[i]);
              break;
            case ActivityState.done:
              attainedGoals.add(goals[i]);
              break;
            case ActivityState.failed:
              failedGoals.add(goals[i]);
              break;
          }
        }

        return CustomScrollView(
          slivers: <Widget>[
            _buildHeader(context, _buildInfoSection(context)),
            _buildSectionHeader(context, 'Goal in Process'),
            _buildGoalList(context, processGoals),
            _buildSectionHeader(context, 'Attained Goal'),
            _buildGoalList(context, attainedGoals),
            _buildSectionHeader(context, 'Failed Goal'),
            _buildGoalList(context, failedGoals),
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
      title: 'My Goal',
      image: AssetImage('assets/img/target.png'),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    String infoString =
        'Total Goals: ${goals.length}\n\n${processGoals.length} goals in process\n${attainedGoals.length} attained goals\n${failedGoals.length} failed goals.';

    return Container(
      width: screenWidth,
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                infoString,
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
                  value: processGoals.length.toDouble(),
                  color: Helper.getStateColor(ActivityState.doing),
                ),
                ChartEntry(
                  value: attainedGoals.length.toDouble(),
                  color: Helper.getStateColor(ActivityState.done),
                ),
                ChartEntry(
                  value: failedGoals.length.toDouble(),
                  color: Helper.getStateColor(ActivityState.failed),
                ),
              ],
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

  Widget _buildGoalList(BuildContext context, List<GoalDocument> docs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildGoalSlidableTile(context, docs[index]);
        },
        childCount: docs.length,
      ),
    );
  }

  Widget _buildGoalSlidableTile(BuildContext context, GoalDocument document) {
    var item = document.item;

    return Slidable.builder(
      key: Key(item.title),
      delegate: SlidableDrawerDelegate(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      child: _buildGoalTile(context, document),
      slideToDismissDelegate: SlideToDismissDrawerDelegate(
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0,
        },
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary) {
            DataFeeder.instance.deleteGoal(document.documentId);
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
                          documentId: document.documentId,
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
              DataFeeder.instance.deleteGoal(document.documentId);
            },
          );
        },
        actionCount: 1,
      ),
    );
  }

  Widget _buildGoalTile(BuildContext context, GoalDocument document) {
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
        width: screenWidth - 110.0,
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
              width: screenWidth - 110.0,
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
