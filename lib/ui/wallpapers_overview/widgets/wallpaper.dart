import 'package:flutter/material.dart';

import '../../../resources/resources.dart';

class Wallpaper extends StatelessWidget {
  const Wallpaper({super.key});


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      // height: 203,
      padding: const EdgeInsets.only(
        left: 8,
        top: 8,
        right: 8,
        bottom: 16,
      ),
      decoration: BoxDecoration(
        color: AppColors.greySoft,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: const [
          _WallpaperPhoto(),
          SizedBox(height: 10),
          _WallpaperSpecificationInfo()
        ],
      ),
    );
  }
}

class _WallpaperSpecificationInfo extends StatelessWidget {
  const _WallpaperSpecificationInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        item(AppImages.expand, '2233x3108'),
        item(AppImages.downloading, '3.9 MB'),
      ],
    );
  }

  Widget item(String imageAsset, String description) {
    return Expanded(
      child: Row(
        children: [
          Image.asset(
            imageAsset,
            width: 9,
            height: 9,
          ),
          const SizedBox(width: 2),
          Expanded(
            child: Text(
              description,
              style: AppTextStyle.wallpaperSpecificationInfo,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _WallpaperPhoto extends StatelessWidget {
  const _WallpaperPhoto();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            width: 144,
            height: 160,
            color: AppColors.grey,
            child: Image.network(
              'https://th.wallhaven.cc/orig/1k/1k5y51.jpg',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const _WallpaperPhotoGeneralInfo(),
      ],
    );
  }
}

class _WallpaperPhotoGeneralInfo extends StatelessWidget {
  const _WallpaperPhotoGeneralInfo();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      right: 8,
      bottom: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          item(
            Row(
              children: [
                Image.asset(AppImages.heart),
                const Text('0'),
              ],
            ),
          ),
          const SizedBox(width: 3),
          item(const Text('anime')),
        ],
      ),
    );
  }

  Widget item(Widget content) {
    return DefaultTextStyle(
      style: AppTextStyle.wallpaperGeneralInfo,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: content,
      ),
    );
  }
}
