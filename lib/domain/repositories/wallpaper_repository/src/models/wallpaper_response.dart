class WallpaperResponseDomain {
  const WallpaperResponseDomain({
    required this.data,
    required this.meta,
  });

  final List<WallpaperDomain> data;
  final MetaDomain meta;
}

class WallpaperDomain {
  const WallpaperDomain({
    required this.favorites,
    required this.category,
    required this.resolution,
    required this.fileSizeBytes,
    required this.createdAt,
    required this.path,
    required this.thumbs,
    required this.id,
  });

  final int favorites;
  final String category;
  final String resolution;
  final int fileSizeBytes;
  final String createdAt;
  final String path;
  final ThumbsDomain thumbs;
  final String id;
}

class ThumbsDomain {
  const ThumbsDomain({
    required this.large,
    required this.original,
    required this.small,
  });

  final String large;
  final String original;
  final String small;
}

class MetaDomain {
  const MetaDomain({
    required this.currentPage,
    required this.lastPage,
  });

  final int currentPage;
  final int lastPage;
}
