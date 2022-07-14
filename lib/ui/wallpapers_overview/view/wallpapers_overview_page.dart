import 'package:flutter/material.dart';

import '../../../resources/resources.dart';

class WallpapersOverviewPage extends StatelessWidget {
  const WallpapersOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const AppBar(),
            Row(
              children: [
                Container(
                  color: Colors.grey,
                  width: 100,
                  height: 100,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class AppBar extends StatelessWidget {
  const AppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24,
        top: 28,
        right: 24,
        bottom: 18,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Wallpapers',
                  style: AppTextStyle.title,
                ),
                Text(
                  'Find the best wallpapers for you',
                  style: AppTextStyle.subtitle,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 375 - 210,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.greySoft,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  width: 93,
                  height: 40,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          print("Container was tapped");
                        },
                        child: Container(
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
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          print("Container was tapped");
                        },
                        child: Container(
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
