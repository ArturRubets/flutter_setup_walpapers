// import 'dart:typed_data';

// import 'package:flutter/material.dart';

// import '../../interfaces/wallpaper.dart';

// class WallpaperDetailModelBloc implements Wallpaper {
//   const WallpaperDetailModelBloc({
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

//   @override
//   final int favorites;
//   @override
//   final String category;
//   @override
//   final String resolution;
//   @override
//   final int fileSizeBytes;
//   @override
//   final String createdAt;
//   @override
//   final String id;
//   @override
//   final String? path;
//   @override
//   final List<int>? imageBytes;
//   @override
//   final bool isFromCache;
//   @override
//   final WallpaperDownload wallpaperDownload;

//   @override
//   Image? getMainImageWidget() => getImageWidget(imageBytes, path);
// }

// Image? getImageWidget(List<int>? imageBytes, String? path) {
//   Image? image;
//   if (imageBytes != null) {
//     image = Image.memory(
//       Uint8List.fromList(imageBytes),
//       fit: BoxFit.cover,
//     );
//   } else if (path != null) {
//     image = Image.network(
//       path,
//       fit: BoxFit.cover,
//     );
//   }
//   return image;
// }
