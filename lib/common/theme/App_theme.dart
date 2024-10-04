import 'package:flutter/material.dart';

class CAppTheme {
  CAppTheme._();

  static ThemeData lightTheme = ThemeData(
    // primaryColor: Colors.blue,
    useMaterial3: true,
    // fontFamily: "Poppins",
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    // textTheme: CTextTheme.lightTextTheme,
    // elevatedButtonTheme: CElevatedButtonTheme.lightElevatedButtonTheme,
    // appBarTheme: CAppBarTheme.lightAppBarTheme,
    // checkboxTheme: CCheckBoxTheme.lightCheckboxTheme,
    // bottomSheetTheme: CBottomSheetTheme.lightBottomSheetTheme,
    // inputDecorationTheme: CTextFromFieldTheme.lightInputDecoration,
  );

  static ThemeData darkTheme = ThemeData(
    // primaryColor: Colors.blue,
    useMaterial3: true,
    // fontFamily: "Poppins",
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    // textTheme: CTextTheme.darkTextTheme,
    // elevatedButtonTheme: CElevatedButtonTheme.darkElevatedButtonTheme,
    // appBarTheme: CAppBarTheme.darkAppBarTheme,
    // checkboxTheme: CCheckBoxTheme.darkCheckboxTheme,
    // bottomSheetTheme: CBottomSheetTheme.darkBottomSheetTheme,
    // inputDecorationTheme: CTextFromFieldTheme.darkInputDecoration,
  );
}