import 'package:flutter/material.dart';
import 'package:successhunter/style/theme.dart' as Theme;

class DiaryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: Theme.Colors.primaryGradient,
      ),
      child: Center(
        child: Text('Diary'),
      ),
    );
  }
}
