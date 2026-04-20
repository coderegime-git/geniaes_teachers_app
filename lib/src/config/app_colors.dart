import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Color
  static const Color primaryColor = Color(0xff024153);
  static const Color secondaryColor = Color(0xff1241BB);
  static const Color tertiaryColor = Color(0xFF3D4589);
  static const Color textColorOne = Color(0xff535353);

  // Regular colors
  static const Color darkGrey = Color(0xff303041);
  static const Color grey = Color(0xFF817B7B);
  static const Color offWhite = Color(0xFFF9F2E3);
  static const Color bgColor = Color(0xFFF2F6FF);
  static const Color bgColorTwo = Color(0xFFFBFAFF);
  static const Color hintTextColor = Color(0xFF818181);
  static const Color lightGrey = Color(0xFF9B9B9B);
  static const Color silverColor = Color(0xFFF2F6FF);
  static const Color beigeColor = Color(0xFFFDC24E);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color transparent = Colors.transparent;
  static const Color burgundy = Color(0xFF880d1e);
  static const Color spaceCadet = Color(0xFFF4FCFE);
  static const Color green = Color(0xFF38FF06);
  static const Color red = Color(0xFFFF0606);
  static const Color carrotRed = Color(0xFFFA6B6B);
  static const Color orange = Color.fromARGB(255, 255, 114, 6);

  // Custom Dialog Colors
  static const Color customDialogSuccessColor = Color(0xff0FC6C2);
  static const Color customDialogErrorColor = Color(0xffED1E54);
  static const Color customDialogInfoColor = Color(0xffFFA200);
  static const Color customDialogQuestionColor = Color(0xff528AF7);

  // Gradients
  static const Gradient gradientOne = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      AppColors.secondaryColor,
      AppColors.primaryColor,
    ],
  );

  static const Gradient gradientTwo = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      AppColors.tertiaryColor,
      AppColors.secondaryColor,
    ],
  );

  static const Gradient gradientThree = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      AppColors.offWhite,
      AppColors.lightGrey,
    ],
  );

  static const Gradient gradientFour = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      AppColors.white,
      AppColors.white,
    ],
  );
  static const Gradient gradientFive = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      AppColors.primaryColor,
      AppColors.primaryColor,
      AppColors.transparent,
      AppColors.transparent,
      AppColors.transparent,
    ],
  );
  static const Gradient gradientSix = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      AppColors.tertiaryColor,
      AppColors.tertiaryColor,
      AppColors.tertiaryColor,
    ],
  );

  static const Gradient gradientSeven = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      AppColors.primaryColor,
      AppColors.secondaryColor,
    ],
  );

  static const Gradient gradientEight = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      AppColors.white,
      AppColors.white,
      AppColors.transparent,
      AppColors.transparent,
      AppColors.transparent,
    ],
  );
}
