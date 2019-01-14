import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:successhunter/model/coop.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_ui/FAB_with_icon.dart';
import 'package:successhunter/ui/custom_ui/custom_sliver_app_bar.dart';
import 'package:successhunter/utils/enum_dictionary.dart';

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


  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: DataFeeder.instance.getCoop(widget.documentId),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
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
          item = CoopGoal.fromJson(json.decode(json.encode(snapshot.data.data)));
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
              onIconTapped: null,
              mainIcon: Icons.menu,
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                _buildHeader(context, _buildInfoSection(context)),
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
    return Container();
  }

  List<Widget> _buildMilestoneList(BuildContext context) {
    return [Container()];
  }
}
