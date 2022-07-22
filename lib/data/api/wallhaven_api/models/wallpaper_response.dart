import 'package:json_annotation/json_annotation.dart';

part 'wallpaper_response.g.dart';

@JsonSerializable()
class WallpaperResponseApi {
  factory WallpaperResponseApi.fromJson(Map<String, dynamic> json) =>
      _$WallpaperResponseApiFromJson(json);

  const WallpaperResponseApi({
    required this.data,
    required this.meta,
  });
  final List<WallpaperApi> data;
  final MetaApi meta;
  Map<String, dynamic> toJson() => _$WallpaperResponseApiToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class WallpaperApi  {
  const WallpaperApi({
    required this.id,
    required this.url,
    required this.shortUrl,
    required this.views,
    required this.favorites,
    required this.source,
    required this.purity,
    required this.category,
    required this.dimensionX,
    required this.dimensionY,
    required this.resolution,
    required this.ratio,
    required this.fileSize,
    required this.fileType,
    required this.createdAt,
    required this.colors,
    required this.path,
    required this.thumbs,
  });

  factory WallpaperApi.fromJson(Map<String, dynamic> json) =>
      _$WallpaperApiFromJson(json);

  final String id;
  final String url;
  final String shortUrl;
  final int views;
  final int favorites;
  final String source;
  final String purity;
  final String category;
  final int dimensionX;
  final int dimensionY;
  final String resolution;
  final String ratio;
  final int fileSize;
  final String fileType;
  final String createdAt;
  final List<String> colors;
  final String path;
  final ThumbsApi thumbs;

  Map<String, dynamic> toJson() => _$WallpaperApiToJson(this);
}

@JsonSerializable()
class ThumbsApi {
  const ThumbsApi({
    required this.large,
    required this.original,
    required this.small,
  });

  factory ThumbsApi.fromJson(Map<String, dynamic> json) =>
      _$ThumbsApiFromJson(json);

  final String large;
  final String original;
  final String small;

  Map<String, dynamic> toJson() => _$ThumbsApiToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class MetaApi {
  const MetaApi({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.query,
    required this.seed,
  });

  factory MetaApi.fromJson(Map<String, dynamic> json) =>
      _$MetaApiFromJson(json);

  final int currentPage;
  final int lastPage;
  final String perPage;
  final int total;
  final QueryApi? query;
  final SeedApi? seed;

  Map<String, dynamic> toJson() => _$MetaApiToJson(this);
}

@JsonSerializable()
class QueryApi {
  const QueryApi();

  factory QueryApi.fromJson(Map<String, dynamic> json) =>
      _$QueryApiFromJson(json);

  Map<String, dynamic> toJson() => _$QueryApiToJson(this);
}

@JsonSerializable()
class SeedApi {
  const SeedApi();

  factory SeedApi.fromJson(Map<String, dynamic> json) =>
      _$SeedApiFromJson(json);

  Map<String, dynamic> toJson() => _$SeedApiToJson(this);
}
