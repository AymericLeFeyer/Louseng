import 'dart:io';

import 'package:bordered_text/bordered_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:yeeSang/constants/colors.dart';
import 'package:yeeSang/data/models/family.dart';
import 'package:yeeSang/data/models/user.dart';
import 'package:yeeSang/data/provider/firebaseStorage.dart';
import 'package:yeeSang/views/components/avatar.dart';
import 'package:yeeSang/views/components/myButton.dart';
import 'package:yeeSang/views/components/title.dart';
import 'package:yeeSang/views/pages/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class EntryView extends StatefulWidget {
  static String name;
  static String code;

  @override
  _EntryViewState createState() => _EntryViewState();
}

class _EntryViewState extends State<EntryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/background.jpg"),
                      fit: BoxFit.cover)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BorderedText(
                    strokeWidth: 6.0,
                    child: Text(
                      "Yee Sang",
                      style: TextStyle(
                          color: MyTheme.light.accentColor,
                          fontSize: 72,
                          fontFamily: 'AsianHero'),
                    ),
                  ),
                  Avatar(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyButton(
                          title: "Create \na new dish",
                          onPressed: createDish,
                          icon: Icons.add),
                      MyButton(
                          title: "Join \nmy family",
                          onPressed: () => joinDish(context),
                          icon: Icons.group),
                    ],
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BorderedText(
                strokeWidth: 3.0,
                child: Text(
                  "by Cindy Cheok",
                  style: TextStyle(
                      color: MyTheme.light.accentColor,
                      fontSize: 24,
                      fontFamily: 'Belgates'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void createDish() async {
  if (nameWrote()) {
    User.rename(EntryView.name);
    User.current.n = 0;
    User.current.index = 0;

    // Init a new family

    Family.current = new Family(n: 0);
    Family.current.generateCode();
    Family.current.members = new List<User>();
    Family.current.members.add(User.current);

    Storage.write(Family.current);

    Get.to(HomeView());
  }
}

void joinDish(BuildContext context) async {
  if (nameWrote()) {
    User.rename(EntryView.name);

    await displayTextInputDialog(context);

    if (EntryView.code == "" || EntryView.code == null) {
      Get.snackbar(
          "Problem with the code", "You must enter a code to continue !",
          colorText: MyTheme.light.primaryColor);
    } else if (await Storage.checkIfExistAndJoin(EntryView.code)) {
      print(EntryView.code);
      Get.to(HomeView());
    } else {
      Get.snackbar(
          "Problem with the code", "The code you enter doesn't exists !",
          colorText: MyTheme.light.primaryColor);
    }
  }
}

bool codeWrote() {
  if (EntryView.code == null || EntryView.code == "") {
    Get.snackbar("What is your code ?", "You need to enter the code before !",
        colorText: MyTheme.light.primaryColor);
    return false;
  } else
    return true;
}

bool nameWrote() {
  if (EntryView.name == null || EntryView.name == "") {
    Get.snackbar("Who are you ?", "You need to put your name before !",
        colorText: MyTheme.light.primaryColor);
    return false;
  } else
    return true;
}

Future<void> displayTextInputDialog(BuildContext context) async {
  EntryView.code = "";
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Join my family',
              style: TextStyle(color: MyTheme.light.primaryColor)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                  "Here you can enter a code. \nAsk it to your family and let's stir the dish !"),
              TextField(
                onChanged: (value) {
                  EntryView.code = value;
                },
                decoration: InputDecoration(hintText: "CODE"),
              ),
            ],
          ),
          actions: [
            FlatButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "OK",
                  style: TextStyle(color: MyTheme.light.primaryColor),
                ))
          ],
        );
      });
}
