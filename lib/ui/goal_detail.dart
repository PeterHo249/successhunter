import 'package:flutter/material.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/goal_form.dart';
import 'package:successhunter/ui/milestone_form.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:successhunter/utils/formatter.dart';

class GoalDetail extends StatefulWidget {
  final Goal item;

  GoalDetail({this.item});

  @override
  _GoalDetailState createState() => _GoalDetailState();
}

class _GoalDetailState extends State<GoalDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Goal'),
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
            elevation: 5.0,
            child: Container(
              height: 130.0,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    widget.item.buildCircularIcon(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 280.0,
                            child: Text(
                              widget.item.title,
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
                                Text(
                                    '${widget.item.targetValue} ${widget.item.unit}'),
                                Text(
                                    '${widget.item.targetDate.difference(DateTime.now()).inDays} day(s) remain'),
                                Text(
                                    '${Formatter.getDateString(widget.item.targetDate)}'),
                              ],
                            ),
                          ),
                          LinearPercentIndicator(
                            width: 280.0,
                            percent: widget.item.getDonePercent(),
                            backgroundColor: Colors.grey[300],
                            progressColor: TypeDecorationEnum
                                .typeDecorations[
                                    GoalTypeEnum.getIndex(widget.item.type)]
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
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _handlePopupMenuChoice,
      icon: Icon(Icons.menu),
      itemBuilder: (BuildContext context) {
        return GoalDetailPopupChoiceEnum.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  void _handlePopupMenuChoice(String choice) {
    // TODO: Implement here
    switch (choice) {
      case GoalDetailPopupChoiceEnum.addMilestone:
        Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => MilestoneForm()),
        );
        break;
      case GoalDetailPopupChoiceEnum.completeGoal:
        break;
      case GoalDetailPopupChoiceEnum.editGoal:
        Navigator.push(
          this.context,
          MaterialPageRoute(builder: (context) => GoalForm(item: widget.item)),
        );
        break;
      case GoalDetailPopupChoiceEnum.shareGoal:
        break;
    }

    print(choice);
  }

  Widget _buildMilestoneList() {
    // TODO: Implement here
    return Container();
  }
}
