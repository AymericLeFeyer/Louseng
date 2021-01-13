import 'dart:math';

import 'package:flutter/material.dart';
import 'package:louseng/data/models/user.dart';

const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';

class Family {
  String code;
  List<User> members = new List<User>();
  int n = 0;

  Family({Key key, this.code, this.members, this.n});

  void increment() {
    this.n++;
  }

  void generateCode() {
    print(getRandomString(4));
  }
}

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));
