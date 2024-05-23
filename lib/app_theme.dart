import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();
  //theme colors
  static final Color primary = Color.fromARGB(255, 220, 199, 255);
  static final Color theme = Color(0x030637);
  static final Color background = Color.fromARGB(255, 60, 7, 83);
  static final Color buttons = Color.fromARGB(225, 197, 152, 212);
  static final Color text = Color.fromARGB(255, 227, 141, 200);
  static final Color white = Color.fromARGB(255, 200, 200, 200);


  static final TextStyle title = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: white,
  );
  static final TextStyle subtitle =  TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w100,
    color: white,
  );
  static final TextStyle body = TextStyle(
    fontSize: 16,
    color: background,
  );
  static final TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: buttons,
  );
  static final TextStyle link = TextStyle(
    fontSize: 16,
    color: Colors.blue,
  );
  static final TextStyle error = TextStyle(
    fontSize: 16,
    color: Colors.red,
  );
  static final TextStyle success = TextStyle(
    fontSize: 16,
    color: Colors.green,
  );

  static final TextStyle expense= TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 255, 187, 184),
  );
  static final TextStyle income= TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 194, 255, 194),
  );
  static final TextStyle desc= TextStyle(
    fontSize: 14,
  );
  static final TextStyle date= TextStyle(
    fontSize: 14,
  );
}
