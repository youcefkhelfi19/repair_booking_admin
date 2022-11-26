import 'package:flutter/material.dart';

import 'app_colors.dart';

ThemeData lightTheme = ThemeData(
    fontFamily: 'montserrat',
    scaffoldBackgroundColor: greyBackground,
    primaryColor: mainColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: mainColor,
      elevation: 0.0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 25
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(

      enabledBorder:OutlineInputBorder(
        borderSide: BorderSide(
            color: mainColor.withOpacity(0.5),
            width: 1
        ),

        borderRadius: BorderRadius.circular(10.0),

      ),
      border:OutlineInputBorder(
      borderSide: BorderSide(
          color:  mainColor.withOpacity(0.5),
          width: 1
      ),
      borderRadius: BorderRadius.circular(10.0),

    ) ,
      errorBorder:OutlineInputBorder(
        borderSide: BorderSide(
            color: Colors.red,
            width: 1
        ),
        borderRadius: BorderRadius.circular(10.0),

      ),
      focusedBorder:OutlineInputBorder(
        borderSide: BorderSide(
            color: mainColor,
            width: 1
        ),
        borderRadius: BorderRadius.circular(10.0),

      ),
    ),
    brightness: Brightness.light);
