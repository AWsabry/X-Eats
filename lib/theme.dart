import "package:flutter/material.dart";
import 'package:google_fonts/google_fonts.dart';

class ThemeApp {
  static Color primaryColor = Color.fromRGBO(113, 224, 1, 1);
  static Color accentColor = Color.fromRGBO(0, 0, 0, 1);
  static Color whiteColor = Colors.white;

  MaterialColor materialColor = MaterialColor(
    primaryColor.value,
    <int, Color>{
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1.0),
    },
  );
}
