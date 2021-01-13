import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:louseng/data/models/family.dart';
import 'package:louseng/data/provider/firebaseStorage.dart';
import 'package:louseng/views/components/myButton.dart';
import 'package:louseng/views/pages/home.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class EntryView extends StatelessWidget {
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
            MyButton(
              title: "Create a new dish",
              onPressed: createDish,
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
  // Get.to(HomeView());
  // Create the dish

  Storage s = new Storage();

  s.write("Salut les amigos");
}

void joinDish() {
  Get.to(HomeView());
  // Join the dish
  Family f = new Family();
  f.generateCode();
}
