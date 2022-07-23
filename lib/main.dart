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

  // String path2 = join(await getDatabasesPath(), 'demo.db');

  // await deleteDatabase(path2);

  final pathToDatabase = join(await getDatabasesPath(), nameDatabaseFile);

  await deleteDatabase(pathToDatabase);

  // final table = sqlTableWallpapers;

  final database = openDatabase(
    pathToDatabase,
    version: 1,
    onCreate: (db, version) async {
      await db.execute(sqlQueryCreateTable);
    },
  );

  // await database.transaction((txn) async {
  //   final id1 =
  //       await txn.rawInsert('INSERT INTO $table(json) VALUES("some name")');
  //   print('inserted1: $id1');
  // });

  // List<Map> list =
  //     await (await database).rawQuery('SELECT * FROM $sqlTableWallpapers');
  // print(list);

  final wallhavenApiClient = WallhavenApiClient();
  final wallpapersLocalStorage = LocalStorageWallpapers(database);
  final wallpaperRepository =
      WallpaperRepository(wallhavenApiClient, wallpapersLocalStorage);

  runApp(App(wallpaperRepository: wallpaperRepository));
}
