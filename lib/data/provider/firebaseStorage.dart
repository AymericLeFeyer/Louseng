import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:louseng/data/models/family.dart';
import 'package:louseng/data/models/user.dart';
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

    //TEST
    User u = new User(name: "Aymeric", n: 0);
    User u1 = new User(name: 'Emilie', n: 2);

    Family fa = new Family(n: 7);
    fa.generateCode();
    fa.members = new List<User>();
    fa.members.add(u);
    fa.members.add(u1);

    //END TEST

    var ref = storage.ref().child('dishes/${fa.code}');

    f.writeAsString(fa.toJson().toString());

    ref.putFile(f);
  }
}
