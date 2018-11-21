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

  Widget _buildSlidableTile(BuildContext context, int index) {
    var item = habits[index];
    return Slidable.builder(
      key: Key(item.title),
      delegate: SlidableDrawerDelegate(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      child: _buildItemTile(context, index),
      slideToDismissDelegate: SlideToDismissDrawerDelegate(
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0,
        },
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary) {
            DataFeeder.instance.deleteHabit(documentIds[index]);
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
                            documentId: documentIds[index],
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
              DataFeeder.instance.deleteHabit(documentIds[index]);
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
            onTap: () {
              item.state = ActivityState.done;
              DataFeeder.instance.overwriteHabit(documentIds[index], item);
              setState(() {});
            },
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.state == ActivityState.doing
                    ? Colors.amber
                    : Colors.green,
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
            onChanged: (value) {
              item.currentValue = value.toInt();
              if (item.currentValue == item.targetValue) {
                item.state = ActivityState.done;
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
