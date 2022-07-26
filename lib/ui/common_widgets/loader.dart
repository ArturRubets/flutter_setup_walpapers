import 'package:flutter/material.dart';

import '../../resources/app_colors.dart';

class Loader extends StatelessWidget {
  const Loader({
    super.key,
    this.height = 24,
    this.width = 24,
    this.color = AppColors.loaderBlue,
  });

  final double height;
  final double width;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: height,
        width: width,
        child: CircularProgressIndicator(
          strokeWidth: 1.5,
          color: color,
        ),
      ),
    );
  }
}
