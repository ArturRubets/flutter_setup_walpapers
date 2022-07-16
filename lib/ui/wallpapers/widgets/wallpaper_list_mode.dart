import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/repositories/wallpaper_repository/src/models/wallpaper_response.dart';
import '../../../resources/resources.dart';
import '../../../utils/convert_from_byte_to_mb.dart';
import '../../common_widgets/button_set_wallpaper.dart';
import '../bloc/wallpapers_bloc.dart';

class WallpaperListMode extends StatelessWidget {
  const WallpaperListMode({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Container(
        padding: const EdgeInsets.only(
          left: 8,
          top: 8,
          right: 16,
          bottom: 8,
        ),
        decoration: BoxDecoration(
          color: AppColors.greySoft,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            const Expanded(flex: 144, child: _WallpaperPhoto()),
            const SizedBox(width: 10),
            Expanded(
              flex: 203,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: const [
                  SizedBox(height: 9),
                  _WallpaperSpecificationInfo(),
                  Spacer(flex: 3),
                  SizedBox(
                    height: 42,
                    child: ButtonSetWallpaper(),
                  ),
                  Spacer(flex: 1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _WallpaperPhoto extends StatelessWidget {
  const _WallpaperPhoto();

  @override
  Widget build(BuildContext context) {
    final thumbOriginal =
        context.select<Wallpaper, String>((w) => w.thumbs.small);
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
      left: 3,
      right: 3,
      bottom: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 4,
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
            flex: 5,
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

    final createdAt = context.select<Wallpaper, String>((w) => w.createdAt);
    final createdAtFormat =
        context.read<WallpapersBloc>().convertDateTime(createdAt);

    return Wrap(
      runSpacing: 18,
      spacing: 10,
      children: [
        item(AppImages.expand, resolution),
        item(AppImages.downloading, filesizeConverting),
        if (createdAtFormat != null) item(AppImages.date, createdAtFormat),
      ],
    );
  }

  Widget item(String imageAsset, String description) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imageAsset,
          width: 12,
          height: 12,
        ),
        const SizedBox(width: 2),
        FittedBox(
          alignment: Alignment.centerLeft,
          fit: BoxFit.scaleDown,
          child: Text(
            description,
            style: AppTextStyle.wallpaperSpecificationInfoListView,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
