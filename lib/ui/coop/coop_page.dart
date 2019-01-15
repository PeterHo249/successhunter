import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/model/coop.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/user.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/chart/pie_chart.dart';
import 'package:successhunter/ui/coop/coop_detail.dart';
import 'package:successhunter/ui/coop/coop_form.dart';
import 'package:successhunter/ui/coop/coop_participant.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/formatter.dart';
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/ui/custom_ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_ui/custom_sliver_persistent_header_delegate.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CoopPage extends StatefulWidget {
  @override
  _CoopPageState createState() => _CoopPageState();
}

class _CoopPageState extends State<CoopPage> {
  // Variable
  double screenHeight;
  double screenWidth;

  final SlidableController slidableController = SlidableController();

  var coops = <CoopDocument>[];
  var processCoops = <CoopDocument>[];
  var attainedCoops = <CoopDocument>[];
  var failedCoops = <CoopDocument>[];

  // Business

  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: DataFeeder.instance.getCoopList(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return CustomScrollView(
            slivers: <Widget>[
              _buildHeader(context, Container()),
              SliverFillRemaining(
                child: Center(
                  child: Helper.buildFlareLoading(),
                ),
              )
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
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => CoopForm()));
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
                        'You don\'t have any coop goal to attain.\nPress + to plan a new one.',
                        style: Theme.contentStyle.copyWith(
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        }

        coops = snapshot.data.documents
            .map((documentSnapshot) => CoopDocument(
                  item: CoopGoal.fromJson(
                      json.decode(json.encode(documentSnapshot.data))),
                  documentId: documentSnapshot.documentID,
                ))
            .toList();

        processCoops.clear();
        attainedCoops.clear();
        failedCoops.clear();

        for (int i = 0; i < coops.length; i++) {
          var coop = coops[i];
          if (coop.item.ownerUid == gInfo.uid) {
            // Own the goal
            switch (coop.item.mainState) {
              case ActivityState.doing:
                processCoops.add(coop);
                break;
              case ActivityState.done:
                attainedCoops.add(coop);
                break;
              case ActivityState.failed:
                failedCoops.add(coop);
                break;
              default:
            }
          } else {
            var state = coop.item.states
                .firstWhere((ParticipantState participantState) =>
                    participantState.uid == gInfo.uid)
                .state;
            switch (state) {
              case ActivityState.doing:
                processCoops.add(coop);
                break;
              case ActivityState.done:
                attainedCoops.add(coop);
                break;
              case ActivityState.failed:
                failedCoops.add(coop);
                break;
              default:
            }
          }
        }

        return CustomScrollView(
          slivers: <Widget>[
            _buildHeader(context, _buildInfoSection(context)),
            _buildSectionHeader(context, 'Goal on Process'),
            _buildCoopList(context, processCoops),
            _buildSectionHeader(context, 'Attained Goal'),
            _buildCoopList(context, attainedCoops),
            _buildSectionHeader(context, 'Failed Goal'),
            _buildCoopList(context, failedCoops),
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
      title: 'My Co-op Goal',
      image: AssetImage('assets/img/multitarget.png'),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    String infoString =
        'Total Goals: ${coops.length}\n\n${processCoops.length} goals in process\n${attainedCoops.length} attained goals\n${failedCoops.length} failed goals.';

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
                  value: processCoops.length.toDouble(),
                  color: Helper.getStateColor(ActivityState.doing),
                ),
                ChartEntry(
                  value: attainedCoops.length.toDouble(),
                  color: Helper.getStateColor(ActivityState.done),
                ),
                ChartEntry(
                  value: failedCoops.length.toDouble(),
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

  Widget _buildCoopList(BuildContext context, List<CoopDocument> docs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildCoopSlidableTile(context, docs[index]);
        },
        childCount: docs.length,
      ),
    );
  }

  Widget _buildCoopSlidableTile(BuildContext context, CoopDocument document) {
    var item = document.item;
    var _isOwner = document.item.ownerUid == gInfo.uid;

    return Slidable.builder(
      key: Key(item.title),
      delegate: SlidableDrawerDelegate(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      child: _buildCoopTile(context, document),
      slideToDismissDelegate: !_isOwner
          ? null
          : SlideToDismissDrawerDelegate(
              dismissThresholds: <SlideActionType, double>{
                  SlideActionType.primary: 1.0,
                },
              onDismissed: (actionType) {
                if (actionType == SlideActionType.secondary) {
                  DataFeeder.instance.deleteCoop(document.documentId);
                }
              }),
      actionDelegate: SlideActionBuilderDelegate(
        builder: (context, index, animation, renderingMode) {
          return IconSlideAction(
            caption: 'Edit',
            color: Colors.blue,
            icon: Icons.edit,
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CoopForm(
                          documentId: document.documentId,
                        ),
                  ),
                ),
          );
        },
        actionCount: _isOwner ? 1 : 0,
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
              DataFeeder.instance.deleteCoop(document.documentId);
            },
          );
        },
        actionCount: _isOwner ? 1 : 0,
      ),
    );
  }

  Widget _buildCoopTile(BuildContext context, CoopDocument document) {
    var _isOwner = document.item.ownerUid == gInfo.uid;
    var state = _isOwner
        ? document.item.mainState
        : document.item.states
            .firstWhere((ParticipantState state) => state.uid == gInfo.uid)
            .state;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CoopDetail(
                      documentId: document.documentId,
                    ),
              ),
            ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Container(
                height: 200.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 5.0),
                      child: Container(
                        height: 200.0,
                        width: 4.0,
                        color: Helper.getStateColor(state),
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
                    _buildCoopInfo(context, document),
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

  Widget _buildCoopInfo(BuildContext context, CoopDocument document) {
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
        height: 200.0,
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
              percent: document.item.getDonePercent(gInfo.uid),
            ),
            _buildImageRow(context, document),
          ],
        ),
      ),
    );
  }

  Widget _buildImageRow(BuildContext context, CoopDocument document) {
    var participantUids = document.item.participantUids;
    var _hasMore = false;
    if (participantUids.length > 4) {
      participantUids = participantUids.sublist(0, 3);
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
          '+${document.item.participantUids.length - 4} more',
          style: Theme.contentStyle.copyWith(color: Colors.grey),
        ),
      );
    }

    return InkWell(
      onTap: () => Navigator.push(
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
}
