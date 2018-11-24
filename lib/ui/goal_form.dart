import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/model/goal.dart';

class GoalForm extends StatefulWidget {
  final String documentId;

  GoalForm({this.documentId});

  @override
  _GoalFormState createState() => _GoalFormState();
}

class _GoalFormState extends State<GoalForm> {
  /// Variable
  final GlobalKey<FormState> _goalFormKey = GlobalKey<FormState>();
  bool _isAutoValidate = false;
  Goal item;

  /// Business process
  Future _savePressed() async {
    final form = _goalFormKey.currentState;
    if (form.validate()) {
      form.save();
      if (widget.documentId == null) {
        DataFeeder.instance.addNewGoal(item);
      } else {
        DataFeeder.instance.overwriteGoal(widget.documentId, item);
      }
      Navigator.pop(this.context);
    } else {
      _isAutoValidate = true;
    }
  }

  /// Build layout
  @override
  Widget build(BuildContext context) {
    if (widget.documentId == null) {
      item = Goal();
      return _buildForm();
    } else {
      return StreamBuilder(
        stream: DataFeeder.instance.getGoal(widget.documentId),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

          item = Goal.fromJson(json.decode(json.encode(snapshot.data.data)));

          return _buildForm();
        },
      );
    }
  }

  Widget _buildForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goal'),
        elevation: 0.0,
        backgroundColor: Theme.Colors.mainColor,
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
                  initialValue: item == null ? null : item.title,
                  requiredIndicator: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Title of goal is required.';

                    return null;
                  },
                  onSaved: (value) => item.title = value,
                ),
                CardSettingsParagraph(
                  label: 'Description',
                  initialValue: item == null ? null : item.description,
                  onSaved: (value) => item.description = value,
                ),
                CardSettingsHeader(
                  label: 'Properties',
                ),
                CardSettingsListPicker(
                  label: 'Goal Type',
                  options: ActivityTypeEnum.types,
                  initialValue: item == null ? null : item.type,
                  onSaved: (value) => item.type = value,
                ),
                CardSettingsDatePicker(
                  label: 'Target Date',
                  initialValue: item == null ? null : item.targetDate,
                  onSaved: (value) {
                    item.targetDate = updateJustTime(TimeOfDay(hour: 23, minute: 59), value);
                  },
                ),
                CardSettingsHeader(
                  label: 'Measure',
                ),
                CardSettingsInt(
                  label: 'Target Value',
                  initialValue: item == null ? 0 : item.targetValue,
                  onSaved: (value) => item.targetValue = value,
                ),
                CardSettingsInt(
                  label: 'Starting Value',
                  initialValue: item == null ? 0 : item.startValue,
                  onSaved: (value) => item.startValue = value,
                ),
                CardSettingsText(
                  label: 'Unit',
                  hintText: 'Enter your goal unit',
                  initialValue: item == null ? null : item.unit,
                  onSaved: (value) => item.unit = value,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
