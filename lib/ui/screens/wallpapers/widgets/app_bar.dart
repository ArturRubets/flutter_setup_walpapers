import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../resources/resources.dart';
import '../bloc/wallpapers_bloc.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        top: 28,
        right: 24,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Expanded(
            flex: 3,
            child: _Title(),
          ),
          Expanded(
            flex: 2,
            child: _ButtonGroup(),
          )
        ],
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: const [
        Text(
          'Wallpapers',
          style: AppTextStyle.title,
        ),
        Text(
          'Find the best wallpapers for',
          style: AppTextStyle.subtitle,
        ),
      ],
    );
  }
}

class _ButtonGroup extends StatelessWidget {
  const _ButtonGroup();

  @override
  Widget build(BuildContext context) {
    final displayMode = context.select<WallpapersBloc, WallpaperDisplayMode>(
        (w) => w.state.displayMode);
    final isGridMode = displayMode == WallpaperDisplayMode.grid;
    final isListMode = displayMode == WallpaperDisplayMode.list;

    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.greySoft,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              children: [
                _Button(
                  isActive: isGridMode,
                  imageAsset: AppImages.gridMode,
                  onTap: () {
                    context
                        .read<WallpapersBloc>()
                        .add(WallpaperGridModeSwitched());
                  },
                ),
                const SizedBox(width: 5),
                _Button(
                  isActive: isListMode,
                  imageAsset: AppImages.listMode,
                  onTap: () {
                    context
                        .read<WallpapersBloc>()
                        .add(WallpaperListModeSwitched());
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.isActive,
    required this.imageAsset,
    required this.onTap,
  });

  final bool isActive;
  final String imageAsset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.white : null,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Image.asset(
          imageAsset,
          color: !isActive ? AppColors.white.withOpacity(0.5) : null,
          colorBlendMode: !isActive ? BlendMode.modulate : null,
        ),
      ),
    );
  }
}
