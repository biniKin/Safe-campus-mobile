import 'dart:convert';
import 'dart:developer' as console show log;
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ContactListDataSource {
  Future<List<ContactModel>> fetchContacts();
  Future<void> addContact(Map<String, dynamic> contact);
  Future<void> deleteContact(String email);
  Future<void> updateContact(String email, Map<String, dynamic> updatedContact);
}

class ContactListDatasourceImpl implements ContactListDataSource {
  static const _baseUrl = 'http://10.0.2.2:8000/api/auth';
  final SharedPreferences prefs;
  final AuthService authService;

  ContactListDatasourceImpl({
    required this.prefs,
    required SharedPreferences sharedPreferences,
    required this.authService,
  });
  List<ContactModel> parseContacts(dynamic body) {
    final list =
        (body is Map && body['trustedContacts'] is List)
            ? body['trustedContacts'] as List
            : (body is Map &&
                body['data'] is Map &&
                (body['data'] as Map)['trustedContacts'] is List)
            ? (body['data'] as Map)['trustedContacts'] as List
            : const <dynamic>[];

    return list
        .whereType<Map<String, dynamic>>()
        .map(ContactModel.fromMap)
        .toList();
  }

  Future<bool> refreshAuthToken() async {
    final refreshToken = prefs.getString('ref_token');
    if (refreshToken == null) return false;

    final url = Uri.parse('$_baseUrl/refresh');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      // store new access token
      prefs.setString('token', data['data']['token']);
      return true;
    }

    return false;
  }

  Future<http.Response> sendAuthorizedRequest(
    Future<http.Response> Function(String? accessToken) requestFn,
  ) async {
    final token = prefs.getString('token');

    // TRY #1 — use current access token
    var response = await requestFn(token);

    // If token expired → backend returns 401
    if (response.statusCode == 401) {
      final refreshed = await refreshAuthToken();

      if (!refreshed) {
        throw Exception("Session expired. Please login again.");
      }

      // retry using new access token
      final newToken = prefs.getString('token');
      response = await requestFn(newToken);
    }

    return response;
  }

  Map<String, String> _authHeaders({bool json = false}) {
    final token = prefs.getString('token');

    if (token == null || token.isEmpty) {
      console.log('missing auth token');
      throw Exception('Missing auth token');
    }
    return {
      if (json) 'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<ContactModel>> fetchContacts() async {
    final uri = Uri.parse('$_baseUrl/get_contacts');

    final response = await sendAuthorizedRequest((token) {
      return http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    });

    if (response.statusCode != 200) {
      throw Exception('Failed to load contacts');
    }

    return parseContacts(jsonDecode(response.body));
  }

  @override
  Future<void> addContact(Map<String, dynamic> contact) async {
    final uri = Uri.parse('$_baseUrl/add_contacts');

    final response = await sendAuthorizedRequest((token) {
      return http.post(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(contact),
      );
    });

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to add contact (${response.statusCode})');
    }

    console.log('Contact added: $contact');
  }

  @override
  Future<void> deleteContact(String email) async {
    final uri = Uri.parse('$_baseUrl/delete_contacts/$email');

    final response = await sendAuthorizedRequest((token) {
      return http.delete(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
    });

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to delete contact (${response.statusCode})');
    }
  }

  @override
  Future<void> updateContact(
    String email,
    Map<String, dynamic> updatedContact,
  ) async {
    final uri = Uri.parse('$_baseUrl/update_contacts');

    final response = await sendAuthorizedRequest((token) {
      return http.put(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(updatedContact),
      );
    });

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to update contact (${response.statusCode})');
    }
  }
}
