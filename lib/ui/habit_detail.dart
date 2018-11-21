import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/ui/habit_form.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/formatter.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';

class HabitDetail extends StatefulWidget {
  final String documentId;

  HabitDetail({this.documentId});

  @override
  _HabitDetailState createState() => _HabitDetailState();
}

class _HabitDetailState extends State<HabitDetail> {
  /// Variable
  Habit item;
  double screenWidth = 0.0;
  double screenHeight = 0.0;

  /// Business process
  void _handlePopupMenuChoice(String choice) {
    // TODO: Implement here
    switch (choice) {
      case HabitDetailPopupChoiceEnum.completeHabit:
        item.completeToday();
        DataFeeder.instance.overwriteHabit(widget.documentId, item);
        break;
      case HabitDetailPopupChoiceEnum.editHabit:
        Navigator.push(
          this.context,
          MaterialPageRoute(
              builder: (context) => HabitForm(
                    documentId: widget.documentId,
                  )),
        );
        break;
      case HabitDetailPopupChoiceEnum.shareHabit:
        Share.share(
          'I\'m working on habit ${item.title}. Do you want to do it with me?',
        );
        break;
    }

    print(choice);
  }

  /// Build layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: DataFeeder.instance.getHabit(widget.documentId),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData)
          return Container(
            decoration: BoxDecoration(
              gradient: Theme.Colors.primaryGradient,
            ),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );

        item = Habit.fromJson(json.decode(json.encode(snapshot.data.data)));

        return Scaffold(
          appBar: AppBar(
            title: Text('My Habit'),
            backgroundColor: Theme.Colors.loginGradientStart,
            elevation: 0.0,
            actions: <Widget>[
              _buildPopupMenu(context),
            ],
          ),
          body: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  gradient: Theme.Colors.primaryGradient,
                ),
              ),
              Card(
                color: Helper.getStateBackgroundColor(item.state),
                elevation: 5.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildBasicInfo(context),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        'Habit type: ${item.type}',
                        style: Theme.contentStyle,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 10.0,
                      ),
                      child: Text(
                        'Repetation type: ${item.repetationType}',
                        style: Theme.contentStyle,
                      ),
                    ),
                    _buildRepetationInfo(context),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Container(
                        child: CalendarCarousel(
                          daysHaveCircularBorder: true,
                          height: 450.0,
                          markedDates: <DateTime>[
                            DateTime.parse('20181101'),
                            DateTime.parse('20181102')
                          ],
                          markedDateWidget: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBasicInfo(BuildContext context) {
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
              item.completeToday();
              DataFeeder.instance.overwriteHabit(widget.documentId, item);
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
                item.completeToday();
              }
              DataFeeder.instance.overwriteHabit(widget.documentId, item);
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

    return Card(
      color: Helper.getStateBackgroundColor(item.state),
      elevation: 0.0,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    item.buildCircularIcon(),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: SizedBox(
                        width: screenWidth - 100.0,
                        child: Text(
                          item.title,
                          style: Theme.header4Style,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
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
    );
  }

  Widget _buildRepetationInfo(BuildContext context) {
    Widget resultWidget = Container();

    switch (item.repetationType) {
      case RepetationTypeEnum.period:
        resultWidget = Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text(
            'Repeat after ${item.period} day(s)',
            style: Theme.contentStyle,
          ),
        );
        break;
      case RepetationTypeEnum.dayOfWeek:
        resultWidget = Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text(
                  'Days:',
                  style: Theme.contentStyle,
                ),
              ),
              Wrap(
                spacing: 20.0,
                runSpacing: 5.0,
                alignment: WrapAlignment.center,
                children: item.daysOfWeek.map((day) {
                  return FilterChip(
                    backgroundColor: Colors.grey[200],
                    label: Text(
                      day,
                      style: Theme.contentStyle,
                    ),
                    onSelected: (temp) {},
                  );
                }).toList(),
              ),
            ],
          ),
        );
        break;
    }

    return resultWidget;
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _handlePopupMenuChoice,
      icon: Icon(Icons.menu),
      itemBuilder: (BuildContext context) {
        return HabitDetailPopupChoiceEnum.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }
}
