import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:successhunter/style/theme.dart' as Theme;

class GoalForm extends StatefulWidget {
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
                    label: 'Basic Info',
                  ),
                  CardSettingsText(
                    label: 'Title',
                    hintText: 'Enter your goal title',
                    autovalidate: _isAutoValidate,
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
                  ),
                  CardSettingsHeader(
                    label: 'More Info',
                  ),
                  CardSettingsListPicker(
                    label: 'Goal Type',
                    options: <String>[
                      'Career',
                      'Health',
                      'Relationship',
                      'Finance',
                      'Family',
                      'Spirituality',
                      'Lifestyle',
                      'Other',
                    ],
                  ),
                  CardSettingsDatePicker(
                    label: 'Target Date',
                  ),
                  CardSettingsHeader(
                    label: 'Measure',
                  ),
                  CardSettingsInt(
                    label: 'Target Value',
                  ),
                  CardSettingsInt(
                    label: 'Starting Value',
                  ),
                  CardSettingsText(
                    label: 'Unit',
                    hintText: 'Enter your goal unit',
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
