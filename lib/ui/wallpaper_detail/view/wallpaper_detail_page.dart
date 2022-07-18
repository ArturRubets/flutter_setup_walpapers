import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../resources/resources.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/common_widgets.dart';
import '../../wallpapers/models/wallpaper.dart';
import '../bloc/wallpaper_detail_bloc.dart';

class WallpaperDetailPage extends StatelessWidget {
  const WallpaperDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingFromSystemBar = MediaQuery.of(context).padding.top;
    final wallpaper = context.read<WallpaperDetailBloc>().state.wallpaper;

    final imageWidget = wallpaper.getMainImageWidget();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: AppColors.grey,
            child: imageWidget,
          ),
          const _WallpaperSpecificationInfo(),
          const _ButtonDownloadAndSetWallpaper(),
          _ButtonArrowBack(paddingFromSystemBar: paddingFromSystemBar),
        ],
      ),
    );
  }
}

class _ButtonDownloadAndSetWallpaper extends StatelessWidget {
  const _ButtonDownloadAndSetWallpaper();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 31,
      left: 48,
      right: 48,
      child: SizedBox(
        height: 63,
        child: BlocBuilder<WallpaperDetailBloc, WallpaperDetailState>(
          builder: (context, state) {
            switch (state.wallpaper.wallpaperDownload) {
              case WallpaperDownload.failure:
              case WallpaperDownload.initial:
                return ButtonSetWallpaper(
                  content: const Center(
                    child: Text('Download'),
                  ),
                  onTap: () async {
                    context
                        .read<WallpaperDetailBloc>()
                        .add(const WallpaperDetailDownloaded());
                  },
                );
              case WallpaperDownload.loading:
                return ButtonSetWallpaper(
                  content: const Center(
                    child: Loader(),
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
    );
  }
}

class _WallpaperSpecificationInfo extends StatelessWidget {
  const _WallpaperSpecificationInfo();

  @override
  Widget build(BuildContext context) {
    final resolution =
        context.read<WallpaperDetailBloc>().state.wallpaper.resolution;

    final fileSizeBytes =
        context.read<WallpaperDetailBloc>().state.wallpaper.fileSizeBytes;
    final filesizeConverting = filesizeConvert(fileSizeBytes, 1);

    final createdAt =
        context.read<WallpaperDetailBloc>().state.wallpaper.createdAt;
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
              item(AppImages.expand, resolution),
              item(AppImages.downloading, filesizeConverting),
              if (createdAtFormat != null)
                item(AppImages.date, createdAtFormat),
            ],
          ),
        ),
      ),
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

class _ButtonArrowBack extends StatelessWidget {
  const _ButtonArrowBack({required this.paddingFromSystemBar});

  final double paddingFromSystemBar;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10 + paddingFromSystemBar,
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
