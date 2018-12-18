import 'package:flutter/material.dart';
import 'package:successhunter/ui/custom_sliver_app_bar.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_sliver_persistent_header_delegate.dart';
import 'package:successhunter/utils/enum_dictionary.dart';

class Gallery extends StatelessWidget {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildHeader(context, Container()),
          _buildSectionHeader(context, 'Avatars'),
          _buildAvatarSection(context),
          _buildSectionHeader(context, 'Achivements'),
          _buildAchivementSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Widget child) {
    return CustomSliverAppBar(
      backgroundColor: Theme.Colors.mainColor,
      foregroundColor: Colors.white,
      height: screenHeight * 0.3,
      width: screenWidth,
      flexibleChild: child,
      title: 'Gallery',
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: CustomSliverPersistentHeaderDelegate(
        minHeight: 60.0,
        maxHeight: 80.0,
        child: Container(
          color: Colors.white,
          child: Text(
            title,
            style: Theme.header2Style.copyWith(
              color: Theme.Colors.mainColor,
            ),
          ),
          alignment: Alignment(-0.9, 0.0),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(BuildContext context) {
    var avatars = avatarNames.keys.toList();
    return SliverGrid.count(
      crossAxisCount: 3,
      children: avatars.map((avatar) {
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Avatar',
                    style: Theme.header2Style,
                  ),
                  content: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 100.0,
                          width: 100.0,
                          child: Image.asset(
                            'assets/avatar/$avatar',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          'You will receive this avatar when reach level ${avatarNames[avatar]}',
                          style: Theme.contentStyle,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    RaisedButton(
                      textColor: Colors.white,
                      child: Text(
                        'Ok',
                        style: Theme.header4Style,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            height: 100.0,
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Image.asset(
                    'assets/avatar/$avatar',
                    fit: BoxFit.contain,
                  ),
                  Container(
                    height: 20.0,
                    width: 90.0,
                    color: Color(0xAA444444),
                    child: Center(
                      child: Text(
                        'Lv. ${avatarNames[avatar]}',
                        style: Theme.contentStyle.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    );
  }

  Widget _buildAchivementSection(BuildContext context) {
    var badges = badgeNames.keys.toList();
    return SliverGrid.count(
      crossAxisCount: 3,
      children: badges.map((badge) {
        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(
                    'Badge',
                    style: Theme.header2Style,
                  ),
                  content: Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 100.0,
                          width: 100.0,
                          child: Image.asset(
                            'assets/badge/$badge',
                            fit: BoxFit.contain,
                          ),
                        ),
                        Text(
                          badgeNames[badge],
                          style: Theme.contentStyle,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                    ),
                  ),
                  actions: <Widget>[
                    RaisedButton(
                      textColor: Colors.white,
                      child: Text(
                        'Ok',
                        style: Theme.header4Style,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Container(
            height: 100.0,
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                'assets/badge/$badge',
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      }).toList(),
      mainAxisSpacing: 5.0,
      crossAxisSpacing: 5.0,
    );
  }
}
