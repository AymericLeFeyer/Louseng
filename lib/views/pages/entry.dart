import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:louseng/constants/colors.dart';
import 'package:louseng/data/models/family.dart';
import 'package:louseng/data/models/user.dart';
import 'package:louseng/data/provider/firebaseStorage.dart';
import 'package:louseng/views/components/avatar.dart';
import 'package:louseng/views/components/myButton.dart';
import 'package:louseng/views/components/title.dart';
import 'package:louseng/views/pages/home.dart';
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
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.yellow, Colors.red])),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Yee Sang",
                style:
                    TextStyle(color: MyTheme.light.primaryColor, fontSize: 56),
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
                      onPressed: joinDish,
                      icon: Icons.group),
                ],
              ),
            ],
          ),
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

void joinDish() async {
  if (codeWrote() && nameWrote()) {
    User.rename(EntryView.name);

    if (await Storage.checkIfExistAndJoin(EntryView.code)) {
      Get.to(HomeView());
    } else {
      Get.snackbar("We got a problem", "The code you enter doesn't exists !",
          colorText: MyTheme.light.accentColor);
    }
  }
}

bool codeWrote() {
  if (EntryView.code == null || EntryView.code == "") {
    Get.snackbar("What is your code ?", "You need to enter the code before !",
        colorText: MyTheme.light.accentColor);
    return false;
  } else
    return true;
}

bool nameWrote() {
  if (EntryView.name == null || EntryView.name == "") {
    Get.snackbar("Who are you ?", "You need to put your name before !",
        colorText: MyTheme.light.accentColor);
    return false;
  } else
    return true;
}
