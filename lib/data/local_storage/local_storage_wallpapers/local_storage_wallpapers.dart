import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/wallpaper.dart';

class LocalStorageWallpapers {
  LocalStorageWallpapers({required SharedPreferences plugin})
      : _plugin = plugin {
    _init();
  }

  final SharedPreferences _plugin;

  final _wallpapers = <WallpaperLocalStorage>[];

  static const kWallpapersCollectionKey = '__wallpapers_collection_key__';

  void _init() {
    final jsonWallpapers = _getValue(kWallpapersCollectionKey);
    if (jsonWallpapers != null) {
      final wallpapersJson =
          List<Map<String, dynamic>>.from(json.decode(jsonWallpapers) as List);

      final wallpapers =
          wallpapersJson.map(WallpaperLocalStorage.fromJson).toList();
      _wallpapers.addAll(wallpapers);
    }
  }

  String? _getValue(String key) => _plugin.getString(key);

  Future<void> _setValue(String key, String value) =>
      _plugin.setString(key, value);

  List<WallpaperLocalStorage> getWallpapers() => _wallpapers;

  Future<void> saveWallpaper(WallpaperLocalStorage wallpaper) async {
    final wallpapers = [..._wallpapers];
    final todoIndex = wallpapers.indexWhere((w) => w.id == wallpaper.id);
    if (todoIndex >= 0) {
      wallpapers[todoIndex] = wallpaper;
    } else {
      wallpapers.add(wallpaper);
    }

    _wallpapers
      ..clear()
      ..addAll(wallpapers);

    await _setValue(kWallpapersCollectionKey, json.encode(wallpapers));
  }
}
