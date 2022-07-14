import 'package:flutter/material.dart';

import 'themes.dart';

abstract class AppTextStyle {
  static const button = TextStyle(
    fontFamily: 'Lato',
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 25,
    height: 40 / 25,
    letterSpacing: 25 * 0.03,
    color: AppColors.greyDark,
  );
}
