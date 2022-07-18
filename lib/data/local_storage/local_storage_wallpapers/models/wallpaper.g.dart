// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallpaperLocalStorage _$WallpaperLocalStorageFromJson(
        Map<String, dynamic> json) =>
    WallpaperLocalStorage(
      favorites: json['favorites'] as int,
      category: json['category'] as String,
      resolution: json['resolution'] as String,
      fileSizeBytes: json['fileSizeBytes'] as int,
      createdAt: json['createdAt'] as String,
      imageBytes:
          (json['imageBytes'] as List<dynamic>).map((e) => e as int).toList(),
      thumbs:
          ThumbsLocalStorage.fromJson(json['thumbs'] as Map<String, dynamic>),
      id: json['id'] as String,
    );

Map<String, dynamic> _$WallpaperLocalStorageToJson(
        WallpaperLocalStorage instance) =>
    <String, dynamic>{
      'favorites': instance.favorites,
      'category': instance.category,
      'resolution': instance.resolution,
      'fileSizeBytes': instance.fileSizeBytes,
      'createdAt': instance.createdAt,
      'thumbs': instance.thumbs,
      'id': instance.id,
      'imageBytes': instance.imageBytes,
    };

ThumbsLocalStorage _$ThumbsLocalStorageFromJson(Map<String, dynamic> json) =>
    ThumbsLocalStorage(
      largeImageBytes: (json['largeImageBytes'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
      originalImageBytes: (json['originalImageBytes'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      smallImageBytes: (json['smallImageBytes'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$ThumbsLocalStorageToJson(ThumbsLocalStorage instance) =>
    <String, dynamic>{
      'largeImageBytes': instance.largeImageBytes,
      'originalImageBytes': instance.originalImageBytes,
      'smallImageBytes': instance.smallImageBytes,
    };
