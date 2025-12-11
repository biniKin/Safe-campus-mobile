import 'dart:convert';
import 'dart:developer' as console show log;
import 'dart:developer';
import 'package:http/http.dart' as http;
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

  ContactListDatasourceImpl({
    required this.prefs,
    required SharedPreferences sharedPreferences,
  });

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
    final resp = await http.get(uri, headers: _authHeaders());

    if (resp.statusCode != 200) {
      throw Exception('Failed to load contacts (${resp.statusCode})');
    }
    final body = jsonDecode(resp.body);
    final data = body is Map<String, dynamic> ? body['data'] : body;

    console.log('token: ${prefs.getString('token')}');

    final contactlist =
        (data as List).map((item) => ContactModel.fromMap(item)).toList();

    console.log(' Fetched contacts - datasource: $contactlist');
    return contactlist;
  }

  @override
  Future<void> addContact(Map<String, dynamic> contact) async {
    final uri = Uri.parse('$_baseUrl/add_contacts');
    final resp = await http.post(
      uri,
      headers: _authHeaders(json: true),
      body: jsonEncode(contact),
    );

    console.log(
      'Add contact response: ${resp.body} and adding contact $contact',
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      console.log('Failed to add contact: ${resp.body}');
      throw Exception('Failed to add contact (${resp.statusCode})');
    }
    console.log('Contact added: $contact');
  }

  @override
  Future<void> deleteContact(String email) async {
    // adjust endpoint if your API differs
    final uri = Uri.parse('$_baseUrl/delete_contacts/$email');
    final resp = await http.delete(uri, headers: _authHeaders());
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to delete contact (${resp.statusCode})');
    }
  }

  @override
  Future<void> updateContact(
    String email,
    Map<String, dynamic> updatedContact,
  ) async {
    final uri = Uri.parse('$_baseUrl/update_contacts');
    final resp = await http.put(
      uri,
      headers: _authHeaders(json: true),
      body: jsonEncode(updatedContact),
    );
    if (resp.statusCode < 200 || resp.statusCode >= 300) {
      throw Exception('Failed to update contact (${resp.statusCode})');
    }
  }
}
