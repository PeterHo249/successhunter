import 'package:flutter/material.dart';
import 'package:successhunter/style/theme.dart' as Theme;

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.Colors.primaryGradient,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5.0),
            child: Card(
              elevation: 5.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 180.0,
                      width: 180.0,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                      ),
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Text('Display name'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
