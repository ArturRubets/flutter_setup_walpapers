import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/utils.dart';
import '../../../navigation/main_navigation.dart';
import '../bloc/wallpapers_bloc.dart';
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
              final wallpaperId = context.read<String>();
              Navigator.of(context).pushNamed(
                MainNavigationRouteNames.wallpaperScreenDetail,
                arguments: ArgumentsWallpaperDetail(
                  bloc: context.read<WallpapersBloc>(),
                  wallpaperId: wallpaperId,
                ),
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
    final wallpaperId = context.read<String>();
    final wallpaper = context.select<WallpapersBloc, WallpaperModelBloc?>(
      (value) {
        if (value.state.wallpapers.isEmpty) {
          return null;
        }

        return value.state.wallpapers
            .firstWhere((element) => element.id == wallpaperId);
      },
    );

    final bytes = wallpaper?.thumbs.thumbOrigin.bytes;
    Image? image;
    if (wallpaper != null && bytes == null) {
      context
          .read<WallpapersBloc>()
          .add(WallpaperThumbOriginGotBytes(wallpaper: wallpaper));
    } else if (bytes != null) {
      image = Image.memory(
        bytes,
        fit: BoxFit.cover,
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: ColoredBox(
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
    final wallpaperId = context.read<String>();
    final wallpaper = context.read<WallpapersBloc>().findById(wallpaperId);

    final favorites = wallpaper.favorites;
    final category = wallpaper.category;

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
            child: _Item(
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
            child: _Item(
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
}

class _Item extends StatelessWidget {
  const _Item(this.content);

  final Widget content;

  @override
  Widget build(BuildContext context) {
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
    final wallpaperId = context.read<String>();
    final wallpaper = context.read<WallpapersBloc>().findById(wallpaperId);

    final resolution = wallpaper.resolution;
    final fileSizeBytes = wallpaper.fileSizeBytes;
    final filesizeConverting = filesizeConvert(fileSizeBytes, 1);

    return Row(
      children: [
        _SpecificationInfoItem(AppImages.expand, resolution),
        const SizedBox(width: 10),
        _SpecificationInfoItem(AppImages.downloading, filesizeConverting),
      ],
    );
  }
}

class _SpecificationInfoItem extends StatelessWidget {
  const _SpecificationInfoItem(this.imageAsset, this.description);

  final String imageAsset;
  final String description;

  @override
  Widget build(BuildContext context) {
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
