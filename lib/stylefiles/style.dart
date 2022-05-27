import 'package:flutter/material.dart';

Color light = const Color(0xFFF7F8FC);
Color blue = const Color(0xFF2C5D9E);
Color dark = const Color(0xFF363740);
Color lightgrey = const Color(0xFFA4A6B3);
Map<int, Color> color = {
  50: Color.fromRGBO(4, 131, 184, .1),
  100: Color.fromRGBO(4, 131, 184, .2),
  200: Color.fromRGBO(4, 131, 184, .3),
  300: Color.fromRGBO(4, 131, 184, .4),
  400: Color.fromRGBO(4, 131, 184, .5),
  500: Color.fromRGBO(4, 131, 184, .6),
  600: Color.fromRGBO(4, 131, 184, .7),
  700: Color.fromRGBO(4, 131, 184, .8),
  800: Color.fromRGBO(4, 131, 184, .9),
  900: Color.fromRGBO(4, 131, 184, 1),
};
MaterialColor myColor = MaterialColor(0xFF2C5D9E, color);
TextStyle hint =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: dark);
TextStyle buttons =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: Colors.white);
TextStyle divider =
    TextStyle(fontSize: 20, fontWeight: FontWeight.w300, color: dark);
TextStyle header = TextStyle(
    fontSize: 25, fontWeight: FontWeight.w800, color: Colors.grey[600]);
