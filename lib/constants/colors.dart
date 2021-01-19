import 'dart:ui';

import 'package:flutter/material.dart';

class MyTheme {
  static ThemeData light = ThemeData(
      brightness: Brightness.light,
      primaryColor: Color(0xFFBE0813),
      accentColor: Color(0xFFFAD105),
      textSelectionColor: Color(0xFFBE0813),
      textSelectionHandleColor: Color(0xFFBE0813),
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFFBE0813), selectionColor: Color(0xFFBE0813)));
}
