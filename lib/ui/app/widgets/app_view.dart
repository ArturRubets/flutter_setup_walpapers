import 'package:flutter/material.dart';

import '../../wallpapers/wallpapers.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WallpapersPage(),
    );
  }
}
