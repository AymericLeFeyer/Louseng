import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:yeeSang/data/models/user.dart';

const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
const _ints = '0123456789';

class Family {
  String code;
  String lucky;
  int n = 0;
  List<User> members = new List<User>();

  static Family current;

  Family({Key key, this.code, this.members, this.n, this.lucky});

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
        code: json['code'],
        lucky: json['lucky'],
        n: json['n'],
        members: createList(json['members']));
  }

  Map toJson() {
    List<Map> members = this.members != null
        ? this.members.map((i) => i.toJson()).toList()
        : null;

    return {'code': code, 'n': n, 'members': members, 'lucky': lucky};
  }

  static List<User> createList(List<dynamic> s) {
    List<User> L = new List<User>();
    for (int i = 0; i < s.length; i++) {
      L.add(User.fromJson(s[i]));
    }
    return L;
  }

  void generateCode() {
    this.code = getRandomString(4);
  }

  void generateLucky() {
    this.lucky = getRandomInt(4);
  }
}

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));

String getRandomInt(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _ints.codeUnitAt(Random().nextInt(_ints.length))));
