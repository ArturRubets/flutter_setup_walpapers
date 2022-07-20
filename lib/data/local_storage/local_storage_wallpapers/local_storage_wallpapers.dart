import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'configuration.dart';
import 'models/wallpaper.dart';

class LocalStorageWallpapers {
  LocalStorageWallpapers(this.database);

  Future<Database> database;

  Future<void> saveWallpaper(
    WallpaperLocalStorage wallpaperLocalStorage,
  ) async {
    final json = await compute(encodeWallpapers, wallpaperLocalStorage);

    final valuesToSave = {
      'id': int.tryParse(wallpaperLocalStorage.id),
      'json': json,
    };

    final db = await database;

    await db.insert(
      sqlTableWallpapers,
      valuesToSave,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  Future<String> encodeWallpapers(
    WallpaperLocalStorage wallpaper,
  ) async {
    return json.encode(wallpaper);
  }

  Future<List<WallpaperLocalStorage>> getWallpapers() async {
    final db = await database;

    final listWallpapersJson = await db.query(sqlTableWallpapers);

    final wallpapersList = await compute(decodeWallpapers, listWallpapersJson);

    return wallpapersList;
  }

  Future<List<WallpaperLocalStorage>> decodeWallpapers(
    List<Map<String, dynamic>> listWallpapersJson,
  ) async {
    return List.generate(listWallpapersJson.length, (i) {
      final rawJson = listWallpapersJson[i]['json'] as String;
      final map = json.decode(rawJson) as Map<String, dynamic>;

      return WallpaperLocalStorage.fromJson(map);
    });
  }
}
