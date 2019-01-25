import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:share/share.dart';
import 'package:successhunter/model/user.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/ui/custom_ui/FAB_with_icon.dart';
import 'package:successhunter/ui/custom_ui/custom_sliver_app_bar.dart';
import 'package:successhunter/ui/habit/habit_form.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/formatter.dart';
import 'package:successhunter/utils/helper.dart' as Helper;

class HabitDetail extends StatefulWidget {
  final String documentId;

  HabitDetail({this.documentId});

  @override
  _HabitDetailState createState() => _HabitDetailState();
}

class _HabitDetailState extends State<HabitDetail> {
  // Variable
  Habit item;
  double screenHeight = 0.0;
  double screenWidth = 0.0;
  Color color;

  // Business
  @override
  void initState() {
    DataFeeder.instance.getInfo().listen(
      (documentSnapshot) {
        gInfo = User.fromJson(json.decode(json.encode(documentSnapshot.data)));
      },
    );
    super.initState();
  }

  void _fabIconPressed(int index) {
    switch (index) {
      case 0:
        if (item.state != ActivityState.doing) {
          break;
        }
        item.completeToday(context);
        gInfo.addExperience(this.context, 10);
        gInfo.addHabitCount(context);
        DataFeeder.instance.overwriteInfo(gInfo);
        DataFeeder.instance.overwriteHabit(widget.documentId, item);
        break;
      case 1:
        Navigator.push(
          this.context,
          MaterialPageRoute(
              builder: (context) => HabitForm(
                    documentId: widget.documentId,
                  )),
        );
        break;
      case 2:
        Share.share(
          'I\'m working on habit ${item.title}. Do you want to do it with me?',
        );
        break;
    }
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return StreamBuilder(
      stream: DataFeeder.instance.getHabit(widget.documentId),
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
          item = Habit.fromJson(json.decode(json.encode(snapshot.data.data)));
          color = TypeDecorationEnum
              .typeDecorations[ActivityTypeEnum.getIndex(item.type)]
              .backgroundColor;

          return Scaffold(
            floatingActionButton: FABWithIcons(
              icons: [
                Icons.check,
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
                _buildHabitDetail(context),
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
      title: 'Habit Detail',
      image: AssetImage('assets/img/calendar.png'),
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    String dueTimeInfo;

    switch (item.repetationType) {
      case RepetationTypeEnum.everyDay:
        dueTimeInfo =
            'Due every day at ${Formatter.getTimeString(item.dueTime)}';
        break;
      case RepetationTypeEnum.period:
        dueTimeInfo =
            'Due every ${item.period} day(s) at ${Formatter.getTimeString(item.dueTime)}';
        break;
      case RepetationTypeEnum.dayOfWeek:
        dueTimeInfo = 'Due every ';
        for (int i = 0; i < item.daysOfWeek.length; i++) {
          dueTimeInfo += '${item.daysOfWeek[i]} ';
        }
        dueTimeInfo += 'at ${Formatter.getTimeString(item.dueTime)}';
        break;
    }

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
                style: Theme.header2Style.copyWith(
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Container(
              width: screenWidth - 30.0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Type: ${item.type}',
                      style: Theme.contentStyle.copyWith(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(
                      width: screenHeight - 30.0,
                      child: Text(
                        dueTimeInfo,
                        textAlign: TextAlign.start,
                        style: Theme.contentStyle.copyWith(
                          color: Colors.white,
                          fontSize: 20.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHabitDetail(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          _buildIsDone(context),
          _buildStreakInfo(context),
          _buildStreakCalendar(context),
        ],
      ),
    );
  }

  Widget _buildIsDone(BuildContext context) {
    if (item.isYesNoTask) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 20.0,
        ),
        child: Container(
          width: screenWidth,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Status:',
                  style: Theme.contentStyle.copyWith(
                    fontSize: 20.0,
                  ),
                ),
                _buildCompleteButton(context),
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        width: screenWidth,
        height: 100.0,
        padding: EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Status:',
                  style: Theme.contentStyle.copyWith(
                    fontSize: 20.0,
                  ),
                ),
                Text(
                  '${item.currentValue}/${item.targetValue} ${item.unit}',
                  style: Theme.contentStyle.copyWith(
                    fontSize: 20.0,
                  ),
                ),
              ],
            ),
            Slider(
              value: item.currentValue.toDouble(),
              onChanged: (value) {
                item.currentValue = value.toInt();
                if (item.currentValue == item.targetValue) {
                  item.completeToday(context);
                  gInfo.addExperience(context, 10);
                  gInfo.addHabitCount(context);
                  DataFeeder.instance.overwriteInfo(gInfo);
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
        ),
      );
    }
  }

  Widget _buildCompleteButton(BuildContext context) {
    switch (item.state) {
      case ActivityState.doing:
        return InkWell(
          onTap: () {
            item.completeToday(context);
            gInfo.addExperience(context, 10);
            gInfo.addHabitCount(context);
            DataFeeder.instance.overwriteInfo(gInfo);
            DataFeeder.instance.overwriteHabit(widget.documentId, item);
          },
          child: Helper.buildCircularIcon(
            data: TypeDecoration(
              icon: Icons.remove,
              color: Colors.white,
              backgroundColor: Colors.amber,
            ),
            size: 30.0,
          ),
        );
      case ActivityState.done:
        return Helper.buildCircularIcon(
          data: TypeDecoration(
            icon: Icons.check,
            color: Colors.white,
            backgroundColor: Colors.green,
          ),
          size: 30.0,
        );
      case ActivityState.failed:
        return Helper.buildCircularIcon(
          data: TypeDecoration(
            icon: Icons.close,
            color: Colors.white,
            backgroundColor: Colors.red,
          ),
          size: 30.0,
        );
    }

    return Container();
  }

  Widget _buildStreakInfo(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15.0),
      width: screenWidth,
      height: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Current streak: ${item.currentStreak}',
            style: Theme.contentStyle.copyWith(
              fontSize: 20.0,
            ),
          ),
          Text(
            'Longest streak: ${item.longestStreak}',
            style: Theme.contentStyle.copyWith(
              fontSize: 20.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCalendar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: Container(
        child: CalendarCarousel(
          daysHaveCircularBorder: true,
          height: 450.0,
          markedDates: item.streak,
          markedDateWidget: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.green,
                width: 4.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
