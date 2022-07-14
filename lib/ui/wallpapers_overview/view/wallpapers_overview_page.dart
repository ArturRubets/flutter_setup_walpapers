import 'package:flutter/material.dart';

import '../../../resources/resources.dart';
import '../widgets/widgets.dart';

class WallpapersOverviewPage extends StatelessWidget {
  const WallpapersOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const AppBarWidget(),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Wrap(
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runSpacing: 7,
                      spacing: 7,
                      children: const [
                        Wallpaper(),
                        Wallpaper(),
                        Wallpaper(),
                        Wallpaper(),
                        Wallpaper(),
                        Wallpaper(),
                        Wallpaper(),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
