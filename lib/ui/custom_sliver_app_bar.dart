import 'package:flutter/material.dart';

import 'package:successhunter/style/theme.dart' as Theme;
import 'package:successhunter/utils/helper.dart' as Helper;

class CustomSliverAppBar extends StatefulWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String title;
  final Widget flexibleChild;
  final double height;
  final double width;
  final ImageProvider image;
  final Widget leading;

  CustomSliverAppBar({
    this.backgroundColor = Colors.blue,
    this.foregroundColor = Colors.white,
    this.title = 'Title',
    this.flexibleChild,
    this.height = 300.0,
    this.width = 300.0,
    this.image,
    this.leading,
  });

  @override
  _CustomSliverAppBarState createState() => _CustomSliverAppBarState();
}

class _CustomSliverAppBarState extends State<CustomSliverAppBar> {
  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: widget.leading == null
          ? IconButton(
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            )
          : widget.leading,
      title: Text(
        widget.title,
        style: Theme.header1Style.copyWith(
          color: widget.foregroundColor,
        ),
      ),
      expandedHeight: widget.height,
      backgroundColor: widget.backgroundColor,
      pinned: true,
      centerTitle: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Helper.buildHeaderBackground(
                context,
                color: widget.backgroundColor,
                height: widget.height,
                width: widget.width,
                image: widget.image,
              ),
              Center(
                child: widget.flexibleChild,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
