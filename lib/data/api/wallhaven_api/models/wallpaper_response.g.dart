// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallpaper_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WallpaperResponseApi _$WallpaperResponseApiFromJson(
        Map<String, dynamic> json) =>
    WallpaperResponseApi(
      data: (json['data'] as List<dynamic>)
          .map((e) => WallpaperApi.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: MetaApi.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WallpaperResponseApiToJson(
        WallpaperResponseApi instance) =>
    <String, dynamic>{
      'data': instance.data,
      'meta': instance.meta,
    };

WallpaperApi _$WallpaperApiFromJson(Map<String, dynamic> json) => WallpaperApi(
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
      thumbs: ThumbsApi.fromJson(json['thumbs'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$WallpaperApiToJson(WallpaperApi instance) =>
    <String, dynamic>{
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

ThumbsApi _$ThumbsApiFromJson(Map<String, dynamic> json) => ThumbsApi(
      large: json['large'] as String,
      original: json['original'] as String,
      small: json['small'] as String,
    );

Map<String, dynamic> _$ThumbsApiToJson(ThumbsApi instance) => <String, dynamic>{
      'large': instance.large,
      'original': instance.original,
      'small': instance.small,
    };

MetaApi _$MetaApiFromJson(Map<String, dynamic> json) => MetaApi(
      currentPage: json['current_page'] as int,
      lastPage: json['last_page'] as int,
      perPage: json['per_page'] as String,
      total: json['total'] as int,
      query: json['query'] == null
          ? null
          : QueryApi.fromJson(json['query'] as Map<String, dynamic>),
      seed: json['seed'] == null
          ? null
          : SeedApi.fromJson(json['seed'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MetaApiToJson(MetaApi instance) => <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
      'query': instance.query,
      'seed': instance.seed,
    };

QueryApi _$QueryApiFromJson(Map<String, dynamic> json) => QueryApi();

Map<String, dynamic> _$QueryApiToJson(QueryApi instance) => <String, dynamic>{};

SeedApi _$SeedApiFromJson(Map<String, dynamic> json) => SeedApi();

Map<String, dynamic> _$SeedApiToJson(SeedApi instance) => <String, dynamic>{};
