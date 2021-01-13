import 'package:flutter/material.dart';

class User {
  String name;
  int n;

  User({Key key, this.name, this.n});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      n: json['n'],
    );
  }

  Map toJson() {
    return {
      'name': name,
      'n': n,
    };
  }

  void increment() {
    this.n++;
  }
}
