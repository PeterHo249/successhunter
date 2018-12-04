import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';

import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/helper.dart' as Helper;

class HabitForm extends StatefulWidget {
  final String documentId;

  HabitForm({this.documentId});

  @override
  _HabitFormState createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  /// Variable
  Habit item;
  Widget form;

  /// Business process

  /// Build layout
  @override
  Widget build(BuildContext context) {
    if (widget.documentId == null) {
      item = Habit();
      form = HabitFormWidget(
        item: item,
      );
      return form;
    } else {
      return StreamBuilder(
        stream: DataFeeder.instance.getHabit(widget.documentId),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData)
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );

          item = Habit.fromJson(json.decode(json.encode(snapshot.data.data)));

          form = HabitFormWidget(
            documentId: widget.documentId,
            item: item,
          );
          return form;
        },
      );
    }
  }
}

class HabitFormWidget extends StatefulWidget {
  final Habit item;
  final String documentId;

  HabitFormWidget({this.documentId, this.item});

  _HabitFormWidgetState createState() => _HabitFormWidgetState();
}

class _HabitFormWidgetState extends State<HabitFormWidget> {
  /// Variable
  final GlobalKey<FormState> _habitFormKey = GlobalKey<FormState>();
  bool _isAutoValidate = false;
  bool _isYesNo = false;
  String _repetationType;
  Color color;

  /// Business process
  Future _savePressed() async {
    final form = _habitFormKey.currentState;
    if (form.validate()) {
      form.save();
      if (widget.documentId == null) {
        DataFeeder.instance.addNewHabit(widget.item);
      } else {
        DataFeeder.instance.overwriteHabit(widget.documentId, widget.item);
      }
      Navigator.pop(this.context);
    } else {
      _isAutoValidate = true;
    }
  }

  @override
  void initState() {
    super.initState();
    _isYesNo = widget.item.isYesNoTask;
    _repetationType = widget.item.repetationType;
    color = TypeDecorationEnum
        .typeDecorations[ActivityTypeEnum.getIndex(widget.item.type)]
        .backgroundColor;
  }

  /// Build layout
  @override
  Widget build(BuildContext context) {
    return _buildForm(widget.item);
  }

  Widget _buildForm(Habit item) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit'),
        elevation: 0.0,
        backgroundColor: color,
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
          Hero(
            tag: widget.documentId ?? 'HeroTag',
            child: Helper.buildHeaderBackground(
              context,
              color: color,
            ),
          ),
          Form(
            key: _habitFormKey,
            child: CardSettings(
              children: <Widget>[
                CardSettingsHeader(
                  label: 'Info',
                ),
                CardSettingsText(
                  label: 'Title',
                  hintText: 'Enter you habit title',
                  autovalidate: _isAutoValidate,
                  requiredIndicator: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Title of habit is required.';

                    return null;
                  },
                  initialValue: item == null ? null : item.title,
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
                  label: 'Habit type',
                  options: ActivityTypeEnum.types,
                  initialValue: item == null ? null : item.type,
                  onChanged: (value) {
                    setState(() {
                      color = color = TypeDecorationEnum
                          .typeDecorations[ActivityTypeEnum.getIndex(value)]
                          .backgroundColor;
                    });
                  },
                  onSaved: (value) => item.type = value,
                ),
                CardSettingsSwitch(
                  label: 'Yes/No Activity',
                  contentAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      _isYesNo = value;
                    });
                  },
                  initialValue: item == null || item.isYesNoTask == null
                      ? false
                      : item.isYesNoTask,
                  onSaved: (value) => item.isYesNoTask = value,
                ),
                CardSettingsInt(
                  label: 'Target value',
                  visible: !_isYesNo,
                  initialValue: item == null || item.targetValue == null
                      ? 0
                      : item.targetValue,
                  onSaved: (value) => item.targetValue = value,
                ),
                CardSettingsText(
                  label: 'Unit',
                  visible: !_isYesNo,
                  initialValue: item == null ? null : item.unit,
                  onSaved: (value) => item.unit = value,
                ),
                CardSettingsTimePicker(
                  label: 'Due time',
                  initialValue: item == null
                      ? null
                      : TimeOfDay(
                          hour: item.dueTime.toLocal().hour,
                          minute: item.dueTime.toLocal().minute,
                        ),
                  onSaved: (value) => item.dueTime =
                      updateJustTime(value, item.dueTime).toUtc(),
                ),
                CardSettingsListPicker(
                  label: 'Repetation',
                  options: RepetationTypeEnum.types,
                  onChanged: (value) {
                    setState(() {
                      _repetationType = value;
                    });
                  },
                  initialValue: item == null ? null : item.repetationType,
                  onSaved: (value) => item.repetationType = value,
                ),
                CardSettingsInt(
                  label: 'Every',
                  contentAlign: TextAlign.center,
                  unitLabel: 'day(s)',
                  visible: _repetationType == RepetationTypeEnum.period,
                  initialValue:
                      item == null || item.period == null ? 0 : item.period,
                  onSaved: (value) => item.period = value,
                ),
                CardSettingsMultiselect(
                  key: Key('multiselectkey'),
                  label: 'Choose day',
                  options: DayOfWeekEnum.days,
                  initialValues: item == null || item.daysOfWeek == null
                      ? DayOfWeekEnum.days.toList()
                      : item.daysOfWeek,
                  visible: _repetationType == RepetationTypeEnum.dayOfWeek,
                  onSaved: (value) => item.daysOfWeek = value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
