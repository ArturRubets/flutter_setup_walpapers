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

  Map<String, dynamic> toJson() => _$WallpaperLocalStorageToJson(this);
}

@JsonSerializable()
class ThumbsLocalStorage {
  const ThumbsLocalStorage({
    required this.largeImageBytes,
    required this.originalImageBytes,
    required this.smallImageBytes,
  });

  factory ThumbsLocalStorage.fromJson(Map<String, dynamic> json) =>
      _$ThumbsLocalStorageFromJson(json);

  final List<int>? largeImageBytes;
  final List<int> originalImageBytes;
  final List<int> smallImageBytes;

  Map<String, dynamic> toJson() => _$ThumbsLocalStorageToJson(this);
}