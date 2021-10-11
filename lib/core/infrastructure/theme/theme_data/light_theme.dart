import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:registro_elettronico/core/infrastructure/theme/theme_data/text_styles.dart';

class LightTheme {
  static ThemeData getThemeData(Color color) {
    return ThemeData(
      colorScheme: ColorScheme.light(
        primary: color,
        secondary: color,
      ),
      brightness: Brightness.light,
      fontFamily: 'Manrope',
      appBarTheme: AppBarTheme(
        elevation: 1,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      ),
      cardTheme: CardTheme(elevation: 0.5),
      primaryIconTheme: IconThemeData(color: Colors.grey[900], opacity: 0.50),
      primaryTextTheme: TextTheme(
        headline6: TextStyle(
          color: Colors.grey[900],
        ),
        headline5: heaingSmall.copyWith(color: Colors.grey[900]),
        bodyText2: bodyStyle1.copyWith(color: Colors.grey[900]),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: color,
        selectionHandleColor: color,
      ),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }
}

final cupertino = CupertinoThemeData(
  brightness: Brightness.light,
);
