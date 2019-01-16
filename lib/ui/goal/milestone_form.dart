import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/helper.dart' as Helper;

class MilestoneForm extends StatefulWidget {
  final String documentId;
  final int index;
  final Color color;

  MilestoneForm({this.documentId, this.index, this.color});

  @override
  _MilestoneFormState createState() => _MilestoneFormState();
}

class _MilestoneFormState extends State<MilestoneForm> {
  /// Variable
  final GlobalKey<FormState> _milestoneFormKey = GlobalKey<FormState>();
  bool _isAutoValidate = false;
  Goal goalItem;
  Milestone milestoneItem;

  /// Business process
  Future _savePressed() async {
    final form = _milestoneFormKey.currentState;
    if (form.validate()) {
      form.save();
      if (widget.index == null) {
        goalItem.milestones.add(milestoneItem);
      } else {
        goalItem.milestones[widget.index] = milestoneItem;
      }
      DataFeeder.instance.overwriteGoal(widget.documentId, goalItem);
      Navigator.pop(this.context);
    } else {
      _isAutoValidate = true;
    }
  }

  /// Build layout
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataFeeder.instance.getGoal(widget.documentId),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData)
          return Container(
            child: Center(
              child: Helper.buildFlareLoading(),
            ),
          );

        goalItem = Goal.fromJson(json.decode(json.encode(snapshot.data.data)));

        if (widget.index == null) {
          milestoneItem = Milestone();
        } else {
          milestoneItem = goalItem.milestones[widget.index];
        }

        return _buildForm();
      },
    );
  }

  Widget _buildForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Milestone'),
        elevation: 0.0,
        backgroundColor: widget.color,
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
          Helper.buildHeaderBackground(
            context,
            color: widget.color,
          ),
          Form(
            key: _milestoneFormKey,
            child: CardSettings(
              children: <Widget>[
                CardSettingsHeader(
                  label: 'Info',
                ),
                CardSettingsText(
                  label: 'Title',
                  hintText: 'Enter your milestone title',
                  autovalidate: _isAutoValidate,
                  initialValue:
                      milestoneItem == null ? null : milestoneItem.title,
                  requiredIndicator: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Title of milestone is required.';

                    return null;
                  },
                  onSaved: (value) => milestoneItem.title = value,
                ),
                CardSettingsParagraph(
                  label: 'Description',
                  initialValue:
                      milestoneItem == null ? null : milestoneItem.description,
                  onSaved: (value) => milestoneItem.description = value,
                ),
                CardSettingsHeader(
                  label: 'Target',
                ),
                CardSettingsInt(
                  label: 'Value',
                  initialValue:
                      milestoneItem == null ? 0 : milestoneItem.targetValue,
                  onSaved: (value) => milestoneItem.targetValue = value,
                ),
                CardSettingsDatePicker(
                  label: 'Date',
                  initialValue: milestoneItem == null
                      ? null
                      : milestoneItem.targetDate.toLocal(),
                  onSaved: (value) => milestoneItem.targetDate =
                      updateJustTime(TimeOfDay(hour: 23, minute: 59), value)
                          .toUtc(),
                  autovalidate: true,
                  validator: (DateTime value) {
                    if (value.isBefore(goalItem.startDate.toLocal())) {
                      return 'This has to be greater than goal\'s start date.';
                    }

                    if (value.isAfter(goalItem.targetDate.toLocal())) {
                      return 'This has to be less than goal\'s target date.';
                    }

                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
