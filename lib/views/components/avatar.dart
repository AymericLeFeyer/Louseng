import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:louseng/constants/colors.dart';
import 'package:louseng/data/models/user.dart';
import 'package:louseng/views/pages/entry.dart';

class Avatar extends StatefulWidget {
  String name;

  Avatar({Key key, this.name}) : super(key: key);

  @override
  _AvatarState createState() => _AvatarState();
}

class _AvatarState extends State<Avatar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: Container(
        child: new Stack(
          children: <Widget>[
            Center(
              child: Card(
                elevation: 16,
                child: Container(
                  height: 100.0,
                  width: Get.width - 40,
                  child: Center(
                    child: TextField(
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, color: MyTheme.light.primaryColor),
                      onChanged: (value) {
                        EntryView.name = value;
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'What is your name ?',
                          hintStyle: TextStyle(
                              fontSize: 20, color: MyTheme.light.primaryColor)),
                    ),
                  ),
                ),
              ),
            ),
            FractionalTranslation(
              translation: Offset(0.0, -0.4),
              child: Align(
                child: CircleAvatar(
                  radius: 25.0,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  backgroundColor: MyTheme.light.primaryColor,
                ),
                alignment: FractionalOffset(0.5, 0.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
