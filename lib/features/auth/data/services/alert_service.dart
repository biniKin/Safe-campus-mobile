import 'dart:convert';
import 'package:safe_campus/core/constants/url.dart';
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/features/sos/data/models/alerts_model.dart';
import 'package:http/http.dart' as http;
import 'package:safe_campus/features/sos/data/models/announcement_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as console show log;

class AlertService {
  final baseUri = "${Url.baseUrl}/notification";

  Future<List<AlertsModel>> fetchAlerts() async {
    final uri = "$baseUri/alerts";
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    String? refToken = prefs.getString("ref_token");
    final authService = AuthService(prefs);

    Future<http.Response> sendRequest(String accessToken) {
      return http.get(
        Uri.parse(uri),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
    }

    try {
      // First attempt
      http.Response res = await sendRequest(token);

      // If unauthorized → refresh token and retry
      if (res.statusCode == 401) {
        console.log("Token expired, refreshing...");
        final refreshSuccess = await authService.refreshToken(
          refToken: refToken ?? '',
        );
        if (refreshSuccess) {
          final newToken = prefs.getString("token") ?? '';
          res = await sendRequest(newToken); // Retry
        } else {
          console.log("Session expired, please login again.");
          return [];
        }
      }

      if (res.statusCode == 200) {
        final jsonBody = jsonDecode(res.body);
        final List<dynamic> alertsJson = jsonBody['data'] ?? [];

        final alerts = alertsJson.map((e) => AlertsModel.fromJson(e)).toList();
        console.log(alerts[0].title);
        return alerts;
      } else {
        console.log("Failed to fetch alerts: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      console.log("Error on fetch alerts: $e");
      return [];
    }
  }

  Future<List<AnnouncementModel>> fetchAnnouncements() async {
    final uri = "$baseUri/announcements";
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString("token") ?? '';
    String? refToken = prefs.getString("ref_token");
    final authService = AuthService(prefs);

    Future<http.Response> sendRequest(String accessToken) {
      return http.get(
        Uri.parse(uri),
        headers: {'Authorization': 'Bearer $accessToken'},
      );
    }

    try {
      // First attempt
      http.Response res = await sendRequest(token);

      // If unauthorized → refresh token and retry
      if (res.statusCode == 401) {
        console.log("Token expired, refreshing...");
        final refreshSuccess = await authService.refreshToken(
          refToken: refToken ?? '',
        );
        if (refreshSuccess) {
          final newToken = prefs.getString("token") ?? '';
          res = await sendRequest(newToken); // Retry
        } else {
          console.log("Session expired, please login again.");
          return [];
        }
      }

      if (res.statusCode == 200) {
        final jsonBody = jsonDecode(res.body);
        final List<dynamic> alertsJson = jsonBody['data'] ?? [];

        final alerts =
            alertsJson.map((e) => AnnouncementModel.fromJson(e)).toList();
        console.log(alerts[0].title);
        return alerts;
      } else {
        console.log("Failed to fetch alerts: ${res.statusCode}");
        return [];
      }
    } catch (e) {
      console.log("Error on fetch alerts: $e");
      return [];
    }
  }
}
