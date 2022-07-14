import 'package:flutter/material.dart';

import '../../resources/resources.dart';
import 'app_colors.dart';

abstract class AppTextStyle {
  static const title = TextStyle(
    fontFamily: AppFonts.lato,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 25,
    height: 40 / 25,
    letterSpacing: 25 * 0.03,
    color: AppColors.greyDark,
  );
  static const subtitle = TextStyle(
    fontFamily: AppFonts.raleway,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 20 / 12,
    letterSpacing: 12 * 0.03,
    color: AppColors.greyDark,
  );
}
