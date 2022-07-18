// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// enum WallpaperDownload { initial, loading, success, failure }

// abstract class Wallpaper {
//   const Wallpaper({
//     required this.favorites,
//     required this.category,
//     required this.resolution,
//     required this.fileSizeBytes,
//     required this.createdAt,
//     required this.id,
//     required this.path,
//     required this.imageBytes,
//     required this.isFromCache,
//     required this.wallpaperDownload,
//   });

//   final int favorites;
//   final String category;
//   final String resolution;
//   final int fileSizeBytes;
//   final String createdAt;
//   final String id;
//   final String? path;
//   final List<int>? imageBytes;
//   final bool isFromCache;
//   final WallpaperDownload wallpaperDownload;

//   Image? getMainImageWidget();

//   Wallpaper copyWith({
//     WallpaperDownload? wallpaperDownload,
//   });
// }
