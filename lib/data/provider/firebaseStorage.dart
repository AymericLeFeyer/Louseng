import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:louseng/controllers/firebaseMessaging.dart';
import 'package:louseng/data/models/family.dart';
import 'package:louseng/data/models/user.dart';
import 'package:louseng/views/pages/home.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class Storage {
  static FirebaseStorage storage = FirebaseStorage.instance;
  static File f;
  static Directory directory;
  static Function homeview;

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
      getFamily(code);

      User.current.index = Family.current.members.length;
      Family.current.members.add(User.current);
      write(Family.current);

      return true;
      // Do whatever
    } catch (err) {
      return false;
      // Doesn't exist... or potentially some other error
    }
  }

  static void refresh() async {
    print("REFRESHED");
    getFamily(Family.current.code);
    homeview();
  }

  static void getFamily(String code) async {
    directory = await getApplicationDocumentsDirectory();
    storage = FirebaseStorage.instance;
    var ref = storage.ref().child('dishes/$code');
    var url = await ref.getDownloadURL();
    var downloaded = await http.get(url);

    Family.current = Family.fromJson(json.decode(downloaded.body));
  }
}
