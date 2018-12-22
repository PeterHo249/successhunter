import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/diary.dart';
import 'package:successhunter/ui/custom_ui/FAB_with_icon.dart';
import 'package:successhunter/ui/custom_ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/diary/diary_form.dart';
import 'package:successhunter/utils/formatter.dart';

class DiaryDetail extends StatefulWidget {
  final String documentId;

  DiaryDetail({this.documentId});

  @override
  _DiaryDetailState createState() => _DiaryDetailState();
}

class _DiaryDetailState extends State<DiaryDetail> {
  // Valriable
  Diary item;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  Color color;

  // Business
  void _fabIconPressed(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          this.context,
          MaterialPageRoute(
              builder: (context) => DiaryForm(
                    documentId: widget.documentId,
                  )),
        );
        break;
      case 1:
        Share.share('${item.title}: ${item.content}');
        break;
    }
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: DataFeeder.instance.getDairy(widget.documentId),
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
          item = Diary.fromJson(json.decode(json.encode(snapshot.data.data)));
          color = item.positive ? Colors.green : Colors.red;

          return Scaffold(
            floatingActionButton: FABWithIcons(
              icons: [
                Icons.edit,
                Icons.share,
              ],
              foregroundColor: Colors.white,
              backgroundColor: color,
              onIconTapped: _fabIconPressed,
              mainIcon: Icons.menu,
            ),
            body: CustomScrollView(
              slivers: <Widget>[
                _buildHeader(
                  context,
                  _buildInfoSection(context),
                ),
                SliverFillRemaining(
                  child: Container(
                    width: screenWidth - 30.0,
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      item.content,
                      style: Theme.contentStyle.copyWith(
                        fontSize: 20.0,
                      ),
                    ),
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
      title: 'Goal Detail',
      image: AssetImage('assets/img/book.png'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
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
                    'Date: ${Formatter.getDateString(item.date.toLocal())}',
                    style: Theme.contentStyle.copyWith(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.automated ? 'Auto-generated note' : '',
                    style: Theme.contentStyle.copyWith(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
