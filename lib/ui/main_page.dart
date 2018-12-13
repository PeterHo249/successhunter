import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/FAB_bottom_app_bar.dart';
import 'package:successhunter/ui/FAB_with_icon.dart';
import 'package:successhunter/ui/coop/coop_page.dart';
import 'package:successhunter/ui/diary/diary_form.dart';
import 'package:successhunter/ui/diary/diary_page.dart';
import 'package:successhunter/ui/goal/goal_form.dart';
import 'package:successhunter/ui/goal/goal_page.dart';
import 'package:successhunter/ui/habit/habit_form.dart';
import 'package:successhunter/ui/habit/habit_page.dart';
import 'package:successhunter/ui/home/home_page.dart';
import 'package:successhunter/auth/auth.dart';
import 'package:successhunter/ui/info/info_page.dart';

class MainPage extends StatefulWidget {
  final FirebaseUser user;

  MainPage({Key key, this.user}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Variable

  int currentIndex = 0;
  List<Widget> fabs;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PageController pageController;

  // Business
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    fabs = [
      FABWithIcons(
        icons: [
          FontAwesomeIcons.bullseye,
          Icons.people_outline,
          Icons.calendar_today,
          FontAwesomeIcons.bookOpen,
        ],
        backgroundColor: Theme.Colors.mainColor,
        foregroundColor: Colors.white,
        onIconTapped: _selectedFAB,
      ),
      FloatingActionButton(
        onPressed: () {
          Navigator.push(this.context,
              MaterialPageRoute(builder: (context) => GoalForm()));
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
          // TODO: Implement co-op form here
          print('add new co-op');
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.Colors.mainColor,
      ),
      FloatingActionButton(
        onPressed: () {
          Navigator.push(this.context,
              MaterialPageRoute(builder: (context) => HabitForm()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.Colors.mainColor,
      ),
      FloatingActionButton(
        onPressed: () {
          Navigator.push(this.context,
              MaterialPageRoute(builder: (context) => DiaryForm()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.Colors.mainColor,
      ),
      FloatingActionButton(
        // TODO: What can we do here, Peter????
        onPressed: null,
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
    pageController.dispose();
  }

  void _selectedTab(int index) {
    setState(() {
      currentIndex = index;
      pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 300,),
        curve: Curves.linear,
      );
    });
  }

  void _selectedFAB(int index) {
    setState(() {
      switch (index) {
        case 0:
          Navigator.push(this.context,
              MaterialPageRoute(builder: (context) => GoalForm()));
          break;
        case 1:
          Navigator.push(this.context,
              MaterialPageRoute(builder: (context) => HabitForm()));
          break;
        case 2:
          Navigator.push(this.context,
              MaterialPageRoute(builder: (context) => HabitForm()));
          break;
        case 3:
          Navigator.push(this.context,
              MaterialPageRoute(builder: (context) => DiaryForm()));
          break;
        default:
      }
    });
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    FABBottomAppBar bottomAppBar = _buildFABBottomAppBar(context);
    return Scaffold(
      key: scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: fabs[currentIndex],
      bottomNavigationBar: bottomAppBar,
      body: PageView(
        controller: pageController,
        children: <Widget>[
          HomePage(),
          GoalPage(),
          CoopPage(),
          HabitPage(),
          DiaryPage(),
          InfoPage(),
        ],
        onPageChanged: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      drawer: _buildDrawer(context),
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
        FABBottomAppBarItem(icon: Icons.people_outline, label: 'Co-op'),
        FABBottomAppBarItem(icon: Icons.calendar_today, label: 'Habit'),
        FABBottomAppBarItem(icon: FontAwesomeIcons.bookOpen, label: 'Diary'),
        FABBottomAppBarItem(icon: Icons.person_outline, label: 'Info'),
      ],
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
                      style: Theme.header1Style.copyWith(
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
              Auth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}
