import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/user.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/model/coop.dart';

class CoopParticipantList extends StatelessWidget {
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  final SlidableController slidableController = SlidableController();
  final CoopDocument document;

  CoopParticipantList({this.document});

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildHeader(context),
          _buildParticipantList(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: screenHeight * 0.2,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Theme.Colors.mainColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Participants',
          style: Theme.header1Style.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        background: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                width: screenWidth,
                height: screenHeight * 0.2,
                color: Colors.white,
              ),
              Helper.buildHeaderBackground(context, height: screenHeight * 0.2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParticipantList(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          return _buildParticipantTile(
            context,
            document.item.participantUids[index],
          );
        },
        childCount: document.item.participantUids.length,
      ),
    );
  }

  Widget _buildParticipantTile(BuildContext context, String uid) {
    bool _isOwner = document.item.ownerUid == gInfo.uid;

    return Slidable.builder(
      key: Key(uid),
      delegate: SlidableDrawerDelegate(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      slideToDismissDelegate: !_isOwner || uid == document.item.ownerUid
          ? null
          : SlideToDismissDrawerDelegate(
              dismissThresholds: <SlideActionType, double>{
                SlideActionType.primary: 1.0,
              },
              onDismissed: (actionType) {
                if (actionType == SlideActionType.secondary) {
                  document.item.removeParticipant(uid);
                  DataFeeder.instance
                      .overwriteCoop(document.documentId, document.item);
                }
              },
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
              document.item.removeParticipant(uid);
              DataFeeder.instance
                  .overwriteCoop(document.documentId, document.item);
            },
          );
        },
        actionCount: !_isOwner || uid == document.item.ownerUid ? 0 : 1,
      ),
      child: _buildParticipantInfo(context, uid),
    );
  }

  Widget _buildParticipantInfo(BuildContext context, String uid) {
    return FutureBuilder(
      future: DataFeeder.instance.getInfoFuture(uid: uid),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
        var info = User.fromJson(json.decode(json.encode(snapshot.data.data)));

        return Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: ListTile(
                  leading: Helper.buildCircularNetworkImage(
                    url: info.photoUrl,
                    size: 80.0,
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      '${info.displayName}',
                      overflow: TextOverflow.ellipsis,
                      style: Theme.header2Style,
                    ),
                  ),
                  subtitle: LinearPercentIndicator(
                    width: screenWidth - 200.0,
                    lineHeight: 10.0,
                    progressColor: TypeDecorationEnum
                        .typeDecorations[
                            ActivityTypeEnum.getIndex(document.item.type)]
                        .backgroundColor,
                    backgroundColor: Colors.grey,
                    percent: document.item.getDonePercent(uid),
                    trailing: Text(
                      '${document.item.getDonePercent(uid).toInt()}%',
                      style: Theme.contentStyle,
                    ),
                  ),
                  trailing: !(uid == document.item.ownerUid)
                      ? null
                      : Helper.buildCircularIcon(
                          data: TypeDecoration(
                            icon: Icons.star,
                            color: Colors.white,
                            backgroundColor: Theme.Colors.mainColor,
                          ),
                          size: 15.0,
                        ),
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
  }
}
