import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/repositories/wallpaper_repository/src/models/wallpaper_response.dart';
import '../wallpaper_detail/view/wallpaper_detail_page.dart';
import '../wallpapers/wallpapers.dart';

abstract class MainNavigationRouteNames {
  static const wallpapersScreen = '/';
  static const wallpaperScreenDetail = '/wallpaper_screen_detail';
}

abstract class MainNavigation {
  static Route<Object> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case MainNavigationRouteNames.wallpapersScreen:
        return MaterialPageRoute(
          builder: (_) => const WallpapersPage(),
        );
      case MainNavigationRouteNames.wallpaperScreenDetail:
        final arguments = settings.arguments;
        final wallpaper = arguments is Wallpaper ? arguments : null;
        return MaterialPageRoute(
          builder: (_) => Provider(
            create: (context) => wallpaper,
            child: const WallpaperDetailPage(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Text('Navigation error'),
        );
    }
  }
}
