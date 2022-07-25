import 'package:flutter/material.dart';

import '../../resources/resources.dart';

class ButtonSetWallpaper extends StatelessWidget {
  const ButtonSetWallpaper({
    Key? key,
    required this.content,
    required this.onTap,
  }) : super(key: key);

  final Widget content;
  final Future<void> Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      clipBehavior: Clip.hardEdge,
      color: AppColors.green,
      child: DefaultTextStyle(
        style: AppTextStyle.buttonSetAsWallpaperAndDownload,
        child: InkWell(
          onTap: onTap,
          child: content,
        ),
      ),
    );
  }
}
