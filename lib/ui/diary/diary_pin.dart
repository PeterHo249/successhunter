import 'dart:async';

import 'package:flutter/material.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_ui/pin_input.dart';
import 'package:successhunter/ui/diary/diary_page.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/helper.dart' as Helper;

class DiaryPin extends StatefulWidget {
  @override
  DiaryPinState createState() {
    return new DiaryPinState();
  }
}

class DiaryPinState extends State<DiaryPin> {
  double screenWidth = 0;
  double screenHeight = 0;
  int retryTimes = 0;
  Timer timer;

  @override
  void dispose() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    if (DateTime.now().isAfter(lockTime)) {
      isLockPin = false;
    } else {
      timer = Timer(lockTime.difference(DateTime.now()), () {
        if (mounted) {
          setState(() {
            isLockPin = false;
          });
        }
      });
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buidlHeader(context),
          isLockPin ? _buildLockInfo(context) : _buildPinInput(context),
        ],
      ),
    );
  }

  Widget _buidlHeader(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: screenHeight * 0.2,
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      backgroundColor: Theme.Colors.mainColor,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'PIN for Diary',
          style: Theme.header1Style.copyWith(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        background: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Container(
                width: screenWidth,
                height: screenHeight * 0.2,
                color: Colors.white,
              ),
              Helper.buildHeaderBackground(context, height: screenHeight * 0.2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPinInput(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              'Enter Diary PIN',
              style: Theme.contentStyle,
            ),
          ),
          PinInput(
            onSubmited: (value) {
              if (gInfo.diaryPin != null && gInfo.diaryPin != '') {
                // Have pin
                if (gInfo.diaryPin == value) {
                  // Pass
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => DiaryPage()));
                } else {
                  retryTimes++;
                  if (retryTimes == 5) {
                    if (mounted) {
                      setState(() {
                        isLockPin = true;
                        retryTimes = 0;
                        lockTime = DateTime.now().add(Duration(minutes: 1));
                        timer = Timer(Duration(minutes: 1), () {
                          setState(() {
                            isLockPin = false;
                          });
                        });
                      });
                    }
                  }
                }
              } else {
                // Don't have pin
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => DiaryPage()));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLockInfo(BuildContext context) {
    return SliverFillRemaining(
      child: Center(
        child: Text(
          'You have typed wrong PIN 5 times.\nPlease wait for 1 minute to retry.',
          textAlign: TextAlign.center,
          style: Theme.contentStyle.copyWith(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
