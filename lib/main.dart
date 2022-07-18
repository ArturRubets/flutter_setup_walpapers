import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/api/wallhaven_api/src/wallhaven_api_client.dart';
import 'data/local_storage/local_storage_wallpapers/local_storage_wallpapers.dart';
import 'domain/repositories/wallpaper_repository/src/wallpaper_repository.dart';
import 'ui/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final wallhavenApiClient = WallhavenApiClient();
  final localStorageWallpapers = LocalStorageWallpapers(
    plugin: await SharedPreferences.getInstance(),
  );
  final wallpaperRepository =
      WallpaperRepository(wallhavenApiClient, localStorageWallpapers);

  runApp(App(wallpaperRepository: wallpaperRepository));
}
