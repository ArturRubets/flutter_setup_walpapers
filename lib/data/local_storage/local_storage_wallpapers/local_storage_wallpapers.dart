import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import 'configuration.dart';
import 'models/wallpaper.dart';

class LocalStorageGetWallpaperNotFoundFailure implements Exception {
  const LocalStorageGetWallpaperNotFoundFailure();
}

class LocalStorageWallpapers {
  LocalStorageWallpapers(this.database);

  Future<Database> database;

  Future<bool> saveWallpaper(
    WallpaperLocalStorage wallpaperLocalStorage,
  ) async {
    final json = await compute(_encodeWallpapers, wallpaperLocalStorage);

    final valuesToSave = {
      'id': wallpaperLocalStorage.id,
      'json': json,
    };

    final db = await database;

    final id = await db.insert(
      sqlTableWallpapers,
      valuesToSave,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    return id != 0;
  }

  Future<String> _encodeWallpapers(
    WallpaperLocalStorage wallpaper,
  ) async {
    return json.encode(wallpaper);
  }

  Future<List<WallpaperLocalStorage>> getWallpapers(
    int page, [
    int limit = 24,
  ]) async {
    final db = await database;

    final offset = (page - 1) * limit;
    final listWallpapersJson = await db.query(
      sqlTableWallpapers,
      limit: limit,
      offset: offset,
    );

    final wallpapersList = await compute(_decodeWallpapers, listWallpapersJson);
  
    return wallpapersList;
  }

  Future<List<WallpaperLocalStorage>> _decodeWallpapers(
    List<Map<String, dynamic>> listWallpapersJson,
  ) async {
    return List.generate(listWallpapersJson.length, (i) {
      final rawJson = listWallpapersJson[i]['json'] as String;
      final map = json.decode(rawJson) as Map<String, dynamic>;

      return WallpaperLocalStorage.fromJson(map);
    });
  }

  Future<WallpaperLocalStorage> getWallpaper(String id) async {
    final db = await database;

    final listWallpapersJson =
        await db.query(sqlTableWallpapers, where: 'id = ?', whereArgs: [id]);

    final wallpapersList = await compute(_decodeWallpapers, listWallpapersJson);

    if (wallpapersList.isEmpty) {
      throw const LocalStorageGetWallpaperNotFoundFailure();
    }

    return wallpapersList.first;
  }
}
