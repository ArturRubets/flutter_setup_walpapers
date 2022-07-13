import 'package:flutter/material.dart';

import '../../wallpapers_overview/wallpapers_overview.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WallpapersOverviewPage(),
    );
  }
}
