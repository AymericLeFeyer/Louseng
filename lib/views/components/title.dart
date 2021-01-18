import 'package:flutter/material.dart';
import 'package:louseng/constants/colors.dart';

class MyTitle extends StatelessWidget {
  String title;

  MyTitle({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 36,
          color: MyTheme.light.primaryColor,
          fontWeight: FontWeight.bold),
    );
  }
}
