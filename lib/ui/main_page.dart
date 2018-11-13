import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:successhunter/auth/auth.dart';
import 'package:successhunter/style/theme.dart' as Theme;

import 'package:successhunter/ui/home_page.dart';
import 'package:successhunter/ui/goal_page.dart';
import 'package:successhunter/ui/habit_page.dart';
import 'package:successhunter/ui/diary_page.dart';
import 'package:successhunter/ui/goal_form.dart';

import 'package:successhunter/utils/enum_dictionary.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser user;

  MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  TabChoice _choice;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _choice = choices[0];
    _tabController = TabController(length: choices.length, vsync: this);
    _tabController.addListener(_handleSelectedTab);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Business process

  void _handleSelectedTab() {
    setState(() {
      _choice = choices[_tabController.index];
    });
  }

  void _handlePopupMenuChoice(String choice) {
    // TODO: Implement here
    if (choice == MainPagePopupChoiceEnum.addGoal) {
      Navigator.push(
          this.context, MaterialPageRoute(builder: (context) => GoalForm()));
    } else {}

    print(choice);
  }

  /// Build layout

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.Colors.loginGradientEnd,
      appBar: AppBar(
        title: Text(_choice.title),
        backgroundColor: Theme.Colors.loginGradientStart,
        elevation: 0.0,
        actions: <Widget>[
          _buildActionButton(context, _choice),
        ],
      ),
      drawer: _buildDrawer(context),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          HomePage(),
          GoalPage(),
          HabitPage(),
          DiaryPage(),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        labelColor: Theme.Colors.tabItemSelected,
        unselectedLabelColor: Colors.white70,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorPadding: EdgeInsets.all(5.0),
        indicatorColor: Theme.Colors.tabItemSelected,
        tabs: choices.map((TabChoice choice) {
          return Tab(
            text: choice.title,
            icon: choice.icon,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Container(
                      width: 100.0,
                      height: 100.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(widget.user.photoUrl),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 150.0,
                    child: Text(
                      widget.user.displayName,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'WorkSansSemiBold',
                        fontWeight: FontWeight.bold,
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              gradient: Theme.Colors.primaryGradient,
            ),
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            title: Text('Log out'),
            onTap: () {
              Auth().signOut();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPopupMenu(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: _handlePopupMenuChoice,
      icon: Icon(Icons.add),
      itemBuilder: (BuildContext context) {
        return MainPagePopupChoiceEnum.choices.map((String choice) {
          return PopupMenuItem<String>(
            value: choice,
            child: Text(choice),
          );
        }).toList();
      },
    );
  }

  Widget _buildActionButton(BuildContext context, TabChoice choice) {
    Widget result;

    // TODO: Implement handler
    switch (choices.indexOf(choice)) {
      case 0:
        result = _buildPopupMenu(context);
        break;
      case 1:
        result = IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => GoalForm())),
        );
        break;
      case 2:
        result = IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          color: Colors.white,
          onPressed: null,
        );
        break;
      case 3:
        result = IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.white,
          ),
          color: Colors.white,
          onPressed: null,
        );
        break;
    }

    return result;
  }
}


