import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../screens/wallpaper_detail/view/wallpaper_detail_page.dart';
import '../screens/wallpapers/bloc/wallpapers_bloc.dart';
import '../screens/wallpapers/wallpapers.dart';

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
        final argumentsWallpaperDetail =
            arguments is ArgumentsWallpaperDetail ? arguments : null;

        final bloc = argumentsWallpaperDetail?.bloc;
        final wallpaperId = argumentsWallpaperDetail?.wallpaperId;

        if (bloc == null || wallpaperId == null) {
          return MaterialPageRoute(
            builder: (_) => const WallpapersPage(),
          );
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: bloc,
            child: WallpaperDetailPage(wallpaperId: wallpaperId),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Text('Navigation error'),
        );
    }
  }
}

class ArgumentsWallpaperDetail {
  ArgumentsWallpaperDetail({
    required this.bloc,
    required this.wallpaperId,
  });

  final WallpapersBloc bloc;
  final String wallpaperId;
}
