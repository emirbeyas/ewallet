// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyThemes {
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Color.fromRGBO(30, 31, 38, 1),
    colorScheme: ColorScheme.dark(
        primary: Colors.white, secondary: Color.fromRGBO(19, 20, 23, 1)),
    useMaterial3: true,
  );

  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.white,
    colorScheme: ColorScheme.light(primary: Color.fromRGBO(30, 31, 38, 1)),
    useMaterial3: true,
  );
}
