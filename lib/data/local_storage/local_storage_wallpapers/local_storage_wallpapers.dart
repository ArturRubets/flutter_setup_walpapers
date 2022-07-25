import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import 'configuration.dart';
import 'models/wallpaper.dart';

class LocalStorageGetWallpaperNotFoundFailure implements Exception {
  const LocalStorageGetWallpaperNotFoundFailure();
}

class LocalStorageWallpapers {
  LocalStorageWallpapers(this.database, this.sharedPreferences);

  Future<Database> database;
  SharedPreferences sharedPreferences;

  Future<WallpaperLocalStorage?> save(
      WallpaperLocalStorage wallpaperLocalStorage) async {
    final valuesToSave = _encodeWallpapers(wallpaperLocalStorage);
    await _saveImagesWallpaper(wallpaperLocalStorage);

    final db = await database;

    final id = await db.insert(
      sqlTableWallpapers,
      valuesToSave,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id != 0 ? wallpaperLocalStorage : null;
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

  Future<WallpaperLocalStorage> get(String id) async {
    final db = await database;

    try {
      final listWallpapersJson =
          await db.query(sqlTableWallpapers, where: 'id = ?', whereArgs: [id]);
      final wallpapersList =
          await compute(_decodeWallpapers, listWallpapersJson);

      if (wallpapersList.isEmpty) {
        throw const LocalStorageGetWallpaperNotFoundFailure();
      }

      return wallpapersList.first;
    } catch (e) {
      throw const LocalStorageGetWallpaperNotFoundFailure();
    }
  }

  List<WallpaperLocalStorage> _decodeWallpapers(
    List<Map<String, dynamic>> listWallpapersJson,
  ) {
    return List.generate(listWallpapersJson.length, (i) {
      final id = listWallpapersJson[i]['id'] as String;
      final favorites = listWallpapersJson[i]['favorites'] as int;
      final category = listWallpapersJson[i]['category'] as String;
      final resolution = listWallpapersJson[i]['resolution'] as String;
      final fileSizeBytes = listWallpapersJson[i]['fileSizeBytes'] as int;
      final createdAt = listWallpapersJson[i]['createdAt'] as String;
      final isSetWallpaper =
          (listWallpapersJson[i]['isSetWallpaper'] as int) == 1 ? true : false;
      final path = listWallpapersJson[i]['path'] as String;

      List<int> image = base64Decode(_getImageWallpaper(id)!);
      List<int> smallImage = base64Decode(_getSmallImageWallpaper(id)!);
      List<int> originalImage = base64Decode(_getOriginalImageWallpaper(id)!);

      return WallpaperLocalStorage(
        favorites: favorites,
        category: category,
        resolution: resolution,
        fileSizeBytes: fileSizeBytes,
        createdAt: createdAt,
        imageBytes: image,
        thumbs: ThumbsLocalStorage(
          smallImageBytes: smallImage,
          originalImageBytes: originalImage,
        ),
        id: id,
        isSetWallpaper: isSetWallpaper,
        path: path,
      );
    });
  }

  Map<String, Object> _encodeWallpapers(
    WallpaperLocalStorage wallpaperLocalStorage,
  ) {
    return {
      'id': wallpaperLocalStorage.id,
      'favorites': wallpaperLocalStorage.favorites,
      'category': wallpaperLocalStorage.category,
      'resolution': wallpaperLocalStorage.resolution,
      'fileSizeBytes': wallpaperLocalStorage.fileSizeBytes,
      'createdAt': wallpaperLocalStorage.createdAt,
      'isSetWallpaper': wallpaperLocalStorage.isSetWallpaper ? 1 : 0,
      'path': wallpaperLocalStorage.path,
    };
  }

  Future<void> _saveImagesWallpaper(
    WallpaperLocalStorage wallpaperLocalStorage,
  ) async {
    await sharedPreferences.setString(
      '${wallpaperLocalStorage.id}_image',
      base64Encode(wallpaperLocalStorage.imageBytes),
    );
    await sharedPreferences.setString(
      '${wallpaperLocalStorage.id}_small_image',
      base64Encode(wallpaperLocalStorage.thumbs.smallImageBytes),
    );
    await sharedPreferences.setString(
      '${wallpaperLocalStorage.id}_original_image',
      base64Encode(wallpaperLocalStorage.thumbs.originalImageBytes),
    );
  }

  String? _getImageWallpaper(String wallpaperId) =>
      sharedPreferences.getString('${wallpaperId}_image');

  String? _getSmallImageWallpaper(String wallpaperId) =>
      sharedPreferences.getString('${wallpaperId}_small_image');

  String? _getOriginalImageWallpaper(String wallpaperId) =>
      sharedPreferences.getString('${wallpaperId}_original_image');
}
