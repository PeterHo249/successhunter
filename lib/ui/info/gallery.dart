import 'package:flutter/material.dart';
import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/ui/custom_sliver_persistent_header_delegate.dart';
import 'package:successhunter/ui/hero_dialog_route.dart';
import 'package:successhunter/utils/enum_dictionary.dart';
import 'package:successhunter/utils/helper.dart' as Helper;

class Gallery extends StatelessWidget {
  double screenHeight = 0.0;
  double screenWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _buildHeader(context),
          _buildSectionHeader(context, 'Avatars'),
          _buildAvatarSection(context),
          _buildSectionHeader(context, 'Achivements'),
          _buildAchivementSection(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          'Gallery',
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
            Navigator.push(
              context,
              HeroDialogRoute(
                builder: (BuildContext context) {
                  return Center(
                    child: AlertDialog(
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
                              child: Hero(
                                tag: avatar,
                                child: Image.asset(
                                  'assets/avatar/$avatar',
                                  fit: BoxFit.contain,
                                ),
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
                    ),
                  );
                },
              ),
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
                  Hero(
                    tag: avatar,
                    child: Image.asset(
                      'assets/avatar/$avatar',
                      fit: BoxFit.contain,
                    ),
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
            Navigator.push(
              context,
              HeroDialogRoute(
                builder: (BuildContext context) {
                  return Center(
                    child: AlertDialog(
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
                              child: Hero(
                                tag: badge,
                                child: Image.asset(
                                  'assets/badge/$badge',
                                  fit: BoxFit.contain,
                                ),
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
                    ),
                  );
                },
              ),
            );
          },
          child: Container(
            height: 100.0,
            width: 100.0,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Hero(
                tag: badge,
                child: Image.asset(
                  'assets/badge/$badge',
                  fit: BoxFit.contain,
                ),
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
