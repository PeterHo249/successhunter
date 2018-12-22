import 'package:flutter/material.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_ui/pin_input.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/helper.dart' as Helper;

class DiaryPin extends StatelessWidget {
  double screenWidth = 0;
  double screenHeight = 0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buidlHeader(context),
          _buildPinInput(context),
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
            child: Text('Enter Diary PIN', style: Theme.contentStyle,),
          ),
          PinInput(
            pin: gInfo.diaryPin,
            onPassed: () {
              print('You have passed pin test.');
            },
          ),
        ],
      ),
    );
  }
}
