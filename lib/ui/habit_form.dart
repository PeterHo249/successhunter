import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:successhunter/model/habit.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/enum_dictionary.dart';

class HabitForm extends StatefulWidget {
  _HabitFormState createState() => _HabitFormState();
}

class _HabitFormState extends State<HabitForm> {
  /// Variable
  final GlobalKey<FormState> _habitFormKey = GlobalKey<FormState>();
  bool _isAutoValidate = false;
  bool _isYesNo = false;
  String _repetationType;
  final List<String> days = const <String>[
                    'Monday',
                    'Tuesday',
                    'Wednesday',
                    'Thursday',
                    'Friday',
                    'Saturday',
                    'Sunday',
                  ];
  Habit item;

  /// Business process
  Future _savePressed() async {
    final form = _habitFormKey.currentState;
    if (form.validate()) {
      form.save();
    } else {
      _isAutoValidate = true;
    }
  }

  /// Build layout
  @override
  Widget build(BuildContext context) {
    return _buildForm();
  }

  Widget _buildForm() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habit'),
        elevation: 0.0,
        backgroundColor: Theme.Colors.loginGradientStart,
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
                ),
                CardSettingsParagraph(
                  label: 'Description',
                ),
                CardSettingsHeader(
                  label: 'Properties',
                ),
                CardSettingsListPicker(
                  label: 'Habit type',
                  options: ActivityTypeEnum.types,
                ),
                CardSettingsSwitch(
                  label: 'Yes/No Activity',
                  contentAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      _isYesNo = value;
                    });
                  },
                ),
                CardSettingsInt(
                  label: 'Target value',
                  visible: !_isYesNo,
                ),
                CardSettingsText(
                  label: 'Unit',
                  visible: !_isYesNo,
                ),
                CardSettingsTimePicker(
                  label: 'Due time',
                ),
                CardSettingsListPicker(
                  label: 'Repetation',
                  options: RepetationTypeEnum.types,
                  onChanged: (value) {
                    setState(() {
                      _repetationType = value;
                    });
                  },
                ),
                CardSettingsInt(
                  label: 'Every',
                  contentAlign: TextAlign.center,
                  unitLabel: 'day(s)',
                  visible: _repetationType == RepetationTypeEnum.period,
                ),
                CardSettingsMultiselect(
                  key: Key('multiselectkey'),
                  label: 'Choose day',
                  options: days,
                  initialValues: <String>['Monday'],
                  visible: _repetationType == RepetationTypeEnum.dayOfWeek,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
