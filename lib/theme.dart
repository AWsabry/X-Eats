import "package:flutter/material.dart";

class ThemeApp {
  static Color primaryColor = const Color.fromRGBO(113, 224, 1, 1);
  static Color accentColor = const Color.fromRGBO(0, 0, 0, 1);
  static Color whiteColor = Colors.white;
  static Color cultured = Color.fromRGBO(249, 249, 243, 1);
  static Color greyColor = Colors.grey;
  static Color redColor = Colors.red;
  static const integralCFFont = "IntegralCF";
  static const poppinsFont = "Poppins";

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color.fromRGBO(113, 224, 1, 1),
    backgroundColor: const Color.fromRGBO(0, 0, 0, 1),
    canvasColor: whiteColor,
    scaffoldBackgroundColor: cultured,
    textTheme: TextTheme(
      // Poppins for products starts with display
      displaySmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: poppinsFont,
        fontSize: 9,
        color: accentColor,
      ),
      displayMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: poppinsFont,
        fontSize: 12,
        color: accentColor,
      ),
      displayLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: poppinsFont,
        fontSize: 16,
        color: accentColor,
      ),

      // For Product Details
      titleSmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: poppinsFont,
        fontSize: 11,
        color: greyColor,
      ),
      // For Writing on Black Background
      headlineSmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: poppinsFont,
        fontSize: 9,
        color: whiteColor,
      ),

      headlineMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: integralCFFont,
        fontSize: 12,
        color: primaryColor,
      ),
      headlineLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: integralCFFont,
        fontSize: 16,
        color: primaryColor,
      ),
      //  Integral Titles Start with "Body"
      bodySmall: TextStyle(
        fontFamily: integralCFFont,
        fontWeight: FontWeight.w600,
        fontSize: 9,
        color: accentColor,
      ),
      bodyMedium: TextStyle(
        fontFamily: integralCFFont,
        fontWeight: FontWeight.w600,
        fontSize: 12,
        color: accentColor,
      ),

      bodyLarge: TextStyle(
        fontFamily: integralCFFont,
        fontWeight: FontWeight.w600,
        fontSize: 16,
        color: accentColor,
      ),
      labelMedium: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: integralCFFont,
        fontSize: 10,
        color: primaryColor,
      ),
      labelSmall: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: poppinsFont,
        fontSize: 15,
        color: whiteColor,
      ),
      labelLarge: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: integralCFFont,
        fontSize: 15,
        color: whiteColor,
      ),
      // Define more text styles here if needed
    ),
  );
}
