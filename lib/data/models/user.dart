import 'package:flutter/material.dart';
import 'package:louseng/data/models/family.dart';

class User {
  String name;
  int n;
  int index;
  String token;

  static User current;

  User({Key key, this.name, this.n, this.index, this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        name: json['name'],
        n: json['n'],
        index: json['index'],
        token: json['token']);
  }

  Map toJson() {
    return {'name': name, 'n': n, 'index': index, 'token': token};
  }

  void increment() {
    this.n++;
  }

  static void create(String name) {
    if (current == null) {
      current = new User(name: name, n: 0);
    } else {
      print("User already set");
    }
  }

  static void rename(String name) {
    if (current != null) {
      current.name = name;
    } else {
      print("User created");
      User.create(name);
    }
  }
}
