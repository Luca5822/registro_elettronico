import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/text_styles.dart';

class DarkTheme {
  static ThemeData getThemeData(MaterialColor color) {
    return ThemeData(
      primarySwatch: color,
      colorScheme: ColorScheme.dark(
        secondary: color,
      ),
      // primaryColor: color,
      brightness: Brightness.dark,
      fontFamily: 'Manrope',
      appBarTheme: AppBarTheme(
        elevation: 0,
        color: Colors.grey[900],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      primaryTextTheme: TextTheme(
        headline6: TextStyle(color: Colors.white),
        headline5: heaingSmall.copyWith(color: Colors.white),
        bodyText2: bodyStyle1.copyWith(color: Colors.white),
      ),
      cardTheme: CardTheme(color: Colors.grey[900]),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: color,
        selectionHandleColor: color,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

final cupertino = CupertinoThemeData(
  brightness: Brightness.dark,
);
