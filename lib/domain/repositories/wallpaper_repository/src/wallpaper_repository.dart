import 'dart:typed_data';

import 'package:wallpaper/wallpaper.dart';

import '../../../../data/api/wallhaven_api/configuration.dart';
import '../../../../data/api/wallhaven_api/wallhaven_api_client.dart';
import '../../../../data/local_storage/local_storage_wallpapers/local_storage_wallpapers.dart';
import '../../../../data/local_storage/local_storage_wallpapers/models/wallpaper.dart';
import 'models/wallpaper_response.dart';

class WallpaperNotFoundFailure implements Exception {}

class WallpaperRepository {
  WallpaperRepository(
    this._wallhavenApiClient,
    this._localStorageWallpapers,
  );

  final WallhavenApiClient _wallhavenApiClient;
  final LocalStorageWallpapers _localStorageWallpapers;

  Future<WallpaperResponseDomain> getWallpaperFromApi(int page) async {
    final wallpaperApiResponse = await _wallhavenApiClient.wallpaper(
      page,
      Configuration.apiKey,
    );
    final data = wallpaperApiResponse.data.map((w) {
      return WallpaperModelDomain(
        favorites: w.favorites,
        category: w.category,
        resolution: w.resolution,
        fileSizeBytes: w.fileSize,
        createdAt: w.createdAt,
        id: w.id,
        mainImage: ImageWallpaperDomain(
          path: w.path,
          bytes: null,
        ),
        thumbs: ThumbsDomain(
          thumbOrigin: ImageWallpaperDomain(path: w.thumbs.original),
          thumbSmall: ImageWallpaperDomain(path: w.thumbs.small),
        ),
        isFromCache: false,
      );
    }).toList();

    if (data.isEmpty) {
      throw WallpaperNotFoundFailure();
    }

    final meta = MetaDomain(
      currentPage: wallpaperApiResponse.meta.currentPage,
      lastPage: wallpaperApiResponse.meta.lastPage,
    );

    return WallpaperResponseDomain(data: data, meta: meta);
  }

  Future<List<WallpaperLocalStorage>> getWallpapersFromStorage(
    int page, [
    int limit = 24,
  ]) async {
    return await _localStorageWallpapers.getWallpapers(page, limit);
  }

  Future<WallpaperLocalStorage> getWallpaperFromStorage(String id) async {
    return await _localStorageWallpapers.get(id);
  }

  Future<Uint8List?> imageFromNetworkInBytes(String path) async {
    return await _wallhavenApiClient.imageFromNetworkInBytes(path);
  }

  Future<WallpaperLocalStorage?> saveWallpaperInStorage(
    WallpaperModelDomain wallpaper,
    bool isSetWallpaper,
  ) async {
    try {
      final imagesBytes = await _getImagesBytes(wallpaper);
      return _localStorageWallpapers.save(
        WallpaperLocalStorage(
          id: wallpaper.id,
          favorites: wallpaper.favorites,
          category: wallpaper.category,
          resolution: wallpaper.resolution,
          fileSizeBytes: wallpaper.fileSizeBytes,
          createdAt: wallpaper.createdAt,
          imageBytes: imagesBytes.imageMainBytes,
          thumbs: ThumbsLocalStorage(
            smallImageBytes: imagesBytes.thumbSmallBytes,
            originalImageBytes: imagesBytes.thumbOriginalBytes,
          ),
          isSetWallpaper: isSetWallpaper,
          path: wallpaper.mainImage.path,
        ),
      );
    } catch (e) {
      return null;
    }
  }

  Future<bool> setWallpaper(
    String path, [
    int location = 1,
  ]) async {
    try {
      // ignore: unused_local_variable
      await for (final value in Wallpaper.imageDownloadProgress(path)) {}
      await Wallpaper.homeScreen();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<ImagesBytes> _getImagesBytes(WallpaperModelDomain wallpaper) async {
    final imageMain = wallpaper.mainImage.bytes ??
        await _wallhavenApiClient
            .imageFromNetworkInBytes(wallpaper.mainImage.path);

    final thumbSmallImage = wallpaper.thumbs.thumbSmall.bytes ??
        await _wallhavenApiClient
            .imageFromNetworkInBytes(wallpaper.thumbs.thumbSmall.path);

    final thumbOriginalImage = wallpaper.thumbs.thumbOrigin.bytes ??
        await _wallhavenApiClient
            .imageFromNetworkInBytes(wallpaper.thumbs.thumbOrigin.path);

    if (imageMain == null ||
        thumbSmallImage == null ||
        thumbOriginalImage == null) throw BytesNotFoundFailure();

    return ImagesBytes(
      imageMainBytes: imageMain,
      thumbSmallBytes: thumbSmallImage,
      thumbOriginalBytes: thumbOriginalImage,
    );
  }
}

class ImagesBytes {
  ImagesBytes({
    required this.imageMainBytes,
    required this.thumbSmallBytes,
    required this.thumbOriginalBytes,
  });

  final Uint8List imageMainBytes;
  final Uint8List thumbSmallBytes;
  final Uint8List thumbOriginalBytes;
}

class BytesNotFoundFailure implements Exception {}
