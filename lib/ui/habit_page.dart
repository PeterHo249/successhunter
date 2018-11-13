import 'package:flutter/material.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/model/data_feeder.dart';

class HabitPage extends StatefulWidget {
  @override
  HabitPageState createState() {
    return new HabitPageState();
  }
}

class HabitPageState extends State<HabitPage> {
  /// Variable
  final habits = <Habit>[
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
      child: _buildSlidableList(context),
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
        dismissThresholds: <SlideActionType, double> {
          SlideActionType.primary: 1.0,
        },
        onDismissed: (actionType) {
          if (actionType == SlideActionType.secondary) {
            // TODO: implement here
          }
        },
      ),
      actionDelegate: SlideActionBuilderDelegate(
        builder: (context, index, animation, renderingMode) {
          return IconSlideAction(
            caption: 'Edit',
            color: Colors.blue,
            icon: Icons.edit,
            onTap: null,
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
              // TODO: Implement here
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
            'Due time: 19:00',
            style: Theme.contentStyle,
          ),
          Container(
            width: 30.0,
            height: 30.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
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
                'Due time: 19:00',
                style: Theme.contentStyle,
              ),
              Text(
                '8/10 times',
                style: Theme.contentStyle,
              ),
            ],
          ),
          Slider(
            value: 8.0,
            onChanged: null,
            divisions: 10,
            min: 0.0,
            max: 10.0,
            activeColor: Colors.blue[500],
          ),
        ],
      );
    }

    return InkWell(
      onTap: null,
      child: Card(
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
