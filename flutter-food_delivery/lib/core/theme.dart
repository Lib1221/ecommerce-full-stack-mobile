import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.blue,
  brightness: Brightness.light,
  textTheme: GoogleFonts.interTextTheme(),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 2,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.grey[100],
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.black,
    centerTitle: true,
  ),
);

final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  colorSchemeSeed: Colors.deepPurple,
  brightness: Brightness.dark,
  textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
  cardTheme: CardTheme(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 2,
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    filled: true,
    fillColor: Colors.grey[900],
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
);
