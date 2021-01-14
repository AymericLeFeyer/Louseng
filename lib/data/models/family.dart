import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:louseng/data/models/user.dart';

const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';

class Family {
  String code;
  int n = 0;
  List<User> members = new List<User>();

  static Family current;

  Family({Key key, this.code, this.members, this.n});

  factory Family.fromJson(Map<String, dynamic> json) {
    return Family(
        code: json['code'], n: json['n'], members: createList(json['members']));
  }

  Map toJson() {
    List<Map> members = this.members != null
        ? this.members.map((i) => i.toJson()).toList()
        : null;

    return {
      'code': code,
      'n': n,
      'members': members,
    };
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
}

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(Random().nextInt(_chars.length))));
