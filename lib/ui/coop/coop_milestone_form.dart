import 'dart:convert';

import 'package:card_settings/card_settings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:successhunter/model/coop.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/style/theme.dart' as Theme;

class CoopMilestoneForm extends StatefulWidget {
  final String documentId;
  final int index;

  CoopMilestoneForm({this.documentId, this.index});

  _CoopMilestoneFormState createState() => _CoopMilestoneFormState();
}

class _CoopMilestoneFormState extends State<CoopMilestoneForm> {
  // Variable
  final GlobalKey<FormState> _milestoneFormKey = GlobalKey<FormState>();
  bool _isAutoValidate = false;
  CoopGoal coopItem;
  CoopMilestone milestoneItem;

  // Bussiness
  Future _savePressed() async {
    final form = _milestoneFormKey.currentState;
    if (form.validate()) {
      form.save();
      if (widget.index == null) {
        /// TODO: add new milestone
      } else {
        /// TODO: modify milestone
      }

      Navigator.pop(this.context);
    } else {
      _isAutoValidate = true;
    }
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: DataFeeder.instance.getCoop(widget.documentId),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container(
            child: Center(
              child: Helper.buildFlareLoading(),
            ),
          );
        }

        coopItem =
            CoopGoal.fromJson(json.decode(json.encode(snapshot.data.data)));

        if (widget.index == null) {
          milestoneItem = CoopMilestone();
        } else {
          milestoneItem = coopItem.milestones[widget.index];
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
        backgroundColor: Theme.Colors.mainColor,
        actions: <Widget>[
          IconButton(
            onPressed: _savePressed,
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
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
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Title of milestone is required.';
                    }

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
                      milestoneItem == null ? null : milestoneItem.targetValue,
                  onSaved: (value) => milestoneItem.targetValue = value,
                ),
                CardSettingsDatePicker(
                  label: 'Date',
                  initialValue:
                      milestoneItem == null ? null : milestoneItem.targetDate,
                  onSaved: (value) => milestoneItem.targetDate =
                      updateJustTime(TimeOfDay(hour: 23, minute: 59), value)
                          .toUtc(),
                  autovalidate: true,
                  validator: (DateTime value) {
                    if (value.isBefore(coopItem.startDate.toLocal())) {
                      return 'This has to be greater than goal\'s start date.';
                    }

                    if (value.isAfter(coopItem.targetDate.toLocal())) {
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
