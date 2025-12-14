import 'dart:convert';
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/features/core/data/models/alerts_model.dart';
import 'package:http/http.dart' as http;
import 'package:safe_campus/features/core/data/models/announcement_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AlertService {
  final baseUri = "http://10.2.78.92:5000/api/notification";

  Future<List<AlertsModel>> fetchAlerts() async {
    final uri = "$baseUri/alerts";
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    String? refToken = prefs.getString("ref_token");
    final authService = AuthService(prefs);

    Future<http.Response> _sendRequest(String accessToken) {
      return http.get(
        Uri.parse(uri),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
    }

    try {
      // First attempt
      http.Response res = await _sendRequest(token);

      // If unauthorized → refresh token and retry
      if (res.statusCode == 401) {
        print("Token expired, refreshing...");
        final refreshSuccess =
            await authService.refreshToken(refToken: refToken ?? '');
        if (refreshSuccess) {
          final newToken = prefs.getString("token") ?? '';
          res = await _sendRequest(newToken); // Retry
        } else {
          print("Session expired, please login again.");
          return [];
        }
      }

      if (res.statusCode == 200) {
        final  jsonBody = jsonDecode(res.body);
        final List<dynamic> alertsJson = jsonBody['data'] ?? [];

        final alerts = alertsJson.map((e) => AlertsModel.fromJson(e)).toList();
        print(alerts[0].title);
        return alerts;
        
      } else {
        print("Failed to fetch alerts: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error on fetch alerts: $e");
      return [];
    }
  }

  Future<List<AnnouncementModel>>fetchAnnouncements()async{
    final uri = "$baseUri/announcements";
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    String? refToken = prefs.getString("ref_token");
    final authService = AuthService(prefs);

    Future<http.Response> _sendRequest(String accessToken) {
      return http.get(
        Uri.parse(uri),
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );
    }

    try {
      // First attempt
      http.Response res = await _sendRequest(token);

      // If unauthorized → refresh token and retry
      if (res.statusCode == 401) {
        print("Token expired, refreshing...");
        final refreshSuccess =
            await authService.refreshToken(refToken: refToken ?? '');
        if (refreshSuccess) {
          final newToken = prefs.getString("token") ?? '';
          res = await _sendRequest(newToken); // Retry
        } else {
          print("Session expired, please login again.");
          return [];
        }
      }

      if (res.statusCode == 200) {
        final  jsonBody = jsonDecode(res.body);
        final List<dynamic> alertsJson = jsonBody['data'] ?? [];

        final alerts = alertsJson.map((e) => AnnouncementModel.fromJson(e)).toList();
        print(alerts[0].title);
        return alerts;
        
      } else {
        print("Failed to fetch alerts: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      print("Error on fetch alerts: $e");
      return [];
    }
  }
}
