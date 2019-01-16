import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:successhunter/model/coop.dart';
import 'package:successhunter/model/user.dart';
import 'package:http/http.dart' as http;

class CoopAddParticipant extends StatefulWidget {
  final CoopDocument document;
  final Color color;

  CoopAddParticipant({this.document, this.color});

  _CoopAddParticipantState createState() => _CoopAddParticipantState();
}

class _CoopAddParticipantState extends State<CoopAddParticipant> {
  List<CompactUser> users = List<CompactUser>();

  fetchData() async {
    var url =
        'https://us-central1-success-hunter-db.cloudfunctions.net/get_compact_user_info';

    var res = await http.get(url);
    List<Map<String, dynamic>> rawData = json.decode(res.body)['users'];
    users = rawData.map((Map<String, dynamic> rawUser) {
      return CompactUser.fromJson(rawUser);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

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
