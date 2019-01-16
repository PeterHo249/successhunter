import 'package:flutter/material.dart';
import 'package:successhunter/model/coop.dart';

class CoopAddParticipant extends StatefulWidget {
  final CoopDocument document;
  final Color color;

  CoopAddParticipant({this.document, this.color});

  _CoopAddParticipantState createState() => _CoopAddParticipantState();
}

class _CoopAddParticipantState extends State<CoopAddParticipant> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: widget.color,
      ),
      body: Container(
        color: Colors.green,
      ),
    );
  }
}