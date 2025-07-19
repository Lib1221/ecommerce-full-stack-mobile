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
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(color: Colors.blueAccent, width: 2),
    ),
    filled: true,
    fillColor: Colors.white,
    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    hintStyle: GoogleFonts.inter(color: Colors.grey[500]),
    labelStyle: GoogleFonts.inter(color: Colors.grey[700]),
    floatingLabelStyle: GoogleFonts.inter(
        color: Colors.blueAccent, fontWeight: FontWeight.bold),
    // Add a subtle shadow
    // (Flutter doesn't support shadow directly in InputDecorationTheme, but the border and fill will look modern)
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
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(100),
      borderSide: BorderSide(color: Colors.deepPurpleAccent, width: 2),
    ),
    filled: true,
    fillColor: Colors.grey[900],
    contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
    hintStyle: GoogleFonts.inter(color: Colors.grey[400]),
    labelStyle: GoogleFonts.inter(color: Colors.grey[300]),
    floatingLabelStyle: GoogleFonts.inter(
        color: Colors.deepPurpleAccent, fontWeight: FontWeight.bold),
  ),
  appBarTheme: AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    centerTitle: true,
  ),
);
