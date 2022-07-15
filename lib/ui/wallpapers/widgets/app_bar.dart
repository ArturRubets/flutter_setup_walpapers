import 'package:flutter/material.dart';

import '../../../resources/resources.dart';

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
                GestureDetector(
                  onTap: () {},
                  child: const _ButtonVerticalMode(),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {},
                  child: const _ButtonHorizontalMode(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ButtonHorizontalMode extends StatelessWidget {
  const _ButtonHorizontalMode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image.asset(
        AppImages.horizontalMode,
        color: AppColors.white.withOpacity(0.5),
        colorBlendMode: BlendMode.modulate,
      ),
    );
  }
}

class _ButtonVerticalMode extends StatelessWidget {
  const _ButtonVerticalMode();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Image.asset(
        AppImages.verticalMode,
      ),
    );
  }
}
