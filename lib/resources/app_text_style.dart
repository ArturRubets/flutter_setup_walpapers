import 'package:flutter/material.dart';

import '../../resources/resources.dart';

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
  static const wallpaperGeneralInfo = TextStyle(
    fontFamily: AppFonts.montserrat,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.normal,
    fontSize: 12,
    height: 15 / 12,
    letterSpacing: 12 * 0.03,
    color: AppColors.greySoft,
  );
  static const wallpaperSpecificationInfo = TextStyle(
    fontFamily: AppFonts.montserrat,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
    fontSize: 10,
    height: 12 / 10,
    color: AppColors.blueDark,
  );
}
