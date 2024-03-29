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
  });

  final WallpaperStatus wallpaperStatus;

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
    );
  }
}
