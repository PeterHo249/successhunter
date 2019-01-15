import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share/share.dart';
import 'package:successhunter/model/coop.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/ui/coop/coop_form.dart';
import 'package:successhunter/ui/coop/coop_milestone_form.dart';
import 'package:successhunter/ui/custom_ui/FAB_with_icon.dart';
import 'package:successhunter/ui/custom_ui/custom_sliver_app_bar.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/formatter.dart';

class CoopDetail extends StatefulWidget {
  final String documentId;

  CoopDetail({this.documentId});

  _CoopDetailState createState() => _CoopDetailState();
}

class _CoopDetailState extends State<CoopDetail> {
  // Variable
  CoopGoal item;
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  Color color;

  // Business
  void _fabIconsPressed(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          this.context,
          MaterialPageRoute(
            builder: (context) => CoopMilestoneForm(
                  documentId: widget.documentId,
                ),
          ),
        );
        break;
      case 1:
        if (item.mainState == ActivityState.doing) {
          item.mainState = ActivityState.done;
          item.currentValue = item.targetValue;
          item.doneDate = DateTime.now().toUtc();
          gInfo.addExperience(this.context, 50);
          DataFeeder.instance.overwriteInfo(gInfo);
          DataFeeder.instance.overwriteCoop(widget.documentId, item);
        }
        break;
      case 2:
        Navigator.push(
          this.context,
          MaterialPageRoute(
            builder: (context) => CoopForm(
                  documentId: widget.documentId,
                ),
          ),
        );
        break;
      case 3:
        Share.share(
          'I\'m try to attain goal ${item.title} before ${Formatter.getDateString(item.targetDate)}. Do you want take it with me?',
        );
        break;
      default:
    }
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: DataFeeder.instance.getCoop(widget.documentId),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[
                _buildHeader(
                  context,
                  Container(),
                ),
                SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Something was wrong!',
                      style: Theme.contentStyle,
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          item =
              CoopGoal.fromJson(json.decode(json.encode(snapshot.data.data)));
          // TODO: Sort milestone

          color = TypeDecorationEnum
              .typeDecorations[ActivityTypeEnum.getIndex(item.type)]
              .backgroundColor;

          return Scaffold(
            floatingActionButton: FABWithIcons(
              icons: [
                Icons.outlined_flag,
                Icons.check,
                Icons.edit,
                Icons.share,
              ],
              foregroundColor: Colors.white,
              backgroundColor: color,
              onIconTapped: _fabIconsPressed,
              mainIcon: Icons.menu,
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                _buildHeader(
                  context,
                  _buildInfoSection(context),
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    _buildMilestoneList(context),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildHeader(BuildContext context, Widget child) {
    return CustomSliverAppBar(
      heroTag: widget.documentId,
      backgroundColor: color,
      foregroundColor: Colors.white,
      height: screenHeight * 0.3,
      width: screenWidth,
      flexibleChild: child,
      title: 'Co-op Goal Detail',
      image: AssetImage('assets/img/multitarget.png'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    int remainDay =
        item.targetDate.toLocal().difference(DateTime.now().toLocal()).inDays;

    if (remainDay < 0) {
      remainDay = 0;
    }

    return Container(
      width: screenWidth,
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                item.title,
                style: Theme.header2Style.copyWith(color: Colors.white),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Target date: ${Formatter.getDateString(item.targetDate)}\nRemain day: $remainDay\nType: ${item.type}\nStatus: ${Helper.getStateString(item.mainState)}',
                    style: Theme.contentStyle.copyWith(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  CircularPercentIndicator(
                    radius: screenHeight * 0.15,
                    percent: item.currentValue.toDouble() /
                        item.targetValue.toDouble(),
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.white,
                    lineWidth: 10.0,
                    center: Text(
                      '${(item.currentValue.toDouble() / item.targetValue.toDouble()) * 100.0}%',
                      style: Theme.contentStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildMilestoneList(BuildContext context) {
    final List<CoopMilestone> milestones = item.milestones;

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
              //DataFeeder.instance.overwriteGoal(widget.documentId, item);
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
                //item.completeMilestone(i);
                gInfo.addExperience(context, 10);
                DataFeeder.instance.overwriteInfo(gInfo);
                //DataFeeder.instance.overwriteGoal(widget.documentId, item);
                setState(() {});
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
                item.milestones.removeAt(i);
                //DataFeeder.instance.overwriteGoal(widget.documentId, item);
              },
            );
          },
          actionCount: 1,
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
                          //color: Helper.getStateColor(milestones[i].state),
                        ),
                        child: Icon(
                          Icons.do_not_disturb,
                          //Helper.getStateIcon(milestones[i].state),
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
