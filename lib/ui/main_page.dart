import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:successhunter/model/data_feeder.dart';
import 'package:successhunter/model/notification.dart';
import 'package:successhunter/model/user.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/coop/coop_form.dart';
import 'package:successhunter/ui/custom_ui/FAB_bottom_app_bar.dart';
import 'package:successhunter/ui/custom_ui/FAB_with_icon.dart';
import 'package:successhunter/ui/coop/coop_page.dart';
import 'package:successhunter/ui/diary/diary_form.dart';
import 'package:successhunter/ui/diary/diary_page.dart';
import 'package:successhunter/ui/diary/diary_pin.dart';
import 'package:successhunter/ui/diary/pin_setting.dart';
import 'package:successhunter/ui/goal/goal_form.dart';
import 'package:successhunter/ui/goal/goal_page.dart';
import 'package:successhunter/ui/habit/habit_form.dart';
import 'package:successhunter/ui/habit/habit_page.dart';
import 'package:successhunter/ui/home/home_page.dart';
import 'package:successhunter/auth/auth.dart';
import 'package:successhunter/ui/info/gallery.dart';
import 'package:successhunter/ui/info/info_page.dart';
import 'package:successhunter/utils/enum_dictionary.dart';

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
    DataFeeder.instance.getInfo().listen(
      (documentSnapshot) {
        gInfo = User.fromJson(json.decode(json.encode(documentSnapshot.data)));
      },
    );
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
              MaterialPageRoute(builder: (context) => CoopForm()));
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
        duration: Duration(
          milliseconds: 300,
        ),
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
              MaterialPageRoute(builder: (context) => CoopForm()));
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
    FirebaseNotification.instance.context = context;
    return Scaffold(
      key: scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: fabs[currentIndex],
      bottomNavigationBar: bottomAppBar,
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        children: <Widget>[
          HomePage(),
          GoalPage(),
          CoopPage(),
          HabitPage(),
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
            title: Text(
              'Information',
              style: Theme.header3Style,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(this.context,
                  MaterialPageRoute(builder: (context) => InfoPage()));
            },
          ),
          ListTile(
            title: Text(
              'Gallery',
              style: Theme.header3Style,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(this.context,
                  MaterialPageRoute(builder: (context) => Gallery()));
            },
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text(
              'Diary',
              style: Theme.header3Style,
            ),
            onTap: () {
              Navigator.pop(context);
              if (gInfo.diaryPin == null || gInfo.diaryPin == '') {
                Navigator.push(this.context,
                    MaterialPageRoute(builder: (context) => DiaryPage()));
              } else {
                Navigator.push(this.context,
                    MaterialPageRoute(builder: (context) => DiaryPin()));
              }
            },
          ),
          ListTile(
            title: Text(
              'Diary PIN Setting',
              style: Theme.header3Style,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(this.context,
                  MaterialPageRoute(builder: (context) => PinSetting()));
            },
          ),
          Divider(
            color: Colors.grey,
          ),
          ListTile(
            title: Text(
              'Log out',
              style: Theme.header3Style,
            ),
            onTap: () {
              Auth.instance.signOut();
              int tokenIndex = gInfo.fcmToken.indexOf(FirebaseNotification.instance.token);
              if (tokenIndex != -1) {
                gInfo.fcmToken.removeAt(tokenIndex);
                DataFeeder.instance.overwriteInfo(gInfo);
              }
            },
          ),
        ],
      ),
    );
  }
}
