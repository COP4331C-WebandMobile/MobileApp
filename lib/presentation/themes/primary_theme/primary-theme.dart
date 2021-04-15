import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class PrimaryTheme {
  static ThemeData get primaryTheme {
    return ThemeData(
      primaryColor: CustomColors.gold,
      colorScheme: CustomColorTheme.primaryScheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
      ),
      textTheme: GoogleFonts.bubblegumSansTextTheme(),
      buttonTheme: ButtonThemeData(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
        colorScheme: ColorScheme.dark(),
      ),
    );
  }
}

class CustomColorTheme {
  static ColorScheme get primaryScheme {
    return ColorScheme(
        background: Colors.white,
        brightness: Brightness.light,
        error: Colors.red,
        onBackground: Colors.black,
        onError: Colors.white,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.white,
        primary: Colors.black,
        primaryVariant: Colors.yellowAccent,
        secondary: Colors.black,
        secondaryVariant: Colors.black,
        surface: Colors.blue);
  }
}
