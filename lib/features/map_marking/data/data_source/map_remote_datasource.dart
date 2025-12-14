import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:location/location.dart';
import 'package:safe_campus/features/map_marking/data/model/map_marker_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as console show log;

abstract class MapRemoteDataSource {
  Future<List<MapMarkerModel>> getDangerAreas({
    int page = 1,
    int limit = 15,
    String? status,
    String? types,
    String? severity,
    String? source,
  });
}

class MapRemoteDataSourceImpl implements MapRemoteDataSource {
  static const _host = '10.2.78.92:5000';
  static const _path = '/api/dangerArea'; // set to your actual route
  static const _authBase = 'http://10.2.78.92:5000/api/auth';

  final Location _location = Location();
  final HttpClient httpClient;
  final SharedPreferences prefs;

  MapRemoteDataSourceImpl(this.httpClient, {required this.prefs});

  Future<bool> _refreshAuthToken() async {
    final refreshToken = prefs.getString('ref_token');
    if (refreshToken == null) return false;

    final url = Uri.parse('$_authBase/refresh');
    final req = await httpClient.postUrl(url);
    req.headers.set(HttpHeaders.contentTypeHeader, 'application/json');
    req.add(utf8.encode(jsonEncode({'refreshToken': refreshToken})));

    final resp = await req.close();
    final body = await resp.transform(utf8.decoder).join();

    if (resp.statusCode == 200) {
      final data = jsonDecode(body);
      final newToken =
          (data is Map) ? (data['data']?['token'] as String?) : null;
      if (newToken != null && newToken.isNotEmpty) {
        await prefs.setString('token', newToken);
        return true;
      }
    }
    return false;
  }

  Future<HttpClientResponse> _sendAuthorizedGet(Uri uri) async {
    final token = prefs.getString('token');

    // Try #1 — current token
    var request = await httpClient.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');
    if (token != null && token.isNotEmpty) {
      request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $token');
    }
    var response = await request.close();

    // If unauthorized, try refreshing and retry once
    if (response.statusCode == 401) {
      final refreshed = await _refreshAuthToken();
      if (!refreshed) {
        throw Exception('Session expired. Please login again.');
      }
      final newToken = prefs.getString('token');

      request = await httpClient.getUrl(uri);
      request.headers.set(HttpHeaders.acceptHeader, 'application/json');
      if (newToken != null && newToken.isNotEmpty) {
        request.headers.set(
          HttpHeaders.authorizationHeader,
          'Bearer $newToken',
        );
      }
      response = await request.close();
    }

    return response;
  }

  @override
  Future<List<MapMarkerModel>> getDangerAreas({
    int page = 1,
    int limit = 15,
    String? status,
    String? types,
    String? severity,
    String? source,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
        if (status != null) 'status': status,
        if (types != null) 'types': types,
        if (severity != null) 'severity': severity,
        if (source != null) 'source': source,
      };

      final uri = Uri.http(_host, _path, queryParams);

      final response = await _sendAuthorizedGet(uri);
      final contentType =
          response.headers.value(HttpHeaders.contentTypeHeader) ?? '';
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) {
        console.log('Danger areas error ${response.statusCode}: $body');
        throw Exception('Failed to fetch dangerous areas');
      }
      if (!contentType.contains('application/json')) {
        console.log('Unexpected content-type: $contentType\n$body');
        throw Exception('Failed to fetch dangerous areas');
      }

      final decoded = jsonDecode(body);

      console.log('Decoded danger areas: ${decoded['data']}');

      final List list =
          (decoded is Map) ? (decoded['data'] ?? const []) : const [];

      // console.log('Danger areas list: $list');

      return list
          .whereType<Map<String, dynamic>>()
          .map(MapMarkerModel.fromMap)
          .toList();
    } catch (e) {
      console.log('Error while fetching dangerous areas: $e');
      throw Exception('Failed to fetch dangerous areas');
    }
  }
}
