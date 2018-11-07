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
  final GlobalKey<FormState> _goalFormKey = GlobalKey<FormState>();
  bool _isAutoValidate = false;
  Goal item;

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
    return StreamBuilder(
      stream: DataFeeder.instance.getGoal(widget.documentId),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        item = Goal.fromJson(json.decode(json.encode(snapshot.data.data)));

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
                    ),
                    CardSettingsParagraph(
                      label: 'Description',
                      initialValue: item == null ? null : item.description,
                    ),
                    CardSettingsHeader(
                      label: 'Properties',
                    ),
                    CardSettingsListPicker(
                      label: 'Goal Type',
                      options: GoalTypeEnum.types,
                      initialValue: item == null ? null : item.type,
                    ),
                    CardSettingsDatePicker(
                      label: 'Target Date',
                      initialValue: item == null ? null : item.targetDate,
                    ),
                    CardSettingsHeader(
                      label: 'Measure',
                    ),
                    CardSettingsInt(
                      label: 'Target Value',
                      initialValue: item == null ? 0 : item.targetValue,
                    ),
                    CardSettingsInt(
                      label: 'Starting Value',
                      initialValue: item == null ? 0 : item.startValue,
                    ),
                    CardSettingsText(
                      label: 'Unit',
                      hintText: 'Enter your goal unit',
                      initialValue: item == null ? null : item.unit,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
