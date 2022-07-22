import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/wallpaper_repository/src/wallpaper_repository.dart';
import '../screens/wallpaper_detail/bloc/wallpaper_detail_bloc.dart';
import '../screens/wallpaper_detail/view/wallpaper_detail_page.dart';
import '../screens/wallpapers/models/wallpaper_response.dart';
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
        final wallpaper = arguments is WallpaperModelBloc ? arguments : null;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => WallpaperDetailBloc(
                context.read<WallpaperRepository>(), wallpaper!),
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
