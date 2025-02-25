import 'package:flutter/material.dart';

import 'app_colors.dart';

TextStyle IntroHeadingTextStyle({
  required double fontSize,
}) {
  return TextStyle(
    fontSize: fontSize,
    color: AppColors.black,
    fontFamily: 'ADLaM Display',
  );
}

TextStyle dataTextStyle({double fontSize = 18}) {
  return TextStyle(
    fontSize: fontSize,
    color: AppColors.black,
    fontFamily: 'Poppins',
  );
}
