import 'dart:convert';

import 'package:http/http.dart' as http;

import 'configuration.dart';
import 'models/wallpaper_response.dart';

class WallpaperRequestFailure implements Exception {}

class WallpaperNotFoundFailure implements Exception {}

class WallhavenApiClient {
  WallhavenApiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<WallpaperResponse> wallpaper(int page, String apiKey) async {
    final request = Uri.https(
      Configuration.baseUrl,
      'api/v1/search',
      <String, String>{
        'apikey': apiKey,
        'page': page.toString(),
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

    return WallpaperResponse.fromJson(json);
  }
}
