import 'package:flutter/material.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/utils/formatter.dart';
import 'package:successhunter/ui/goal_form.dart';
import 'package:successhunter/ui/goal_detail.dart';

class GoalPage extends StatefulWidget {
  @override
  GoalPageState createState() {
    return new GoalPageState();
  }
}

class GoalPageState extends State<GoalPage> {
  final goals = <Goal>[
    Goal(
      title: 'First goal',
      startDate: DateTime.now(),
      targetDate: DateTime.parse('20181106'),
    ),
    Goal(
      title: 'Second goal',
      startDate: DateTime.now(),
      targetDate: DateTime.parse('20181206'),
    ),
    Goal(
      title: 'Third goal',
      targetDate: DateTime.parse('20190112'),
      targetValue: 300,
      currentValue: 40,
      unit: 'USD',
      type: GoalTypeEnum.finance,
    ),
  ];

  // Slidable controller
  final SlidableController slidableController = SlidableController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.Colors.primaryGradient,
      ),
      child: _buildSlidableList(context),
    );
  }

  Widget _buildItemTile(BuildContext context, int index) {
    Goal item = goals[index];
    return InkWell(
      onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GoalDetail(item: item),
            ),
          ),
      child: Card(
        elevation: 5.0,
        child: Container(
          height: 130.0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                item.buildCircularIcon(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 280.0,
                        child: Text(
                          item.title,
                          style: TextStyle(
                              fontFamily: 'WorkSansBold', fontSize: 18.0),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        width: 280.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('${item.targetValue} ${item.unit}'),
                            Text(
                                '${item.targetDate.difference(DateTime.now()).inDays} day(s) remain'),
                            Text('${Formatter.getDateString(item.targetDate)}'),
                          ],
                        ),
                      ),
                      LinearPercentIndicator(
                        width: 280.0,
                        percent: item.getDonePercent(),
                        backgroundColor: Colors.grey[300],
                        progressColor: TypeDecorationEnum
                            .typeDecorations[GoalTypeEnum.getIndex(item.type)]
                            .backgroundColor,
                        animation: true,
                        animationDuration: 1000,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlidableTile(BuildContext context, int index) {
    return Slidable(
      key: Key(goals[index].title),
      delegate: SlidableDrawerDelegate(),
      controller: slidableController,
      actionExtentRatio: 0.25,
      child: _buildItemTile(context, index),
      slideToDismissDelegate: SlideToDismissDrawerDelegate(
        dismissThresholds: <SlideActionType, double>{
          SlideActionType.primary: 1.0,
        },
        onDismissed: (actionType) {
          print(actionType == SlideActionType.primary ? 'Edit' : 'Delete');
        },
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalForm(item: goals[index]),
                ),
              ),
        ),
      ],
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => print('deleted'),
        ),
      ],
    );
  }

  Widget _buildSlidableList(BuildContext context) {
    return ListView.builder(
      itemCount: goals.length,
      itemBuilder: (context, index) {
        return _buildSlidableTile(context, index);
      },
    );
  }

}
