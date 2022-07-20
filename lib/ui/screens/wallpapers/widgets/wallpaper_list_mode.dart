import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/resources.dart';
import '../../../../utils/utils.dart';
import '../../../common_widgets/common_widgets.dart';
import '../../../navigation/main_navigation.dart';
import '../bloc/wallpapers_bloc.dart';
import '../models/wallpaper.dart';

class WallpaperListMode extends StatelessWidget {
  const WallpaperListMode({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              children: [
                const SizedBox(height: 9),
                const _WallpaperSpecificationInfo(),
                const Spacer(flex: 3),
                SizedBox(
                  height: 42,
                  child: BlocBuilder<WallpapersBloc, WallpapersState>(
                    builder: (context, state) {
                      final indexWallpaperInList = context.read<int>();
                      final wallpaperDownload = state
                          .wallpapers[indexWallpaperInList].wallpaperDownload;
                      switch (wallpaperDownload) {
                        case WallpaperDownload.failure:
                        case WallpaperDownload.initial:
                          return ButtonSetWallpaper(
                            content: const Center(
                              child: Text('Download'),
                            ),
                            onTap: () async {
                              final wallpaperBloc =
                                  context.read<WallpaperModelBloc>();
                              context
                                  .read<WallpapersBloc>()
                                  .add(WallpaperDownloaded(
                                    wallpaperBloc,
                                    indexWallpaperInList,
                                  ));
                            },
                          );
                        case WallpaperDownload.loading:
                          return ButtonSetWallpaper(
                            content: const Center(
                              child: Loader(color: AppColors.white),
                            ),
                            onTap: () async {},
                          );
                        case WallpaperDownload.success:
                          return ButtonSetWallpaper(
                            content: const Center(
                              child: Text('Set as wallpaper'),
                            ),
                            onTap: () async {
                              // Set as wallpaper
                            },
                          );
                      }
                    },
                  ),
                ),
                const Spacer(flex: 1),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _WallpaperPhoto extends StatelessWidget {
  const _WallpaperPhoto();

  @override
  Widget build(BuildContext context) {
    final imageWidget =
        context.read<WallpaperModelBloc>().thumbs.getOriginImageWidget();

    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Container(
            color: AppColors.grey,
            child: imageWidget,
          ),
        ),
        const _WallpaperPhotoGeneralInfo(),
        Material(
          borderRadius: BorderRadius.circular(15),
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

class _WallpaperPhotoGeneralInfo extends StatelessWidget {
  const _WallpaperPhotoGeneralInfo();

  @override
  Widget build(BuildContext context) {
    final favorites =
        context.select<WallpaperModelBloc, int>((w) => w.favorites);
    final category =
        context.select<WallpaperModelBloc, String>((w) => w.category);

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
    final resolution =
        context.select<WallpaperModelBloc, String>((w) => w.resolution);
    final fileSizeBytes =
        context.select<WallpaperModelBloc, int>((w) => w.fileSizeBytes);
    final filesizeConverting = filesizeConvert(fileSizeBytes, 1);

    final createdAt =
        context.select<WallpaperModelBloc, String>((w) => w.createdAt);
    final createdAtFormat = convertDateTime(createdAt);

    return Wrap(
      runSpacing: 10,
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
