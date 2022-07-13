// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallpaperResponse _$WallpaperResponseFromJson(Map<String, dynamic> json) =>
    WallpaperResponse(
      data: (json['data'] as List<dynamic>)
          .map((e) => Wallpaper.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: Meta.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WallpaperResponseToJson(WallpaperResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

Wallpaper _$WallpaperFromJson(Map<String, dynamic> json) => Wallpaper(
      id: json['id'] as String,
      url: json['url'] as String,
      shortUrl: json['short_url'] as String,
      views: json['views'] as int,
      favorites: json['favorites'] as int,
      source: json['source'] as String,
      purity: json['purity'] as String,
      category: json['category'] as String,
      dimensionX: json['dimension_x'] as int,
      dimensionY: json['dimension_y'] as int,
      resolution: json['resolution'] as String,
      ratio: json['ratio'] as String,
      fileSize: json['file_size'] as int,
      fileType: json['file_type'] as String,
      createdAt: json['created_at'] as String,
      colors:
          (json['colors'] as List<dynamic>).map((e) => e as String).toList(),
      path: json['path'] as String,
      thumbs: Thumbs.fromJson(json['thumbs'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WallpaperToJson(Wallpaper instance) => <String, dynamic>{
      'id': instance.id,
      'url': instance.url,
      'short_url': instance.shortUrl,
      'views': instance.views,
      'favorites': instance.favorites,
      'source': instance.source,
      'purity': instance.purity,
      'category': instance.category,
      'dimension_x': instance.dimensionX,
      'dimension_y': instance.dimensionY,
      'resolution': instance.resolution,
      'ratio': instance.ratio,
      'file_size': instance.fileSize,
      'file_type': instance.fileType,
      'created_at': instance.createdAt,
      'colors': instance.colors,
      'path': instance.path,
      'thumbs': instance.thumbs,
    };

Thumbs _$ThumbsFromJson(Map<String, dynamic> json) => Thumbs(
      large: json['large'] as String,
      original: json['original'] as String,
      small: json['small'] as String,
    );

Map<String, dynamic> _$ThumbsToJson(Thumbs instance) => <String, dynamic>{
      'large': instance.large,
      'original': instance.original,
      'small': instance.small,
    };

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as String,
      total: json['total'] as int,
      query: Query.fromJson(json['query'] as Map<String, dynamic>),
      seed: Seed.fromJson(json['seed'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
      'query': instance.query,
      'seed': instance.seed,
    };

Query _$QueryFromJson(Map<String, dynamic> json) => Query();

Map<String, dynamic> _$QueryToJson(Query instance) => <String, dynamic>{};

Seed _$SeedFromJson(Map<String, dynamic> json) => Seed();

Map<String, dynamic> _$SeedToJson(Seed instance) => <String, dynamic>{};
