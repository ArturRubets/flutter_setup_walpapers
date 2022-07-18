import 'dart:typed_data';

import 'package:flutter/material.dart';

class WallpaperResponseBloc {
  const WallpaperResponseBloc({
    required this.data,
    required this.meta,
  });

  final List<WallpaperModelBloc> data;
  final MetaBloc meta;

  WallpaperResponseBloc copyWith({
    List<WallpaperModelBloc>? data,
    MetaBloc? meta,
  }) {
    return WallpaperResponseBloc(
      data: data ?? this.data,
      meta: meta ?? this.meta,
    );
  }
}

enum WallpaperDownload { initial, loading, success, failure }

class WallpaperModelBloc {
  const WallpaperModelBloc({
    required this.favorites,
    required this.category,
    required this.resolution,
    required this.fileSizeBytes,
    required this.createdAt,
    required this.id,
    required this.path,
    required this.imageBytes,
    required this.thumbs,
    required this.isFromCache,
    required this.wallpaperDownload,
  });

  final int favorites;
  final String category;
  final String resolution;
  final int fileSizeBytes;
  final String createdAt;
  final String id;
  final String? path;
  final List<int>? imageBytes;
  final ThumbsBloc thumbs;
  final bool isFromCache;
  final WallpaperDownload wallpaperDownload;

  Image? getMainImageWidget() => getImageWidget(imageBytes, path);

  WallpaperModelBloc copyWith({
    int? favorites,
    String? category,
    String? resolution,
    int? fileSizeBytes,
    String? createdAt,
    String? id,
    String? path,
    List<int>? imageBytes,
    ThumbsBloc? thumbs,
    bool? isFromCache,
    WallpaperDownload? wallpaperDownload,
  }) {
    return WallpaperModelBloc(
      favorites: favorites ?? this.favorites,
      category: category ?? this.category,
      resolution: resolution ?? this.resolution,
      fileSizeBytes: fileSizeBytes ?? this.fileSizeBytes,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      path: path ?? this.path,
      imageBytes: imageBytes ?? this.imageBytes,
      thumbs: thumbs ?? this.thumbs,
      isFromCache: isFromCache ?? this.isFromCache,
      wallpaperDownload: wallpaperDownload ?? this.wallpaperDownload,
    );
  }
}

class ThumbsBloc {
  ThumbsBloc({
    required this.small,
    required this.original,
    required this.thumbSmallBytes,
    required this.thumbOriginalBytes,
  });

  final String? small;
  final String? original;
  final List<int>? thumbSmallBytes;
  final List<int>? thumbOriginalBytes;

  Image? getSmallImageWidget() => getImageWidget(thumbSmallBytes, small);
  Image? getOriginImageWidget() => getImageWidget(thumbOriginalBytes, original);
}

class MetaBloc {
  const MetaBloc({
    required this.currentPage,
    required this.lastPage,
  });

  final int currentPage;
  final int lastPage;
}

Image? getImageWidget(List<int>? imageBytes, String? path) {
  Image? image;
  if (imageBytes != null) {
    image = Image.memory(
      Uint8List.fromList(imageBytes),
      fit: BoxFit.cover,
    );
  } else if (path != null) {
    image = Image.network(
      path,
      fit: BoxFit.cover,
    );
  }
  return image;
}
