import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'data/api/wallhaven_api/wallhaven_api_client.dart';
import 'data/local_storage/local_storage_wallpapers/configuration.dart';
import 'data/local_storage/local_storage_wallpapers/local_storage_wallpapers.dart';
import 'domain/repositories/wallpaper_repository/src/wallpaper_repository.dart';
import 'ui/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  final database = openDatabase(
    join(await getDatabasesPath(), nameDatabaseFile),
    onCreate: (db, version) {
      return db.execute(sqlQueryCreateTable);
    },
    version: 1,
  );

  final wallhavenApiClient = WallhavenApiClient();
  final wallpapersLocalStorage = LocalStorageWallpapers(database);
  final wallpaperRepository =
      WallpaperRepository(wallhavenApiClient, wallpapersLocalStorage);

  runApp(App(wallpaperRepository: wallpaperRepository));
}

class A {
  A(this.a);

  final int a;
}
