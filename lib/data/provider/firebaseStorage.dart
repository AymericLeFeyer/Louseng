import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:yeeSang/constants/colors.dart';
import 'package:yeeSang/controllers/firebaseMessaging.dart';
import 'package:yeeSang/data/models/family.dart';
import 'package:yeeSang/data/models/user.dart';
import 'package:yeeSang/views/pages/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Storage {
  static FirebaseStorage storage = FirebaseStorage.instance;
  static File f;
  static Directory directory;
  static HomeViewState homeview;

  static void write(Family fa) async {
    directory = await getApplicationDocumentsDirectory();

    f = new File('${directory.path}/temp.txt');

    storage = FirebaseStorage.instance;
    var ref = storage.ref().child('dishes/${fa.code}');

    f.writeAsString(json.encode(fa));

    ref.putFile(f);
  }

  static Future<bool> checkIfExistAndJoin(String code) async {
    try {
      await getFamily(code);

      User.current.index = Family.current.members.length;
      Family.current.members.add(User.current);
      write(Family.current);

      print("check : ${Family.current.code}");

      return true;
      // Do whatever
    } catch (err) {
      return false;
      // Doesn't exist... or potentially some other error
    }
  }

  static void refresh(video, name) async {
    await getFamily(Family.current.code);
    homeview.setState(() {});
    if (video) {
      homeview.playVideo();
      Get.snackbar("The dish is stiring !", "$name is stiring the dish !",
          colorText: MyTheme.light.accentColor);
    } else {
      if (name != '') {
        Get.snackbar("Someone joined !", "$name joined !",
            colorText: MyTheme.light.accentColor);
      }
    }
  }

  static Future<void> getFamily(String code) async {
    directory = await getApplicationDocumentsDirectory();
    storage = FirebaseStorage.instance;
    var ref = storage.ref().child('dishes/$code');
    var url = await ref.getDownloadURL();
    var downloaded = await http.get(url);

    Family.current = Family.fromJson(json.decode(downloaded.body));

    print("dl : ${Family.current.code}");
  }
}
