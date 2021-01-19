import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:louseng/constants/colors.dart';

class MyButton extends StatelessWidget {
  String title;
  Function onPressed;
  IconData icon;

  MyButton({Key key, this.title, this.onPressed, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: MyTheme.light.primaryColor,
      onPressed: onPressed,
      elevation: 16,
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(8.0)),
      child: Container(
        width: Get.size.width / 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 48,
                color: Colors.white,
              ),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}
