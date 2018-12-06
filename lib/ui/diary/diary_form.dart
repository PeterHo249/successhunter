import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:card_settings/card_settings.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/diary.dart';
import 'package:successhunter/utils/helper.dart' as Helper;

class DiaryForm extends StatefulWidget {
  final String documentId;

  DiaryForm({this.documentId});

  @override
  _DiaryFormState createState() => _DiaryFormState();
}

class _DiaryFormState extends State<DiaryForm> {
  /// Variable
  Diary item;

  /// Business process

  @override
  void initState() {
    super.initState();
  }

  /// Build layout
  @override
  Widget build(BuildContext context) {
    if (widget.documentId == null) {
      item = Diary();
      return DiaryFormWidget(
        item: item,
      );
    } else {
      return StreamBuilder(
        stream: DataFeeder.instance.getDairy(widget.documentId),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          item = Diary.fromJson(json.decode(json.encode(snapshot.data.data)));

          return DiaryFormWidget(
            item: item,
            documentId: widget.documentId,
          );
        },
      );
    }
  }
}

class DiaryFormWidget extends StatefulWidget {
  final Diary item;
  final String documentId;

  DiaryFormWidget({this.item, this.documentId});

  @override
  _DiaryFormWidgetState createState() => _DiaryFormWidgetState();
}

class _DiaryFormWidgetState extends State<DiaryFormWidget> {
  // Variable
  final GlobalKey<FormState> _diaryFormKey = GlobalKey<FormState>();
  bool _isAutoValidate = false;
  Color color;

  // Business
  Future _savePressed() async {
    final form = _diaryFormKey.currentState;
    if (form.validate()) {
      form.save();
      if (widget.documentId == null) {
        DataFeeder.instance.addNewDiary(widget.item);
      } else {
        DataFeeder.instance.overwriteDiary(widget.documentId, widget.item);
      }
      Navigator.pop(this.context);
    } else {
      _isAutoValidate = true;
    }
  }

  @override
  void initState() {
    super.initState();
    color = widget.item.positive ? Colors.green : Colors.red;
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    return _buildForm(widget.item);
  }

  Widget _buildForm(Diary item) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diary'),
        elevation: 0.0,
        backgroundColor: color,
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
          Hero(
            tag: widget.documentId ?? 'HeroTag',
            child: Helper.buildHeaderBackground(
              context,
              color: color,
            ),
          ),
          Form(
            key: _diaryFormKey,
            child: CardSettings(
              children: <Widget>[
                CardSettingsHeader(
                  label: 'Note',
                ),
                CardSettingsText(
                  label: 'Title',
                  hintText: 'Enter your note title',
                  autovalidate: _isAutoValidate,
                  initialValue: item.title == null ? null : item.title,
                  requiredIndicator: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Title of note is required.';

                    return null;
                  },
                  onSaved: (value) => item.title = value,
                ),
                CardSettingsParagraph(
                  label: 'Content',
                  initialValue: item == null ? null : item.content,
                  onSaved: (value) => item.content = value,
                  requiredIndicator: Text(
                    '*',
                    style: TextStyle(color: Colors.red),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Content of note is required.';

                    return null;
                  },
                  autovalidate: _isAutoValidate,
                ),
                CardSettingsSwitch(
                  label: 'Is positive?',
                  contentAlign: TextAlign.center,
                  onChanged: (value) {
                    setState(() {
                      color = value ? Colors.green : Colors.red;
                    });
                  },
                  initialValue: item == null || item.positive == null
                      ? true
                      : item.positive,
                  onSaved: (value) => item.positive = value,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
