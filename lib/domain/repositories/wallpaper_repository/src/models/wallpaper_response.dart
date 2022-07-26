import 'dart:typed_data';

class WallpaperResponseDomain {
  const WallpaperResponseDomain({
    required this.data,
    required this.meta,
  });

  final List<WallpaperModelDomain> data;
  final MetaDomain meta;

  WallpaperResponseDomain copyWith({
    List<WallpaperModelDomain>? data,
    MetaDomain? meta,
  }) =>
      WallpaperResponseDomain(
        data: data ?? this.data,
        meta: meta ?? this.meta,
      );
}

class WallpaperModelDomain {
  const WallpaperModelDomain({
    required this.favorites,
    required this.category,
    required this.resolution,
    required this.fileSizeBytes,
    required this.createdAt,
    required this.id,
    required this.mainImage,
    required this.thumbs,
    required this.isFromCache,
  });

  final int favorites;
  final String category;
  final String resolution;
  final int fileSizeBytes;
  final String createdAt;
  final String id;
  final ImageWallpaperDomain mainImage;
  final ThumbsDomain thumbs;
  final bool isFromCache;

  WallpaperModelDomain copyWith({
    int? favorites,
    String? category,
    String? resolution,
    int? fileSizeBytes,
    String? createdAt,
    String? id,
    ImageWallpaperDomain? mainImage,
    ThumbsDomain? thumbs,
    bool? isFromCache,
  }) =>
      WallpaperModelDomain(
        favorites: favorites ?? this.favorites,
        category: category ?? this.category,
        resolution: resolution ?? this.resolution,
        fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
        createdAt: createdAt ?? this.createdAt,
        id: id ?? this.id,
        mainImage: mainImage ?? this.mainImage,
        thumbs: thumbs ?? this.thumbs,
        isFromCache: isFromCache ?? this.isFromCache,
      );
}

class ThumbsDomain {
  const ThumbsDomain({
    required this.thumbSmall,
    required this.thumbOrigin,
  });

  final ImageWallpaperDomain thumbSmall;
  final ImageWallpaperDomain thumbOrigin;

  ThumbsDomain copyWith({
    ImageWallpaperDomain? thumbSmall,
    ImageWallpaperDomain? thumbOrigin,
  }) =>
      ThumbsDomain(
        thumbSmall: thumbSmall ?? this.thumbSmall,
        thumbOrigin: thumbOrigin ?? this.thumbOrigin,
      );
}

class MetaDomain {
  const MetaDomain({
    required this.currentPage,
    required this.lastPage,
  });

  final int currentPage;
  final int lastPage;

  MetaDomain copyWith({
    int? currentPage,
    int? lastPage,
  }) =>
      MetaDomain(
        currentPage: currentPage ?? this.currentPage,
        lastPage: lastPage ?? this.lastPage,
      );
}

class ImageWallpaperDomain {
  const ImageWallpaperDomain({
    required this.path,
    this.bytes,
  });

  final String path;
  final Uint8List? bytes;

  ImageWallpaperDomain copyWith({
    String? path,
    Uint8List? bytes,
  }) =>
      ImageWallpaperDomain(
        path: path ?? this.path,
        bytes: bytes ?? this.bytes,
      );
}
