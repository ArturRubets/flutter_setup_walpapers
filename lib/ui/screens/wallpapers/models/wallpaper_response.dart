import '../../../../domain/repositories/wallpaper_repository/src/models/wallpaper_response.dart';

enum WallpaperStatus { initial, loading, downloaded, installedWallpaper }

class WallpaperModelBloc extends WallpaperModelDomain {
  const WallpaperModelBloc({
    required int favorites,
    required String category,
    required String resolution,
    required int fileSizeBytes,
    required String createdAt,
    required String id,
    required ImageWallpaperDomain mainImage,
    required ThumbsDomain thumbs,
    required bool isFromCache,
    required this.wallpaperStatus,
  }) : super(
          favorites: favorites,
          category: category,
          resolution: resolution,
          fileSizeBytes: fileSizeBytes,
          createdAt: createdAt,
          id: id,
          mainImage: mainImage,
          thumbs: thumbs,
          isFromCache: isFromCache,
        );

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
