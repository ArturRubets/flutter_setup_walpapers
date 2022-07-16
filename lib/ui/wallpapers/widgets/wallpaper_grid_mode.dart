import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/repositories/wallpaper_repository/src/models/wallpaper_response.dart';
import '../../../resources/resources.dart';
import '../../../utils/convert_from_byte_to_mb.dart';

class WallpaperGridMode extends StatelessWidget {
  const WallpaperGridMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(child: _WallpaperPhoto()),
          SizedBox(height: 10),
          _WallpaperSpecificationInfo()
        ],
      ),
    );
  }
}

class _WallpaperPhoto extends StatelessWidget {
  const _WallpaperPhoto();

  @override
  Widget build(BuildContext context) {
    final thumbOriginal =
        context.select<Wallpaper, String>((w) => w.thumbs.original);
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: AppColors.grey,
            child: Image.network(
              thumbOriginal,
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
    final favorites = context.select<Wallpaper, int>((w) => w.favorites);
    final category = context.select<Wallpaper, String>((w) => w.category);

    return Positioned(
      left: 8,
      right: 8,
      bottom: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flexible(
            flex: 2,
            child: item(
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(AppImages.heart),
                  Flexible(
                    child: Text(
                      '$favorites',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 3),
          Flexible(
            flex: 3,
            child: item(
              Text(
                category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
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

class _WallpaperSpecificationInfo extends StatelessWidget {
  const _WallpaperSpecificationInfo();

  @override
  Widget build(BuildContext context) {
    final resolution = context.select<Wallpaper, String>((w) => w.resolution);
    final fileSizeBytes =
        context.select<Wallpaper, int>((w) => w.fileSizeBytes);
    final filesizeConverting = filesizeConvert(fileSizeBytes, 1);

    return Row(
      children: [
        item(AppImages.expand, resolution),
        const SizedBox(width: 10),
        item(AppImages.downloading, filesizeConverting),
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
            child: FittedBox(
              alignment: Alignment.centerLeft,
              fit: BoxFit.scaleDown,
              child: Text(
                description,
                style: AppTextStyle.wallpaperSpecificationInfoGridView,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}