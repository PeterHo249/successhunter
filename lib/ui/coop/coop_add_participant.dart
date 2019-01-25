import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:successhunter/model/coop.dart';
import 'package:successhunter/model/user.dart';
import 'package:http/http.dart' as http;
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/helper.dart' as Helper;
import 'package:successhunter/style/theme.dart' as Theme;

class CoopAddParticipant extends StatefulWidget {
  final CoopDocument document;
  final Color color;

  CoopAddParticipant({this.document, this.color});

  _CoopAddParticipantState createState() => _CoopAddParticipantState();
}

class _CoopAddParticipantState extends State<CoopAddParticipant> {
  // Variable
  List<CompactUser> users = List<CompactUser>();
  List<CompactUser> selectedUsers = List<CompactUser>();
  List<CompactUser> filteredUsers = List<CompactUser>();
  String _searchString = '';
  TextEditingController _searchController;
  bool _isSearching = false;

  Widget appBarTitle;
  Widget searchBar;

  // Business
  fetchData() async {
    var url =
        'https://us-central1-success-hunter-db.cloudfunctions.net/get_compact_user_info';

    var res = await http.get(url);
    if (res.statusCode == 200) {
      List<dynamic> rawData = json.decode(res.body)['users'];
      users = rawData.map((rawUser) {
        return CompactUser.fromJson(rawUser as Map<String, dynamic>);
      }).toList();
    } else {
      users = List<CompactUser>();
    }
    removeAlreadyParticipant();
    setState(() {});
  }

  void removeAlreadyParticipant() {
    for (int i = 0; i < widget.document.item.participantUids.length; i++) {
      users.removeWhere(
          (user) => user.uid == widget.document.item.participantUids[i]);
    }
    filteredUsers = users;
  }

  void removeSelected(String uid) {
    int index = selectedUsers.indexWhere((user) => user.uid == uid);
    users.add(selectedUsers[index]);
    selectedUsers.removeAt(index);
  }

  void addSelected(String uid) {
    var index = filteredUsers.indexWhere((user) => user.uid == uid);
    selectedUsers.add(filteredUsers[index]);
    filteredUsers.removeAt(index);
    users.removeWhere((user) => user.uid == uid);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    List<Widget> listViewChildren = List<Widget>();
    appBarTitle = InkWell(
      child: Text('Search'),
      onTap: () {
        setState(() {
          _isSearching = !_isSearching;
        });
      },
    );
    searchBar = TextField(
      autofocus: true,
      style: Theme.contentStyle.copyWith(
        color: Colors.white,
      ),
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: Theme.contentStyle.copyWith(
          color: Colors.white70,
        ),
      ),
      onChanged: (value) {
        if (value == null || value.isEmpty) {
          _searchString = '';
          filteredUsers = users;
        } else {
          _searchString = value.toLowerCase();
          filteredUsers = users
              .where((user) =>
                  user.displayName.toLowerCase().contains(_searchString))
              .toList();
        }
        setState(() {});
      },
    );

    if (selectedUsers.length != 0) {
      listViewChildren.add(Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Selected Users',
              style: Theme.header2Style.copyWith(
                color: Theme.Colors.mainColor,
              ),
            ),
            Divider(
              color: Theme.Colors.mainColor,
              height: 30.0,
              indent: 15.0,
            ),
          ],
        ),
      ));
    }
    listViewChildren.addAll(_buildUserList(
      context,
      selectedUsers,
      true,
    ));
    listViewChildren.add(Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Available Users',
            style: Theme.header2Style.copyWith(
              color: Theme.Colors.mainColor,
            ),
          ),
          Divider(
            color: Theme.Colors.mainColor,
            height: 30.0,
            indent: 15.0,
          ),
        ],
      ),
    ));
    if (filteredUsers.length != 0) {
      listViewChildren.addAll(_buildUserList(
        context,
        filteredUsers,
        false,
      ));
    } else {
      listViewChildren.add(Container(
        child: Center(
          child: Text(
            'No user available!',
            style: Theme.contentStyle.copyWith(
              fontSize: 20.0,
              color: Colors.grey,
            ),
          ),
        ),
      ));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: _isSearching ? searchBar : appBarTitle,
        backgroundColor: widget.color,
        actions: <Widget>[
          _buildSearchIcon(context),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: () {
              if (selectedUsers.isEmpty) {
                Navigator.pop(context);
              } else {
                var url =
                    'https://us-central1-success-hunter-db.cloudfunctions.net/invite_participants';
                Map<String, dynamic> reqBody = {
                  "inviterUid": gInfo.uid,
                  "coopId": widget.document.documentId,
                  "invitedUids": selectedUsers.map((user) => user.uid).toList(),
                };
                http.post(
                  url,
                  headers: {"Content-Type": "application/json"},
                  body: json.encode(reqBody),
                );
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: listViewChildren,
      ),
    );
  }

  List<Widget> _buildUserList(
      BuildContext context, List<CompactUser> users, bool isSelectedUsers) {
    List<Widget> tiles = List<Widget>();

    tiles = users.map((CompactUser user) {
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: Helper.buildCircularNetworkImage(
                url: user.photoUrl,
                size: 70.0,
              ),
              title: Text(
                user.displayName,
                style: Theme.header3Style,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              trailing: InkWell(
                onTap: () {
                  isSelectedUsers
                      ? removeSelected(user.uid)
                      : addSelected(user.uid);
                  setState(() {});
                },
                child: Helper.buildCircularIcon(
                  data: isSelectedUsers
                      ? TypeDecoration(
                          icon: Icons.remove,
                          backgroundColor: Colors.red,
                          color: Colors.white,
                        )
                      : TypeDecoration(
                          icon: Icons.add,
                          backgroundColor: Colors.green,
                          color: Colors.white,
                        ),
                  size: 40.0,
                ),
              ),
            ),
          ),
          Divider(
            color: Colors.blueGrey,
          ),
        ],
      );
    }).toList();

    return tiles;
  }

  Widget _buildSearchIcon(BuildContext context) {
    return IconButton(
      icon: _isSearching
          ? Icon(
              Icons.close,
              color: Colors.white,
            )
          : Icon(
              Icons.search,
              color: Colors.white,
            ),
      onPressed: () {
        if (_isSearching) {
          _searchController.clear();
          filteredUsers = users;
        }
        setState(() {
          _isSearching = !_isSearching;
        });
      },
    );
  }
}
