import 'package:flutter/material.dart';

import '../../themes/themes.dart';

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
                  style: ,
                ),
                Text(
                  'Find the best wallpapers for you',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontWeight: FontWeight.w400,
                    fontStyle: FontStyle.normal,
                    fontSize: 12,
                    height: 20 / 12,
                    letterSpacing: 12 * 0.03,
                    color: Color(0xFF252b5c),
                  ),
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
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F4F8),
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
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFFFFF),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                            'assets/images/vertical_mode.png',
                          ),
                        ),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          print("Container was tapped");
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Image.asset(
                            'assets/images/horizontal_mode.png',
                            color: Colors.white.withOpacity(0.5),
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
