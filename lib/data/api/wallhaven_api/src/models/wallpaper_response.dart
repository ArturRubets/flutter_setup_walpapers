import 'package:json_annotation/json_annotation.dart';

part 'wallpaper_response.g.dart';

@JsonSerializable()
class WallpaperResponse {
  final List<Wallpaper> data;
  final Meta meta;

  const WallpaperResponse({
    required this.data,
    required this.meta,
  });

  factory WallpaperResponse.fromJson(Map<String, dynamic> json) =>
      _$WallpaperResponseFromJson(json);
  Map<String, dynamic> toJson() => _$WallpaperResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Wallpaper {
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
  final Thumbs thumbs;

  Wallpaper({
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

  factory Wallpaper.fromJson(Map<String, dynamic> json) =>
      _$WallpaperFromJson(json);
  Map<String, dynamic> toJson() => _$WallpaperToJson(this);
}

@JsonSerializable()
class Thumbs {
  final String large;
  final String original;
  final String small;

  Thumbs({
    required this.large,
    required this.original,
    required this.small,
  });

  factory Thumbs.fromJson(Map<String, dynamic> json) => _$ThumbsFromJson(json);
  Map<String, dynamic> toJson() => _$ThumbsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Meta {
  final int currentPage;
  final int lastPage;
  final String perPage;
  final int total;
  final Query query;
  final Seed seed;

  const Meta({
    required this.currentPage,
    required this.lastPage,
    required this.perPage,
    required this.total,
    required this.query,
    required this.seed,
  });

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}

@JsonSerializable()
class Query {
  Query();

  factory Query.fromJson(Map<String, dynamic> json) => _$QueryFromJson(json);
  Map<String, dynamic> toJson() => _$QueryToJson(this);
}

@JsonSerializable()
class Seed {
  Seed();

  factory Seed.fromJson(Map<String, dynamic> json) => _$SeedFromJson(json);
  Map<String, dynamic> toJson() => _$SeedToJson(this);
}
