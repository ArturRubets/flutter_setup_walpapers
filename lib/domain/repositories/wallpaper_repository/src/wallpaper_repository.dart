import 'dart:typed_data';

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
    return await _localStorageWallpapers.getWallpaper(id);
  }

  Future<Uint8List?> imageFromNetworkInBytes(String path) async {
    return await _wallhavenApiClient.imageFromNetworkInBytes(path);
  }

  Future<bool> saveWallpaperInStorage(
    WallpaperModelDomain wallpaper, [
    Uint8List? mainImageBytes,
    Uint8List? thumbSmallImageBytes,
    Uint8List? thumbOriginalImageBytes,
  ]) async {
    final pathMainImage = wallpaper.mainImage?.path;
    final pathThumbSmall = wallpaper.thumbs?.thumbSmall?.path;
    final pathThumbOrigin = wallpaper.thumbs?.thumbOrigin?.path;

    if (pathMainImage != null &&
        pathThumbSmall != null &&
        pathThumbOrigin != null) {
      final imageMain = mainImageBytes ??
          await _wallhavenApiClient.imageFromNetworkInBytes(pathMainImage);

      final thumbSmallImage = thumbSmallImageBytes ??
          await _wallhavenApiClient.imageFromNetworkInBytes(pathThumbSmall);

      final thumbOriginalImage = thumbOriginalImageBytes ??
          await _wallhavenApiClient.imageFromNetworkInBytes(pathThumbOrigin);

      return _localStorageWallpapers.saveWallpaper(
        WallpaperLocalStorage(
          id: wallpaper.id,
          favorites: wallpaper.favorites,
          category: wallpaper.category,
          resolution: wallpaper.resolution,
          fileSizeBytes: wallpaper.fileSizeBytes,
          createdAt: wallpaper.createdAt,
          imageBytes: imageMain!,
          thumbs: ThumbsLocalStorage(
            smallImageBytes: thumbSmallImage!,
            originalImageBytes: thumbOriginalImage!,
          ),
          isSetWallpaper: false,
        ),
      );
    }
    return false;
  }
}
