import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/wallpaper_repository/wallpaper_repository.dart';
import 'widgets/app_view.dart';

class App extends StatelessWidget {
  const App({super.key, required this.wallpaperRepository});

  final WallpaperRepository wallpaperRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: wallpaperRepository,
      child: const AppView(),
    );
  }
}