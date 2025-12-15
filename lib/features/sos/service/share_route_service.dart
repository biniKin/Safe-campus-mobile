import 'package:safe_campus/core/constants/url.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safe_campus/core/constants/url.dart';
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/features/contacts/domain/entities/contact.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as console show log;

class ShareRouteService {
  final String baseUrl = Url.baseUrl;

  /// Send coordinates to selected contacts
  /// [coordinates] = {"coordinates": [lat, lon]}
  /// [contacts] = List of ContactModel (with email)
  Future<bool> shareRoute(
      Map<String, List<dynamic>> coordinates, List<Contact> contacts) async {
    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService(prefs);

    String token = prefs.getString('token') ?? '';
    final refToken = prefs.getString('ref_token') ?? '';

    final url = Uri.parse('$baseUrl/routes/share-current-location');

    // Prepare the payload
    final body = jsonEncode({
      "coordinates": coordinates["coordinates"] ?? [],
      "emails": contacts.map((c) => c.email).toList(),
    });

    Future<http.Response> _send() async {
      return await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );
    }

    try {
      // FIRST ATTEMPT
      var response = await _send();
      print('ShareRoute first attempt: ${response.statusCode} -> ${response.body}');

      // If token expired
      if (response.statusCode == 401) {
        print('Token expired — refreshing...');
        final refreshed = await authService.refreshToken(refToken: refToken);
        if (!refreshed) {
          print('Token refresh failed');
          return false;
        }

        // Get new token
        token = prefs.getString('token') ?? '';

        // SECOND ATTEMPT
        response = await _send();
        print('ShareRoute second attempt: ${response.statusCode} -> ${response.body}');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return true;
      } else {
        print('Failed to share route: ${response.statusCode} -> ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error while sharing route: $e');
      return false;
    }
  }
}
