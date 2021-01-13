import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';

class Storage {
  FirebaseStorage storage = FirebaseStorage.instance;
  File f;
  Directory directory;

  void write(String data) async {
    if (directory == null) {
      directory = await getApplicationDocumentsDirectory();
    }

    f = new File('${directory.path}/temp.txt');

    var ref = storage.ref().child('dishes/1');

    f.writeAsString("Salut les copains");

    ref.putFile(f);
  }
}
