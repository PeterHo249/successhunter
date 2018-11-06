import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/model/goal.dart';

class GoalForm extends StatefulWidget {
  final Goal item;

  GoalForm({this.item});

  @override
  _GoalFormState createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  final GlobalKey<FormState> _goalFormKey = GlobalKey<FormState>();
  bool _isAutoValidate = false;

  Future _savePressed() async {
    final form = _goalFormKey.currentState;
    if (form.validate()) {
      Navigator.pop(this.context);
    } else {
      _isAutoValidate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Goal'),
        elevation: 0.0,
        backgroundColor: Theme.Colors.loginGradientStart,
        actions: <Widget>[
          IconButton(
            onPressed: _savePressed,
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: Theme.Colors.primaryGradient,
            ),
          ),
          Form(
            key: _goalFormKey,
            child: CardSettings(
              children: <Widget>[
                CardSettingsHeader(
                  label: 'Info',
                ),
                CardSettingsText(
                  label: 'Title',
                  hintText: 'Enter your goal title',
                  autovalidate: _isAutoValidate,
                  initialValue: widget.item == null ? null : widget.item.title,
                  requiredIndicator: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Title of goal is required.';

                    return null;
                  },
                ),
                CardSettingsParagraph(
                  label: 'Description',
                  initialValue: widget.item == null ? null : widget.item.description,
                ),
                CardSettingsHeader(
                  label: 'Properties',
                ),
                CardSettingsListPicker(
                  label: 'Goal Type',
                  options: GoalTypeEnum.types,
                  initialValue: widget.item == null ? null : widget.item.type,
                ),
                CardSettingsDatePicker(
                  label: 'Target Date',
                  initialValue: widget.item == null ? null : widget.item.targetDate,
                ),
                CardSettingsHeader(
                  label: 'Measure',
                ),
                CardSettingsInt(
                  label: 'Target Value',
                  initialValue: widget.item == null ? 0 : widget.item.targetValue,
                ),
                CardSettingsInt(
                  label: 'Starting Value',
                  initialValue: widget.item == null ? 0 : widget.item.startValue,
                ),
                CardSettingsText(
                  label: 'Unit',
                  hintText: 'Enter your goal unit',
                  initialValue: widget.item == null ? null : widget.item.unit,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
