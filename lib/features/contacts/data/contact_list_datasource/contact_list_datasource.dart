import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:safe_campus/core/constants/url.dart';
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer' as console show log;

abstract class ContactListDataSource {
  Future<List<ContactModel>> fetchContacts();
  Future<void> addContact(Map<String, dynamic> contact);
  Future<void> deleteContact(String email);
  Future<void> updateContact(String email, Map<String, dynamic> updatedContact);
}

class ContactListDatasourceImpl implements ContactListDataSource {
  static const _baseUrl = Url.baseUrl;

  final SharedPreferences prefs;
  final AuthService authService;

  ContactListDatasourceImpl({required this.prefs, required this.authService});

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

  @override
  Future<List<ContactModel>> fetchContacts() async {
    final uri = Uri.parse('$_baseUrl/auth/get_contacts');

    String token = prefs.getString("token") ?? "";
    String refreshToken = prefs.getString("ref_token") ?? "";

    Future<http.Response> request(String tok) {
      return http.get(
        uri,
        headers: {"Authorization": "Bearer $tok", "Accept": "application/json"},
      );
    }

    var resp = await request(token);

    if (resp.statusCode == 401) {
      console.log("Token expired → refreshing...");

      final refreshed = await authService.refreshToken(refToken: refreshToken);
      if (!refreshed) throw Exception("Session expired. Login again.");

      token = prefs.getString("token") ?? "";
      resp = await request(token); // retry
    }

    if (resp.statusCode == 200) {
      console.log(jsonDecode(resp.body));
      return parseContacts(jsonDecode(resp.body));
    }

    throw Exception("Failed to fetch contacts (${resp.statusCode})");
  }

  // ---------------------------------------------------------------------------
  // ADD CONTACT (with manual 401 refresh)
  // ---------------------------------------------------------------------------
  @override
  Future<void> addContact(Map<String, dynamic> contact) async {
    final uri = Uri.parse('$_baseUrl/add_contacts');

    String token = prefs.getString("token") ?? "";
    String refreshToken = prefs.getString("ref_token") ?? "";

    Future<http.Response> request(String tok) {
      return http.post(
        uri,
        headers: {
          "Authorization": "Bearer $tok",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(contact),
      );
    }

    var resp = await request(token);

    if (resp.statusCode == 401) {
      console.log("Refreshing token…");

      final refreshed = await authService.refreshToken(refToken: refreshToken);
      if (!refreshed) throw Exception("Session expired. Login again.");

      token = prefs.getString("token") ?? "";
      resp = await request(token);
    }

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception("Failed to add contact (${resp.statusCode})");
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE CONTACT (manual 401 handling)
  // ---------------------------------------------------------------------------
  @override
  Future<void> deleteContact(String email) async {
    console.log("on delete endpoint");
    final uri = Uri.parse('$_baseUrl/delete_contacts');

    String token = prefs.getString("token") ?? "";
    String refreshToken = prefs.getString("ref_token") ?? "";

    Future<http.Response> _request(String tok) {
      return http.delete(
        uri,
        headers: {"Authorization": "Bearer $tok", "Accept": "application/json"},
        body: {'email': email},
      );
    }

    var resp = await _request(token);
    console.log(jsonDecode(resp.body));

    if (resp.statusCode == 401) {
      console.log("Refreshing token…....from endpoint");

      final refreshed = await authService.refreshToken(refToken: refreshToken);
      if (!refreshed) throw Exception("Session expired. Login again.");

      token = prefs.getString("token") ?? "";
      resp = await _request(token);
      console.log(jsonDecode(resp.body));
    }

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception("Failed to delete contact (${resp.statusCode})");
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE CONTACT (manual 401 handling)
  // ---------------------------------------------------------------------------
  @override
  Future<void> updateContact(
    String email,
    Map<String, dynamic> updatedContact,
  ) async {
    final uri = Uri.parse('$_baseUrl/update_contacts');

    String token = prefs.getString("token") ?? "";
    String refreshToken = prefs.getString("ref_token") ?? "";

    Future<http.Response> request(String tok) {
      return http.put(
        uri,
        headers: {
          "Authorization": "Bearer $tok",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(updatedContact),
      );
    }

    var resp = await request(token);

    if (resp.statusCode == 401) {
      console.log("Refreshing token…");

      final refreshed = await authService.refreshToken(refToken: refreshToken);
      if (!refreshed) throw Exception("Session expired. Login again.");

      token = prefs.getString("token") ?? "";
      resp = await request(token);
    }

    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception("Failed to update contact (${resp.statusCode})");
    }
  }
}
