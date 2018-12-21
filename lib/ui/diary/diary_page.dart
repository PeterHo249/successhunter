import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/diary.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_sliver_persistent_header_delegate.dart';
import 'package:successhunter/ui/chart/pie_chart.dart';
import 'package:successhunter/ui/diary/diary_detail.dart';
import 'package:successhunter/ui/diary/diary_form.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/helper.dart' as Helper;

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  // Variable
  double screenHeight;
  double screenWidth;

  var diaries = List<DiaryDocument>();
  var manualDiaries = List<DiaryDocument>();
  var automatedDiaries = List<DiaryDocument>();

  final SlidableController slidableController = SlidableController();

  // Business

  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: DataFeeder.instance.getDairyList(),
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
                        MaterialPageRoute(builder: (context) => DiaryForm()));
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
                        'You don\'t have any note.\n Press + to create a new one.',
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

        diaries = snapshot.data.documents
            .map((documentSnapshot) => DiaryDocument(
                  item: Diary.fromJson(
                      json.decode(json.encode(documentSnapshot.data))),
                  documentId: documentSnapshot.documentID,
                ))
            .toList();

        automatedDiaries.clear();
        manualDiaries.clear();

        for (int i = 0; i < diaries.length; i++) {
          if (diaries[i].item.automated) {
            automatedDiaries.add(diaries[i]);
          } else {
            manualDiaries.add(diaries[i]);
          }
        }

        return CustomScrollView(
          slivers: <Widget>[
            _buildHeader(context, _buildInfoSection(context)),
            _buildSectionHeader(context, 'Your Note'),
            _buildDiaryList(context, manualDiaries),
            _buildSectionHeader(context, 'Automated Note'),
            _buildDiaryList(context, automatedDiaries),
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
      title: 'My Diary',
      image: AssetImage('assets/img/book.png'),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    int positiveCount = 0;
    int negativeCount = 0;

    for (int i = 0; i < diaries.length; i++) {
      if (diaries[i].item.positive) {
        positiveCount++;
      } else {
        negativeCount++;
      }
    }

    return Container(
      width: screenWidth,
      child: Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top + 20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                'You have ${manualDiaries.length} notes\nand ${automatedDiaries.length} automated notes.',
                style: Theme.contentStyle.copyWith(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
            ),
            PieChart(
              holeLabel: 'State',
              size: screenHeight * 0.2,
              data: <ChartEntry>[
                ChartEntry(
                  value: positiveCount.toDouble(),
                  color: Colors.green,
                ),
                ChartEntry(
                  value: negativeCount.toDouble(),
                  color: Colors.red,
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

  Widget _buildDiaryList(BuildContext context, List<DiaryDocument> docs) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return _buildDiarySlidableTile(context, docs[index]);
        },
        childCount: docs.length,
      ),
    );
  }

  Widget _buildDiarySlidableTile(BuildContext context, DiaryDocument document) {
    var item = document.item;

    return Slidable.builder(
      key: Key(item.title),
      delegate: SlidableDrawerDelegate(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      child: _buildDiaryTile(context, document),
      slideToDismissDelegate: SlideToDismissDrawerDelegate(
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0,
        },
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary) {
            DataFeeder.instance.deleteDiary(document.documentId);
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
                    builder: (context) => DiaryForm(
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
              DataFeeder.instance.deleteDiary(document.documentId);
            },
          );
        },
        actionCount: 1,
      ),
    );
  }

  Widget _buildDiaryTile(BuildContext context, DiaryDocument document) {
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
                return DiaryDetail(
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
                    Hero(
                      tag: document.documentId,
                      child: Helper.buildCircularIcon(
                        data: document.item.positive
                            ? TypeDecoration(
                                icon: FontAwesomeIcons.thumbsUp,
                                color: Colors.white,
                                backgroundColor: Colors.green,
                              )
                            : TypeDecoration(
                                icon: FontAwesomeIcons.thumbsDown,
                                color: Colors.white,
                                backgroundColor: Colors.red,
                              ),
                        size: 70.0,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0),
                      width: screenWidth - 110.0,
                      height: 100.0,
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
                            document.item.content,
                            style: Theme.contentStyle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
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
}
