import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/model/coop.dart';
import 'package:successhunter/model/data_feeder.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/coop/coop_form.dart';
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

        // TODO: classify coop

        return CustomScrollView(
          slivers: <Widget>[
            _buildHeader(context, _buildInfoSection(context)),
            _buildSectionHeader(context, 'Goal on Process'),
            _buildSectionHeader(context, 'Attained Goal'),
            _buildSectionHeader(context, 'Failed Goal'),
            SliverFillRemaining(),
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
