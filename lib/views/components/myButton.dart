import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:louseng/constants/colors.dart';

class MyButton extends StatelessWidget {
  String title;
  Function onPressed;
  Icon icon;

  MyButton({Key key, this.title, this.onPressed, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: MyTheme.light.accentColor,
      onPressed: onPressed,
      child: ListTile(
        leading: icon,
        title: Text(title),
      ),
    );
  }
}
