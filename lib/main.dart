import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:louseng/constants/colors.dart';
import 'package:louseng/views/pages/entry.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends GetMaterialApp {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Welcome to Flutter',
      home: EntryView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
