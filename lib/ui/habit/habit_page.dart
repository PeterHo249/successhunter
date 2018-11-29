
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/custom_sliver_persistent_header_delegate.dart';

class HabitPage extends StatefulWidget {
  @override
  _HabitPageState createState() => _HabitPageState();
}

class _HabitPageState extends State<HabitPage> {
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
        _buildSectionHeader(context, 'Today Task'),
        _buildSectionHeader(context, 'Attained Today'),
        _buildSectionHeader(context, 'Failed Today'),
        _buildSectionHeader(context, 'Not Today'),
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
      title: 'My Habit',
      image: AssetImage('assets/img/calendar.png'),
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


/*
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/ui/habit_detail.dart';
import 'package:successhunter/ui/habit_form.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/formatter.dart';

class HabitPage extends StatefulWidget {
  @override
  HabitPageState createState() {
    return new HabitPageState();
  }
}

class HabitPageState extends State<HabitPage> {
  /// Variable
  List<Habit> habits = <Habit>[
    Habit(
      title: 'First task',
    ),
    Habit(
      title: 'Second task',
      isYesNoTask: false,
    ),
  ];

  final SlidableController slidableController = SlidableController();
  double screenWidth = 0.0;
  double screenHeight = 0.0;
  List<String> documentIds = <String>[];

  /// Business process

  /// Build layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: Theme.Colors.primaryGradient,
      ),
      child: StreamBuilder(
        stream: DataFeeder.instance.getHabitList(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data.documents.length == 0) {
            return InkWell(
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HabitForm(),
                  ),
                );
                setState(() {});
              },
              child: Center(
                child: Container(
                  height: 150.0,
                  width: screenWidth - 20,
                  child: Card(
                    elevation: 5.0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(
                            Icons.add,
                            size: 60.0,
                            color: Colors.black45,
                          ),
                        ),
                        Text(
                          'Plan a new habit!',
                          style: Theme.contentStyle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }

          habits = snapshot.data.documents
              .map((documentSnapshot) => Habit.fromJson(
                  json.decode(json.encode(documentSnapshot.data))))
              .toList();

          documentIds = snapshot.data.documents
              .map((documentSnapshot) => documentSnapshot.documentID)
              .toList();

          return _buildSlidableList(context);
        },
      ),
    );
  }

  Widget _buildSlidableList(BuildContext context) {
    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return _buildSlidableTile(context, index);
      },
    );
  }

  Widget _buildSlidableTile(BuildContext context, int docIndex) {
    var item = habits[docIndex];
    return Slidable.builder(
      key: Key(item.title),
      delegate: SlidableDrawerDelegate(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      child: _buildItemTile(context, docIndex),
      slideToDismissDelegate: SlideToDismissDrawerDelegate(
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0,
        },
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary) {
            DataFeeder.instance.deleteHabit(documentIds[docIndex]);
          }
        },
      ),
      actionDelegate: SlideActionBuilderDelegate(
        builder: (context, index, animation, renderingMode) {
          return IconSlideAction(
            caption: 'Edit',
            color: Colors.blue,
            icon: Icons.edit,
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HabitForm(
                            documentId: documentIds[docIndex],
                          )));
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
              DataFeeder.instance.deleteHabit(documentIds[docIndex]);
            },
          );
        },
        actionCount: 1,
      ),
    );
  }

  Widget _buildItemTile(BuildContext context, int index) {
    Habit item = habits[index];

    Widget secondRow;

    if (item.isYesNoTask) {
      secondRow = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'Due time: ${Formatter.getTimeString(item.dueTime)}',
            style: Theme.contentStyle,
          ),
          InkWell(
            onTap: item.state != ActivityState.doing ? null : () {
              item.completeToday();
              DataFeeder.instance.overwriteHabit(documentIds[index], item);
              setState(() {});
            },
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.state == ActivityState.done
                    ? Colors.green
                    : Colors.amber,
              ),
              child: Icon(
                item.state == ActivityState.done ? Icons.check : Icons.remove,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      secondRow = Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Due time: ${Formatter.getTimeString(item.dueTime)}',
                style: Theme.contentStyle,
              ),
              Text(
                '${item.currentValue}/${item.targetValue} ${item.unit}',
                style: Theme.contentStyle,
              ),
            ],
          ),
          Slider(
            value: item.currentValue.toDouble(),
            onChanged: item.state != ActivityState.doing ? null : (value) {
              item.currentValue = value.toInt();
              if (item.currentValue == item.targetValue) {
                item.completeToday();
              }
              DataFeeder.instance.overwriteHabit(documentIds[index], item);
              setState(() {});
            },
            divisions: item.targetValue,
            min: 0.0,
            max: item.targetValue.toDouble(),
            activeColor: Colors.blue[500],
          ),
        ],
      );
    }

    return InkWell(
      onTap: () async {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HabitDetail(
                  documentId: documentIds[index],
                ),
          ),
        );
        setState(() {});
      },
      child: Card(
        color: Helper.getStateBackgroundColor(item.state),
        elevation: 5.0,
        child: Container(
          height: 130.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: SizedBox(
                    width: screenWidth - 50,
                    child: Text(
                      item.title,
                      style: Theme.header4Style,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: secondRow,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
*/
