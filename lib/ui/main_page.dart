import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:successhunter/auth/auth.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:successhunter/ui/home_page.dart';
import 'package:successhunter/ui/goal_page.dart';
import 'package:successhunter/ui/habit_page.dart';
import 'package:successhunter/ui/diary_page.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser user;

  MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  Choice _choice;
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

  void _handleSelectedTab() {
    setState(() {
      _choice = choices[_tabController.index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.Colors.loginGradientEnd,
      appBar: AppBar(
        title: Text(_choice.title),
        backgroundColor: Theme.Colors.loginGradientStart,
        elevation: 0.0,
      ),
      drawer: Drawer(
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
                          color: Colors.blue,
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
      ),
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
        tabs: choices.map((Choice choice) {
          return Tab(
            text: choice.title,
            icon: choice.icon,
          );
        }).toList(),
      ),
    );
  }
}

class Choice {
  final String title;
  final Icon icon;

  const Choice({this.title, this.icon});
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Home', icon: Icon(Icons.home)),
  const Choice(title: 'Goal', icon: Icon(FontAwesomeIcons.bullseye)),
  const Choice(title: 'Habit', icon: Icon(Icons.calendar_today)),
  const Choice(title: 'Diary', icon: Icon(FontAwesomeIcons.journalWhills)),
];
