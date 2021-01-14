import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:louseng/data/models/family.dart';
import 'package:louseng/data/models/user.dart';
import 'package:louseng/data/provider/firebaseStorage.dart';
import 'package:louseng/views/components/myButton.dart';
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
      appBar: AppBar(
        title: Text("Louseng"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("What is your name ?"),
                Container(
                  width: Get.size.width / 2,
                  child: TextField(
                    onChanged: (value) {
                      EntryView.name = value;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter your name here'),
                  ),
                ),
              ],
            ),
            MyButton(
              title: "Create a new dish",
              onPressed: createDish,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("Do you know the code ?"),
                Container(
                  width: Get.size.width / 2,
                  child: TextField(
                    onChanged: (value) {
                      EntryView.code = value;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter the family code here'),
                  ),
                ),
              ],
            ),
            MyButton(
              title: "Join my family",
              onPressed: joinDish,
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

void joinDish() async {
  if (codeWrote() && nameWrote()) {
    User.rename(EntryView.name);

    if (await Storage.checkIfExistAndJoin(EntryView.code)) {
      Get.to(HomeView());
    } else {
      Get.snackbar("We got a problem", "The code you enter doesn't exists !");
    }
  }
}

bool codeWrote() {
  if (EntryView.code == null || EntryView.code == "") {
    Get.snackbar("What is your code ?", "You need to enter the code before !");
    return false;
  } else
    return true;
}

bool nameWrote() {
  if (EntryView.name == null || EntryView.name == "") {
    Get.snackbar("Who are you ?", "You need to put your name before !");
    return false;
  } else
    return true;
}
