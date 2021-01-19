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
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        print(currentFocus);

        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: GetMaterialApp(
        title: 'Welcome to Flutter',
        theme: MyTheme.light,
        home: EntryView(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
