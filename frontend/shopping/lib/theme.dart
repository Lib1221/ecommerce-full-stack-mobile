import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  brightness: Brightness.light,
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: Colors.black,
  colorScheme: ColorScheme.light(
    primary: Colors.black,
    secondary: Colors.grey.shade700,
    background: Colors.white,
    surface: Colors.grey.shade100,
    onPrimary: Colors.white,
    onSecondary: Colors.black,
    onBackground: Colors.black,
    onSurface: Colors.black,
  ),
  textTheme: GoogleFonts.interTextTheme().copyWith(
    titleLarge: TextStyle(fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 14),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 0,
    titleTextStyle: GoogleFonts.inter(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Colors.black,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey.shade200,
    selectedColor: Colors.black,
    labelStyle: GoogleFonts.inter(color: Colors.black),
    secondaryLabelStyle: GoogleFonts.inter(color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    brightness: Brightness.light,
  ),
  cardTheme: CardTheme(
    color: Colors.grey.shade100,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: EdgeInsets.all(8),
  ),
);

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  useMaterial3: true,
  scaffoldBackgroundColor: Colors.black,
  primaryColor: Colors.white,
  colorScheme: ColorScheme.dark(
    primary: Colors.white,
    secondary: Colors.grey.shade300,
    background: Colors.black,
    surface: Colors.grey.shade900,
    onPrimary: Colors.black,
    onSecondary: Colors.white,
    onBackground: Colors.white,
    onSurface: Colors.white,
  ),
  textTheme: GoogleFonts.interTextTheme().copyWith(
    titleLarge: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
    bodyMedium: TextStyle(fontSize: 14, color: Colors.white70),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
    elevation: 0,
    titleTextStyle: GoogleFonts.inter(
      fontWeight: FontWeight.bold,
      fontSize: 24,
      color: Colors.white,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: Colors.grey.shade800,
    selectedColor: Colors.white,
    labelStyle: GoogleFonts.inter(color: Colors.white),
    secondaryLabelStyle: GoogleFonts.inter(color: Colors.black),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    brightness: Brightness.dark,
  ),
  cardTheme: CardTheme(
    color: Colors.grey.shade900,
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: EdgeInsets.all(8),
  ),
);
