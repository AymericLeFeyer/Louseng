import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:yeeSang/constants/colors.dart';

class MyTitle extends StatelessWidget {
  String title;

  MyTitle({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BorderedText(
      strokeWidth: 8,
      child: Text(
        title,
        style: TextStyle(
            fontSize: 36,
            color: MyTheme.light.accentColor,
            fontWeight: FontWeight.bold,
            fontFamily: 'AsianHero'),
      ),
    );
  }
}
