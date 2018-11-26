import 'package:flutter/material.dart';

class FABWithIcons extends StatefulWidget {
  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;
  final Color backgroundColor;
  final Color foregroundColor;

  FABWithIcons({this.icons, this.onIconTapped, this.backgroundColor, this.foregroundColor});

  @override
  _FABWithIconsState createState() => _FABWithIconsState();
}

class _FABWithIconsState extends State<FABWithIcons>
    with TickerProviderStateMixin {
  // Variable
  AnimationController _controller;

  // Business
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 250,
      ),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Layout
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.icons.length, (int index) {
        return _buildChild(index);
      }).toList()
        ..add(
          _buildFAB(),
        ),
    );
  }

  Widget _buildChild(int index) {

    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(
            0.0,
            1.0 - index / widget.icons.length / 2.0,
            curve: Curves.easeOut,
          ),
        ),
        child: FloatingActionButton(
          backgroundColor: widget.backgroundColor ?? Colors.blue,
          mini: true,
          child: Icon(
            widget.icons[index],
            color: widget.foregroundColor ?? Colors.white,
          ),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }

  Widget _buildFAB() {
    return FloatingActionButton(
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}
