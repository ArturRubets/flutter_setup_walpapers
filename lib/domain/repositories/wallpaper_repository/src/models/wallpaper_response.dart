class WallpaperResponse {
  const WallpaperResponse({
    required this.data,
    required this.meta,
  });

  final List<Wallpaper> data;
  final Meta meta;
}

class Wallpaper {
  const Wallpaper({
    required this.favorites,
    required this.category,
    required this.resolution,
    required this.fileSizeBytes,
    required this.fileType,
    required this.createdAt,
    required this.path,
    required this.thumbs,
  });

  final int favorites;
  final String category;
  final String resolution;
  final int fileSizeBytes;
  final String fileType;
  final String createdAt;
  final String path;
  final Thumbs thumbs;
}

class Thumbs {
  const Thumbs({
    required this.large,
    required this.original,
    required this.small,
  });

  final String large;
  final String original;
  final String small;
}

class Meta {
  const Meta({
    required this.currentPage,
    required this.lastPage,
  });

  final int currentPage;
  final int lastPage;
}
