import 'package:flutter/material.dart';

class User {
  String name;
  int n;

  User({Key key, this.name, this.n});

  void increment() {
    this.n++;
  }
}
