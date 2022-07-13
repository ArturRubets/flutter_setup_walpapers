import '../../../../data/api/wallhaven_api/wallhaven_api.dart';
import 'models/models.dart';

class WallhavenRepository {
  WallhavenRepository({WallhavenApiClient? wallhavenApiClient})
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
        fileSize: w.fileSize,
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

    final meta = Meta(
      currentPage: wallpaperApiResponse.meta.currentPage,
      lastPage: wallpaperApiResponse.meta.lastPage,
    );

    return WallpaperResponse(data: data, meta: meta);
  }
}
