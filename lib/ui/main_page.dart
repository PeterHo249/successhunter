import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/FAB_bottom_app_bar.dart';
import 'package:successhunter/ui/FAB_with_icon.dart';
import 'package:successhunter/ui/anchored_overlay.dart';
import 'package:successhunter/ui/diary_page.dart';
import 'package:successhunter/ui/goal_form.dart';
import 'package:successhunter/ui/goal_page.dart';
import 'package:successhunter/ui/habit_form.dart';
import 'package:successhunter/ui/habit_page.dart';
import 'package:successhunter/ui/home_page.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser user;

  MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Variable
  final List<Widget> pageViews = [
    HomePage(),
    GoalPage(),
    HabitPage(),
    DiaryPage(),
  ];
  int currentIndex = 0;
  List<Widget> fabs;

  // Business
  @override
  void initState() {
    super.initState();
    fabs = [
      FABWithIcons(
        icons: [FontAwesomeIcons.bullseye, Icons.calendar_today],
        backgroundColor: Theme.Colors.mainColor,
        foregroundColor: Colors.white,
        onIconTapped: _selectedFAB,
      ),
      FloatingActionButton(
        onPressed: () {
          // TODO: implement handle add new goal
          Navigator.push(
              this.context, MaterialPageRoute(builder: (context) => GoalForm()));
          print('add new goal');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.Colors.mainColor,
      ),
      FloatingActionButton(
        onPressed: () {
          // TODO: implement handle add new habit
          Navigator.push(
              this.context, MaterialPageRoute(builder: (context) => HabitForm()));
          print('add new habit');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.Colors.mainColor,
      ),
      FloatingActionButton(
        onPressed: () {
          // TODO: implement handle add new diary
          print('add new diary');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.Colors.mainColor,
      ),
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _selectedTab(int index) {
    setState(() {
      currentIndex = index;
      print('page no: $index');
    });
  }

  void _selectedFAB(int index) {
    setState(() {
      // TODO: Implement handle add habit and goal here
      if (index == 0) {
        Navigator.push(
            this.context, MaterialPageRoute(builder: (context) => GoalForm()));
      } else {
        Navigator.push(
            this.context, MaterialPageRoute(builder: (context) => HabitForm()));
      }
      print('fab no: $index');
    });
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: fabs[currentIndex],
      bottomNavigationBar: _buildFABBottomAppBar(context),
      body: pageViews[currentIndex],
    );
  }

  Widget _buildFABBottomAppBar(BuildContext context) {
    return FABBottomAppBar(
      color: Colors.grey,
      selectedColor: Theme.Colors.mainColor,
      onTabSelected: _selectedTab,
      textStyle: Theme.contentStyle.copyWith(fontSize: 14.0),
      items: [
        FABBottomAppBarItem(icon: Icons.home, label: 'Home'),
        FABBottomAppBarItem(icon: FontAwesomeIcons.bullseye, label: 'Goal'),
        FABBottomAppBarItem(icon: Icons.calendar_today, label: 'Habit'),
        FABBottomAppBarItem(icon: FontAwesomeIcons.bookOpen, label: 'Diary'),
      ],
    );
  }

  Widget _buildFAB(BuildContext context) {
    final icons = [FontAwesomeIcons.bullseye, Icons.calendar_today];
    return AnchoredOverlay(
      showOverlay: true,
      overlayBuilder: (context, offset) {
        return CenterAbout(
          position: Offset(
            offset.dx,
            offset.dy - icons.length * 35.0,
          ),
          child: FABWithIcons(
            icons: icons,
            onIconTapped: _selectedFAB,
            backgroundColor: Theme.Colors.mainColor,
            foregroundColor: Colors.white,
          ),
        );
      },
      child: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
        elevation: 2.0,
      ),
    );
  }
}
