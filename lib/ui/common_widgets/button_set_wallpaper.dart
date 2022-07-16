import 'package:flutter/material.dart';

import '../../resources/resources.dart';

class ButtonSetWallpaper extends StatelessWidget {
  const ButtonSetWallpaper({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      color: AppColors.green,
      child: InkWell(
        splashColor: Colors.white10,
        onTap: () {},
        child: const Center(
          child: Text(
            'Set as wallpaper',
            style: AppTextStyle.buttonSetAsWallpaper,
          ),
        ),
      ),
    );
  }
}
