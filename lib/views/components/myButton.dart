import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:yeeSang/constants/colors.dart';

class MyButton extends StatelessWidget {
  String title;
  Function onPressed;
  IconData icon;

  MyButton({Key key, this.title, this.onPressed, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: MyTheme.light.accentColor,
      onPressed: onPressed,
      elevation: 16,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
      child: Container(
        width: Get.size.width / 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 48,
                color: MyTheme.light.primaryColor,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style:
                    TextStyle(fontSize: 18, color: MyTheme.light.primaryColor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
