import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/utils.dart';
import '../../../common_widgets/common_widgets.dart';
import '../../wallpapers/bloc/wallpapers_bloc.dart';
import '../../wallpapers/models/wallpaper_response.dart';

class WallpaperDetailPage extends StatelessWidget {
  const WallpaperDetailPage({
    required this.wallpaperId,
    super.key,
  });

  final String wallpaperId;

  @override
  Widget build(BuildContext context) {
    final paddingFromSystemBar = MediaQuery.of(context).padding.top;

    final wallpaper = context.watch<WallpapersBloc>().findById(wallpaperId);
    final bytes = wallpaper.mainImage.bytes;
    Image? image;
    if (bytes == null) {
      context
          .read<WallpapersBloc>()
          .add(WallpaperMainImageGotBytes(wallpaper: wallpaper));
    } else {
      image = Image.memory(
        bytes,
        fit: BoxFit.cover,
      );
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: AppColors.grey,
            child: image,
          ),
          _WallpaperSpecificationInfo(wallpaperId),
          _ButtonDownloadAndSetWallpaper(wallpaperId),
          _ButtonArrowBack(paddingFromSystemBar: paddingFromSystemBar),
        ],
      ),
    );
  }
}

class _ButtonDownloadAndSetWallpaper extends StatelessWidget {
  const _ButtonDownloadAndSetWallpaper(this.wallpaperId);

  final String wallpaperId;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 31,
      left: 48,
      right: 48,
      child: SizedBox(
        height: 63,
        child: BlocBuilder<WallpapersBloc, WallpapersState>(
          builder: (context, state) {
            final wallpaper =
                context.read<WallpapersBloc>().findById(wallpaperId);
            final status = wallpaper.wallpaperStatus;
            switch (status) {
              case WallpaperStatus.initial:
                return ButtonSetWallpaper(
                  content: const Center(
                    child: Text('Download'),
                  ),
                  onTap: () async {
                    context
                        .read<WallpapersBloc>()
                        .add(WallpaperDownloaded(wallpaper));
                  },
                );
              case WallpaperStatus.loading:
                return const ButtonSetWallpaper(
                  content: Center(
                    child: Loader(color: AppColors.white),
                  ),
                );
              case WallpaperStatus.downloaded:
                return ButtonSetWallpaper(
                  content: const Center(
                    child: Text('Set as wallpaper'),
                  ),
                  onTap: () async {
                    context
                        .read<WallpapersBloc>()
                        .add(WallpaperSetWallpaper(wallpaper: wallpaper));
                  },
                );
              case WallpaperStatus.installedWallpaper:
                return const ButtonSetWallpaper(
                  content: Center(
                    child: Text('Installed as as wallpaper'),
                  ),
                );
            }
          },
        ),
      ),
    );
  }
}

class _WallpaperSpecificationInfo extends StatelessWidget {
  const _WallpaperSpecificationInfo(this.wallpaperId);

  final String wallpaperId;

  @override
  Widget build(BuildContext context) {
    final wallpaper = context.read<WallpapersBloc>().findById(wallpaperId);

    final resolution = wallpaper.resolution;

    final fileSizeBytes = wallpaper.fileSizeBytes;
    final filesizeConverting = filesizeConvert(fileSizeBytes, 1);

    final createdAt = wallpaper.createdAt;
    final createdAtFormat = convertDateTime(createdAt);

    return Positioned(
      bottom: 104,
      left: 24,
      right: 24,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.whiteForSpecification,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 10,
            spacing: 10,
            children: [
              _RowImageWithText(
                imageAsset: AppImages.expand,
                description: resolution,
              ),
              _RowImageWithText(
                imageAsset: AppImages.downloading,
                description: filesizeConverting,
              ),
              if (createdAtFormat != null)
                _RowImageWithText(
                  imageAsset: AppImages.date,
                  description: createdAtFormat,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RowImageWithText extends StatelessWidget {
  const _RowImageWithText({
    required this.imageAsset,
    required this.description,
  });

  final String imageAsset;
  final String description;

  @override
  Widget build(BuildContext context) {
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

class _ButtonArrowBack extends StatelessWidget {
  const _ButtonArrowBack({required this.paddingFromSystemBar});

  final double paddingFromSystemBar;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: paddingFromSystemBar + 10,
      left: 10,
      child: Material(
        borderRadius: BorderRadius.circular(25),
        clipBehavior: Clip.hardEdge,
        color: Colors.transparent,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: AppColors.white80Percent,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Center(
            child: IconButton(
              splashColor: Colors.white,
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 18,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
