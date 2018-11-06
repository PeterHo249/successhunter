import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:successhunter/model/goal.dart';
import 'package:successhunter/style/theme.dart' as Theme;

class MilestoneForm extends StatefulWidget {
  final Milestone item;

  MilestoneForm({this.item});

  @override
  _MilestoneFormState createState() => _MilestoneFormState();
}

class _MilestoneFormState extends State<MilestoneForm> {
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
                      return 'Title of milestone is required.';

                    return null;
                  },
                ),
                CardSettingsParagraph(
                  label: 'Description',
                  initialValue: widget.item == null ? null : widget.item.description,
                ),
                CardSettingsHeader(
                  label: 'Target',
                ),
                CardSettingsInt(
                  label: 'Value',
                  initialValue: widget.item == null ? 0 : widget.item.targetValue,
                ),
                CardSettingsDatePicker(
                  label: 'Date',
                  initialValue: widget.item == null ? null : widget.item.targetDate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
