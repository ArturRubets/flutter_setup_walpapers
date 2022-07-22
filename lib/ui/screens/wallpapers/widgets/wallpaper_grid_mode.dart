import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/utils.dart';
import '../../../navigation/main_navigation.dart';
import '../models/wallpaper_response.dart';

class WallpaperGridMode extends StatelessWidget {
  const WallpaperGridMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
        ),
        Material(
          borderRadius: BorderRadius.circular(25),
          clipBehavior: Clip.hardEdge,
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              final wallpaper = context.read<WallpaperModelBloc>();
              Navigator.of(context).pushNamed(
                MainNavigationRouteNames.wallpaperScreenDetail,
                arguments: wallpaper,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _WallpaperPhoto extends StatelessWidget {
  const _WallpaperPhoto();

  @override
  Widget build(BuildContext context) {
    final wallpaper = context.read<WallpaperModelBloc>();
    final bytes = wallpaper.thumbs?.thumbOrigin?.bytes;
    final path = wallpaper.thumbs?.thumbOrigin?.path;
    Image? image;
    if (bytes != null) {
      image = Image.memory(
        bytes,
        fit: BoxFit.cover,
      );
    } else if (path != null) {
      image = Image.network(
        path,
        fit: BoxFit.cover,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: AppColors.grey,
            child: image,
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
    final favorites =
        context.select<WallpaperModelBloc, int>((w) => w.favorites);
    final category =
        context.select<WallpaperModelBloc, String>((w) => w.category);

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
    final resolution =
        context.select<WallpaperModelBloc, String>((w) => w.resolution);
    final fileSizeBytes =
        context.select<WallpaperModelBloc, int>((w) => w.fileSizeBytes);
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
