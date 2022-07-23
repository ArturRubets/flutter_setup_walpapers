import 'dart:typed_data';

import '../../../../domain/repositories/wallpaper_repository/src/models/wallpaper_response.dart';

enum WallpaperStatus { initial, loading, downloaded, installedWallpaper }

class WallpaperModelBloc extends WallpaperModelDomain {
  const WallpaperModelBloc({
    required super.favorites,
    required super.category,
    required super.resolution,
    required super.fileSizeBytes,
    required super.createdAt,
    required super.id,
    required super.mainImage,
    required super.thumbs,
    required super.isFromCache,
    required this.wallpaperStatus,
    this.mainImageBytesFromApi = const CacheImageBytes(),
    this.thumbSmallImageBytesFromApi = const CacheImageBytes(),
    this.thumbOriginalImageBytesFromApi = const CacheImageBytes(),
  });

  final WallpaperStatus wallpaperStatus;
  final CacheImageBytes mainImageBytesFromApi;
  final CacheImageBytes thumbSmallImageBytesFromApi;
  final CacheImageBytes thumbOriginalImageBytesFromApi;

  @override
  WallpaperModelBloc copyWith({
    int? favorites,
    String? category,
    String? resolution,
    int? fileSizeBytes,
    String? createdAt,
    String? id,
    ImageWallpaperDomain? mainImage,
    ThumbsDomain? thumbs,
    bool? isFromCache,
    WallpaperStatus? wallpaperStatus,
    CacheImageBytes? mainImageBytesFromApi,
    CacheImageBytes? thumbSmallImageBytesFromApi,
    CacheImageBytes? thumbOriginalImageBytesFromApi,
  }) {
    return WallpaperModelBloc(
      favorites: favorites ?? this.favorites,
      category: category ?? this.category,
      resolution: resolution ?? this.resolution,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      mainImage: mainImage ?? this.mainImage,
      thumbs: thumbs ?? this.thumbs,
      isFromCache: isFromCache ?? this.isFromCache,
      wallpaperStatus: wallpaperStatus ?? this.wallpaperStatus,
      mainImageBytesFromApi:
          mainImageBytesFromApi ?? this.mainImageBytesFromApi,
      thumbSmallImageBytesFromApi:
          thumbSmallImageBytesFromApi ?? this.thumbSmallImageBytesFromApi,
      thumbOriginalImageBytesFromApi:
          thumbOriginalImageBytesFromApi ?? this.thumbOriginalImageBytesFromApi,
    );
  }
}

class CacheImageBytes {
  const CacheImageBytes({this.bytes});

  final Uint8List? bytes;

  CacheImageBytes copyWith({
    Uint8List? bytes,
  }) {
    return CacheImageBytes(
      bytes: bytes ?? this.bytes,
    );
  }
}
