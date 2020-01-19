import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Colors{

  const Colors();

  ///Segunda opcion

  static const Color primaryColor = const Color(0xFF7da2a9);
  static const Color secondaryColor = const Color(0xFFf7f7f7);
  static const Color whiteColor = const Color(0xFFFFFFFF);
  static const Color blackColor = const Color(0x8A000000);

  static const Color hintDarkColor = const Color(0xB3FFFFFF);
  static const Color hintColor = const Color(0x8A000000);

  static const primaryGradient = const LinearGradient(
    colors: const [primaryColor, secondaryColor],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const darkGradient = const LinearGradient(
    colors: const [secondaryDarkColor, secondaryDarkColor],
    stops: const [0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const lightGradient = const LinearGradient(
    colors: const [secondaryColor, secondaryColor],
  );

  static const loginButtonGradient = const LinearGradient(
      colors: [
        secondaryColor,
        primaryColor
      ],
      begin: const FractionalOffset(0.2, 0.2),
      end: const FractionalOffset(1.0, 1.0),
      stops: [0.0, 1.0],
      tileMode: TileMode.clamp);

  ///Dark mode
  static const Color primaryDarkColor = const Color(0xFF52747a);
  static const Color secondaryDarkColor = const Color(0xFF333333);
}

class Fonts{

  static const String primaryFont = "WorkSansMedium";

}