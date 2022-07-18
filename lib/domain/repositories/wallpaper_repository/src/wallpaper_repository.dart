import '../../../../data/api/wallhaven_api/src/configuration.dart';
import '../../../../data/api/wallhaven_api/src/wallhaven_api_client.dart';
import '../../../../data/local_storage/local_storage_wallpapers/local_storage_wallpapers.dart';
import '../../../../data/local_storage/local_storage_wallpapers/models/wallpaper.dart';
import '../../../../ui/wallpapers/models/wallpaper.dart';
import 'models/wallpaper_response.dart';

class WallpaperNotFoundFailure implements Exception {}

class WallpaperRepository {
  WallpaperRepository(
    this._wallhavenApiClient,
    this._localStorageWallpapers,
  );

  final WallhavenApiClient _wallhavenApiClient;
  final LocalStorageWallpapers _localStorageWallpapers;

  Future<WallpaperResponseDomain> getWallpaper(int page) async {
    final wallpaperApiResponse = await _wallhavenApiClient.wallpaper(
      page,
      Configuration.apiKey,
    );
    final data = wallpaperApiResponse.data.map((w) {
      return WallpaperDomain(
        favorites: w.favorites,
        category: w.category,
        resolution: w.resolution,
        fileSizeBytes: w.fileSize,
        createdAt: w.createdAt,
        path: w.path,
        id: w.id,
        thumbs: ThumbsDomain(
          large: w.thumbs.large,
          original: w.thumbs.large,
          small: w.thumbs.small,
        ),
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

  List<WallpaperLocalStorage> getWallpaperFromStorage() {
    return _localStorageWallpapers.getWallpapers();
  }

  Future<void> saveWallpaperInStorage(WallpaperModelBloc wallpaperBloc) async {
    final pathMainImage = wallpaperBloc.path;
    final pathThumbSmall = wallpaperBloc.thumbs.small;
    final pathThumbOrigin = wallpaperBloc.thumbs.original;

    if (!wallpaperBloc.isFromCache &&
        pathMainImage != null &&
        wallpaperBloc.imageBytes == null &&
        pathThumbSmall != null &&
        pathThumbOrigin != null) {
      final imageBytes =
          await _wallhavenApiClient.imageFromNetworkToBytes(pathMainImage);

      final thumbSmallImageBytes =
          await _wallhavenApiClient.imageFromNetworkToBytes(pathThumbSmall);

      final thumbOriginalImageBytes =
          await _wallhavenApiClient.imageFromNetworkToBytes(pathThumbOrigin);

      await _localStorageWallpapers.saveWallpaper(
        WallpaperLocalStorage(
          favorites: wallpaperBloc.favorites,
          category: wallpaperBloc.category,
          resolution: wallpaperBloc.resolution,
          fileSizeBytes: wallpaperBloc.fileSizeBytes,
          createdAt: wallpaperBloc.createdAt,
          imageBytes: imageBytes!,
          thumbs: ThumbsLocalStorage(
            largeImageBytes: null,
            originalImageBytes: thumbOriginalImageBytes!,
            smallImageBytes: thumbSmallImageBytes!,
          ),
          id: wallpaperBloc.id,
        ),
      );
    }
  }
}
