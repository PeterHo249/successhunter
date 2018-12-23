import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/helper.dart' as Helper;

class PinSetting extends StatefulWidget {
  @override
  PinSettingState createState() {
    return new PinSettingState();
  }
}

class PinSettingState extends State<PinSetting> {
  final GlobalKey<FormState> _pinFormKey = GlobalKey<FormState>();
  bool _isUsePin;
  bool _lastUsePinState;
  String _newPin = '';
  bool _autoValidateNewPin = false;
  bool _autoValidateConfirm = false;
  bool _autoValidateCurrent = false;
  String _currentPin ='';
  bool _isDirty = false;

  @override
  void initState() {
    _isUsePin = gInfo.diaryPin != null && gInfo.diaryPin.isNotEmpty;
    _lastUsePinState = _isUsePin;
    super.initState();
  }

  void _savePressed() {
    final form = _pinFormKey.currentState;
    if (form.validate()) {
      if (_isUsePin) {
        if (_currentPin == gInfo.diaryPin) {
          gInfo.diaryPin = _newPin;
          DataFeeder.instance.overwriteInfo(gInfo);
          Navigator.pop(context);
        } else {
          showDialog(
            context: this.context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Alert',
                  style: Theme.header2Style,
                ),
                content: Text('Please enter your current PIN correctly.'),
                actions: <Widget>[
                  RaisedButton(
                    child: Text(
                      'Ok',
                      style: Theme.header3Style.copyWith(color: Colors.white),
                    ),
                    color: Theme.Colors.mainColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        }
      } else {
        if (_currentPin == gInfo.diaryPin) {
          gInfo.diaryPin = '';
          DataFeeder.instance.overwriteInfo(gInfo);
          Navigator.pop(context);
        } else {
          showDialog(
            context: this.context,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  'Alert',
                  style: Theme.header2Style,
                ),
                content: Text('Please enter your current PIN correctly.'),
                actions: <Widget>[
                  RaisedButton(
                    child: Text(
                      'Ok',
                      style: Theme.header3Style.copyWith(color: Colors.white),
                    ),
                    color: Theme.Colors.mainColor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } else {
      setState(() {
        _autoValidateCurrent = true;
        _autoValidateNewPin = true;
        _autoValidateConfirm = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary PIN Setting'),
        elevation: 0.0,
        backgroundColor: Theme.Colors.mainColor,
        actions: <Widget>[
          IconButton(
            onPressed: _isDirty ? _savePressed : null,
            icon: Icon(
              Icons.save,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Helper.buildHeaderBackground(
            context,
            color: Theme.Colors.mainColor,
          ),
          Form(
            key: _pinFormKey,
            child: CardSettings(
              children: _buildFormChild(context),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFormChild(BuildContext context) {
    List<Widget> elements = <Widget>[];

    elements.add(
      CardSettingsSwitch(
        label: 'Use PIN',
        contentAlign: TextAlign.center,
        onChanged: (value) {
          setState(() {
            _isUsePin = value;
            _isDirty = true;
          });
        },
        initialValue: gInfo.diaryPin != null && gInfo.diaryPin.isNotEmpty,
      ),
    );

    elements.add(
      CardSettingsHeader(
        label: _isUsePin
            ? 'Setup your diary\'s PIN'
            : _lastUsePinState ? 'Confirm to disable PIN' : '',
      ),
    );

    if ((_isUsePin && _lastUsePinState) ||
        (_isUsePin == false && _lastUsePinState)) {
      elements.add(
        CardSettingsText(
          label: 'Current PIN',
          maxLength: 4,
          keyboardType: TextInputType.number,
          autovalidate: _autoValidateCurrent,
          onChanged: (value) {
            _currentPin = value;
          },
          validator: (value) {
            if (value == null || value.length != 4) {
              return 'Current PIN need 4 digits';
            }

            return null;
          },
        ),
      );
    }

    if (_isUsePin) {
      elements.add(
        CardSettingsText(
          label: 'New PIN',
          maxLength: 4,
          keyboardType: TextInputType.number,
          autovalidate: _autoValidateNewPin,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'New PIN is required.';
            }
            if (value.length != 4) {
              return 'PIN required 4 digits';
            }

            return null;
          },
          onChanged: (value) {
            setState(() {
              _isDirty = true;
              _newPin = value;
            });
          },
          onSaved: (value) {},
        ),
      );
    }

    if (_isUsePin) {
      elements.add(
        CardSettingsText(
          label: 'Confirm PIN',
          maxLength: 4,
          keyboardType: TextInputType.number,
          autovalidate: _autoValidateConfirm,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'PIN confirmation is required.';
            }
            if (value != _newPin) {
              return 'New PIN and confirmation have to be same.';
            }

            return null;
          },
          onChanged: (value) {
            _autoValidateConfirm = true;
          },
        ),
      );
    }

    return elements;
  }
}
