
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_sliver_persistent_header_delegate.dart';

class DiaryPage extends StatefulWidget {
  @override
  _DiaryPageState createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
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
      title: 'My Diary',
      image: AssetImage('assets/img/book.png'),
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