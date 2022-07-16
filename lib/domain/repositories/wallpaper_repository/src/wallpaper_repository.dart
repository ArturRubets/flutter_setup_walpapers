import '../../../../data/api/wallhaven_api/src/configuration.dart';
import '../../../../data/api/wallhaven_api/src/wallhaven_api_client.dart';
import 'models/wallpaper_response.dart';

class WallpaperNotFoundFailure implements Exception {}

class WallpaperRepository {
  WallpaperRepository({WallhavenApiClient? wallhavenApiClient})
      : _wallhavenApiClient = wallhavenApiClient ?? WallhavenApiClient();

  final WallhavenApiClient _wallhavenApiClient;

  Future<WallpaperResponse> getWallpaper(int page) async {
    final wallpaperApiResponse = await _wallhavenApiClient.wallpaper(
      page,
      Configuration.apiKey,
    );
    final data = wallpaperApiResponse.data.map((w) {
      return Wallpaper(
        favorites: w.favorites,
        category: w.category,
        resolution: w.resolution,
        fileSizeBytes: w.fileSize,
        fileType: w.fileType,
        createdAt: w.createdAt,
        path: w.path,
        thumbs: Thumbs(
          large: w.thumbs.large,
          original: w.thumbs.large,
          small: w.thumbs.small,
        ),
      );
    }).toList();

    if(data.isEmpty) {
      throw WallpaperNotFoundFailure();
    }

    final meta = Meta(
      currentPage: wallpaperApiResponse.meta.currentPage,
      lastPage: wallpaperApiResponse.meta.lastPage,
    );

    return WallpaperResponse(data: data, meta: meta);
  }
}
