import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:share/share.dart';
import 'package:successhunter/model/coop.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/user.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/coop/coop_add_participant.dart';
import 'package:successhunter/ui/coop/coop_participant.dart';
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/ui/coop/coop_form.dart';
import 'package:successhunter/ui/coop/coop_milestone_form.dart';
import 'package:successhunter/ui/custom_ui/FAB_with_icon.dart';
import 'package:successhunter/ui/custom_ui/custom_sliver_app_bar.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/formatter.dart';
import 'package:folding_cell/folding_cell.dart';

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
  bool _isOwner = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Business
  void _fabIconsPressed(int index) {
    switch (index) {
      case 0:
        if (_isOwner) {
          Navigator.push(
            this.context,
            MaterialPageRoute(
              builder: (context) => CoopMilestoneForm(
                    documentId: widget.documentId,
                    color: color,
                  ),
            ),
          );
        } else {
          Helper.showInSnackBar(
            _scaffoldKey.currentState,
            'Only owner can add milestone.',
          );
        }
        break;
      case 1:
        item.completeCoop(gInfo.uid);
        gInfo.addExperience(context, 10);
        gInfo.addCoopCount(context);
        DataFeeder.instance.overwriteInfo(gInfo);
        DataFeeder.instance.overwriteCoop(widget.documentId, item);
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
      case 4:
        if (_isOwner) {
          Navigator.push(
            this.context,
            MaterialPageRoute(
              builder: (context) => CoopAddParticipant(
                    document: CoopDocument(
                      documentId: widget.documentId,
                      item: item,
                    ),
                    color: color,
                  ),
            ),
          );
        } else {
          Helper.showInSnackBar(
            _scaffoldKey.currentState,
            'Only owner can add participant.',
          );
        }
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
          item.milestones.sort((CoopMilestone a, CoopMilestone b) {
            return a.targetDate.compareTo(b.targetDate);
          });
          color = TypeDecorationEnum
              .typeDecorations[ActivityTypeEnum.getIndex(item.type)]
              .backgroundColor;
          _isOwner = gInfo.uid == item.ownerUid;

          return Scaffold(
            key: _scaffoldKey,
            floatingActionButton: FABWithIcons(
              icons: [
                Icons.outlined_flag,
                Icons.check,
                Icons.edit,
                Icons.share,
                Icons.person_add,
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
                    radius: screenHeight * 0.10,
                    percent: item.getDonePercent(gInfo.uid),
                    animation: true,
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: Colors.white,
                    lineWidth: 10.0,
                    center: Text(
                      '${item.getDonePercent(gInfo.uid) * 100.0}%',
                      style: Theme.contentStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: _buildImageRow(
                context,
                CoopDocument(
                  item: item,
                  documentId: widget.documentId,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageRow(BuildContext context, CoopDocument document,
      {int maxCount = 4, List<String> uid}) {
    var participantUids = uid ?? document.item.participantUids;
    var _hasMore = false;
    int _moreCount = 0;
    if (participantUids.length > maxCount) {
      _moreCount = participantUids.length - maxCount;
      participantUids = participantUids.sublist(0, maxCount - 1);
      _hasMore = true;
    }

    List<Widget> participantImages = <Widget>[];

    for (int i = 0; i < participantUids.length; i++) {
      var imageWidget = FutureBuilder(
        future: DataFeeder.instance.getInfoFuture(uid: participantUids[i]),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              height: 40.0,
              width: 40.0,
              color: Colors.grey,
            );
          }
          var info =
              User.fromJson(json.decode(json.encode(snapshot.data.data)));
          return Helper.buildCircularNetworkImage(
            url: info.photoUrl,
            size: 40,
          );
        },
      );

      participantImages.add(imageWidget);
    }

    if (_hasMore) {
      participantImages.add(
        Text(
          '+$_moreCount more',
          style: Theme.contentStyle.copyWith(color: Colors.grey),
        ),
      );
    }

    return InkWell(
      onTap: uid != null
          ? null
          : () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CoopParticipantList(
                        document: document,
                      ),
                ),
              ),
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: participantImages,
        ),
      ),
    );
  }

  List<Widget> _buildMilestoneList(BuildContext context) {
    final List<CoopMilestone> milestones = item.milestones;

    List<Widget> milestoneTiles = <Widget>[];

    for (int i = milestones.length - 1; i >= 0; i--) {
      var state = milestones[i]
          .states
          .firstWhere((ParticipantState state) => state.uid == gInfo.uid)
          .state;
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
              DataFeeder.instance.overwriteCoop(widget.documentId, item);
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
                item.completeMilestone(i, gInfo.uid);
                gInfo.addExperience(context, 10);
                DataFeeder.instance.overwriteInfo(gInfo);
                DataFeeder.instance.overwriteCoop(widget.documentId, item);
                setState(() {});
              },
            );
          },
          actionCount: state == ActivityState.doing ? 1 : 0,
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
                DataFeeder.instance.overwriteCoop(widget.documentId, item);
              },
            );
          },
          actionCount: state == ActivityState.doing ? 1 : 0,
        ),
        child: SimpleFoldingCell(
          padding: const EdgeInsets.all(0.0),
          cellSize: Size(screenWidth, 150.0),
          frontWidget: _buildFrontMilestoneTile(
            context,
            widget.documentId,
            item,
            i,
          ),
          innerTopWidget: _buildTopInnerMilestoneTile(
            context,
            widget.documentId,
            item,
            i,
          ),
          innerBottomWidget: _buildBottomInnerMilestoneTile(
            context,
            widget.documentId,
            item,
            i,
          ),
        ),
      );

      milestoneTiles.add(tile);
    }

    Widget startTile = Container(
      color: Colors.white,
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

  Widget _buildFrontMilestoneTile(
      BuildContext context, String documentId, CoopGoal item, int index) {
    final List<CoopMilestone> milestones = item.milestones;
    var state = milestones[index]
        .states
        .firstWhere((ParticipantState state) => state.uid == gInfo.uid)
        .state;
    List<String> doneUids = milestones[index]
        .states
        .where((ParticipantState state) => state.state == ActivityState.done)
        .map((ParticipantState state) => state.uid)
        .toList();

    return Container(
      color: Colors.white,
      height: 150.0,
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
                      color: Helper.getStateColor(state),
                    ),
                    child: Icon(
                      Helper.getStateIcon(state),
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
                    milestones[index].title,
                    style: Theme.header4Style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${milestones[index].targetValue} ${item.unit}',
                      style: Theme.contentStyle,
                    ),
                    Text(
                      Formatter.getDateString(milestones[index].targetDate),
                      style: Theme.contentStyle,
                    ),
                  ],
                ),
                doneUids.length == 0
                    ? Text(
                        'Nobody attained!',
                        style: Theme.contentStyle,
                      )
                    : _buildImageRow(
                        context,
                        CoopDocument(item: item, documentId: widget.documentId),
                        maxCount: 6,
                        uid: doneUids,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopInnerMilestoneTile(
      BuildContext context, String documentId, CoopGoal item, int index) {
    final List<CoopMilestone> milestones = item.milestones;
    var state = milestones[index]
        .states
        .firstWhere((ParticipantState state) => state.uid == gInfo.uid)
        .state;

    return Container(
      color: Colors.white,
      height: 150.0,
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
                      color: Helper.getStateColor(state),
                    ),
                    child: Icon(
                      Helper.getStateIcon(state),
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
                    milestones[index].title,
                    style: Theme.header4Style,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${milestones[index].targetValue} ${item.unit}',
                      style: Theme.contentStyle,
                    ),
                    Text(
                      Formatter.getDateString(milestones[index].targetDate),
                      style: Theme.contentStyle,
                    ),
                  ],
                ),
                Text(
                  'Participants:',
                  style: Theme.contentStyle.copyWith(fontSize: 18.0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomInnerMilestoneTile(
      BuildContext context, String documentId, CoopGoal item, int index) {
    final List<CoopMilestone> milestones = item.milestones;

    return Container(
      color: Colors.white,
      height: 150.0,
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
                ],
              ),
            ),
          ),
          _buildDoneListView(context, milestones[index].states)
        ],
      ),
    );
  }

  Widget _buildDoneListView(
      BuildContext context, List<ParticipantState> states) {
    return Container(
      width: screenWidth - 130.0,
      child: ListView(
        children: states.map((state) {
          return FutureBuilder(
            future: DataFeeder.instance.getInfoFuture(uid: state.uid),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Helper.buildFlareLoading(),
                      Divider(
                        color: Colors.blueGrey,
                      ),
                    ],
                  ),
                );
              }
              var info =
                  User.fromJson(json.decode(json.encode(snapshot.data.data)));

              return Container(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Helper.buildCircularNetworkImage(
                        url: info.photoUrl,
                        size: 50.0,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Text(
                          '${info.displayName}',
                          overflow: TextOverflow.ellipsis,
                          style: Theme.header2Style,
                        ),
                      ),
                      trailing: Helper.buildCircularIcon(
                        data: TypeDecoration(
                          icon: Helper.getStateIcon(state.state),
                          color: Colors.white,
                          backgroundColor: Helper.getStateColor(state.state),
                        ),
                        size: 30.0,
                      ),
                    ),
                    Divider(
                      color: Colors.blueGrey,
                    ),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
