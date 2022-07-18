import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../domain/repositories/wallpaper_repository/src/models/wallpaper_response.dart';
import '../../../resources/resources.dart';
import '../../../utils/utils.dart';
import '../../common_widgets/common_widgets.dart';

class WallpaperDetailPage extends StatelessWidget {
  const WallpaperDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final paddingFromSystemBar = MediaQuery.of(context).padding.top;
    final wallpaper = context.read<Wallpaper>();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            color: AppColors.grey,
            child: Image.network(
              wallpaper.path,
              fit: BoxFit.cover,
            ),
          ),
          const _WallpaperSpecificationInfo(),
          const Positioned(
            bottom: 31,
            left: 48,
            right: 48,
            child: SizedBox(
              height: 63,
              child: ButtonSetWallpaper(),
            ),
          ),
          Positioned(
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
          ),
        ],
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
