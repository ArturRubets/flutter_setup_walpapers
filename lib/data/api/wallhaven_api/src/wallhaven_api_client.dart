import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'configuration.dart';
import 'models/wallpaper_response.dart';

class WallpaperRequestFailure implements Exception {}

class WallpaperNotFoundFailure implements Exception {}

class WallhavenApiClient {
  WallhavenApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<WallpaperResponseApi> wallpaper(int page, String apiKey) async {
    final request = Uri.https(
      Configuration.baseUrl,
      'api/v1/search',
      <String, String>{
        'apikey': apiKey,
        'page': page.toString(),
        'categories': '100',
      },
    );

    final response = await _httpClient.get(request);

    if (response.statusCode != 200) {
      throw WallpaperRequestFailure();
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;

    if (json.isEmpty) {
      throw WallpaperNotFoundFailure();
    }

    return WallpaperResponseApi.fromJson(json);
  }

  Future<Uint8List?> imageFromNetworkToBytes(String path) async {
    try {
      final response = await http.get(Uri.parse(path));
      return response.bodyBytes;
    } catch (_) {}
    return null;
  }
}
