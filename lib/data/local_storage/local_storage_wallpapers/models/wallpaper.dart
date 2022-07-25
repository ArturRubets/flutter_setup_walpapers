import 'package:json_annotation/json_annotation.dart';

part 'wallpaper.g.dart';

@JsonSerializable()
class WallpaperLocalStorage {
  const WallpaperLocalStorage({
    required this.favorites,
    required this.category,
    required this.resolution,
    required this.fileSizeBytes,
    required this.createdAt,
    required this.imageBytes,
    required this.thumbs,
    required this.id,
    required this.isSetWallpaper,
    required this.path,
  });

  factory WallpaperLocalStorage.fromJson(Map<String, dynamic> json) =>
      _$WallpaperLocalStorageFromJson(json);

  final int favorites;
  final String category;
  final String resolution;
  final int fileSizeBytes;
  final String createdAt;
  final ThumbsLocalStorage thumbs;
  final String id;
  final List<int> imageBytes;
  final bool isSetWallpaper;
  final String path;

  Map<String, dynamic> toJson() => _$WallpaperLocalStorageToJson(this);
}

@JsonSerializable()
class ThumbsLocalStorage {
  const ThumbsLocalStorage({
    required this.smallImageBytes,
    required this.originalImageBytes,
  });

  factory ThumbsLocalStorage.fromJson(Map<String, dynamic> json) =>
      _$ThumbsLocalStorageFromJson(json);

  final List<int> smallImageBytes;
  final List<int> originalImageBytes;

  Map<String, dynamic> toJson() => _$ThumbsLocalStorageToJson(this);
}
