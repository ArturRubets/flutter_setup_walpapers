import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'domain/repositories/wallpaper_repository/src/wallpaper_repository.dart';
import 'ui/app/app.dart';

//TODO в айпаде landscape режим
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);

  final wallpaperRepository = WallpaperRepository();

  runApp(App(wallpaperRepository: wallpaperRepository));
}
