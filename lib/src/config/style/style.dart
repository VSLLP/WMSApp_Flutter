import 'package:flutter/material.dart';

class AppColors {
  static Color colorWhite = const Color(0xFFFFFFFF);
  static Color colorBlack = const Color(0xFF000000);

  static Color colorPrimary = const Color(0xFF6CB4F9);
  static Color colorAssent = const Color(0xFF7BA2D7);
  static Color colorTertiary = const Color(0xFF2B0B98);

  static Color colorTansprent40 = const Color(0xAA141414);
  static Color colorTansprent20 = const Color(0x4D141414);

  static Color colorGray100 = const Color(0xFFE1E1E1);
  static Color colorGray200 = const Color(0xFFC8C8C8);
  static Color colorGray300 = const Color(0xFFACACAC);
  static Color colorGray400 = const Color(0xFF919191);
  static Color colorGray500 = const Color(0xFF6E6E6E);
  static Color colorGray600 = const Color(0xFF404040);
  static Color colorGray900 = const Color(0xFF212121);
  static Color colorGray950 = const Color(0xFF141414);
  static Color colorDataColor = const Color(0xFF11296B);
  static Color colorDataHeaderColor = const Color(0xFF00509D);
  static Color colorHeaderColor = const Color(0xFF00296B);

  static Color colorYellow100 = const Color(0xFFF7B548);
  static Color colorYellow200 = const Color(0xFFFFD590);
  static Color colorYellow300 = const Color(0xFFFFE5B9);
  static Color colorCyan100 = const Color(0xFF28C2D1);
  static Color colorCyan200 = const Color(0xFF7BDDEF);
  static Color colorCyan300 = const Color(0xFFC3F2F4);
  static Color colorBlue100 = const Color(0xFF3E8EED);
  static Color colorBlue200 = const Color(0xFF72ACF1);
  static Color colorBlue300 = const Color(0xFFA7CBF6);
}

class Fonts {
  static const String prime = "Material";
  static const String secund = "OpenSans";
}

class TextStyles {
  static TextStyle getRegularPrime(double size,
      {Color? color, bool isMain = false}) {
    return TextStyle(
      fontFamily: Fonts.prime,
      fontWeight: FontWeight.w400,
      fontSize: size,
      height: 1,
      color: color ?? AppColors.colorBlack,
    );
  }

  static TextStyle getRegularScund(double size,
      {Color? color, bool isMain = false}) {
    return TextStyle(
      fontFamily: Fonts.secund,
      fontWeight: FontWeight.w400,
      height: 1.25,
      fontSize: size,
      color: color ?? AppColors.colorBlack,
    );
  }

  static TextStyle getBold(double size, {Color? color, bool isMain = false}) {
    return TextStyle(
      fontFamily: Fonts.secund,
      fontWeight: FontWeight.w600,
      fontSize: size,
      height: 1.2,
      color: color ?? AppColors.colorBlack,
    );
  }
}
