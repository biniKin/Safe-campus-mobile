import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:safe_campus/features/auth/domain/entities/user.dart';
import 'auth_remote_data_source.dart';
import 'dart:developer' as developer;

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;
  final SharedPreferences prefs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  // 'https://safe-campus-backend.onrender.com/api';
//   static const String baseUrl = 'http://10.2.66.138:8000/api';

  //static const String baseUrl = 'http://192.168.1.10:8000/api';
  static const String baseUrl = 'http://192.168.1.5:5000/api';

  AuthRemoteDataSourceImpl({required this.client, required this.prefs});

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // Validate inputs
      if (email.isEmpty || password.isEmpty) {
        return {'success': false, 'error': 'Email and password are required'};
      }

      // Get device token
      String? deviceToken = await _firebaseMessaging.getToken();
      print(deviceToken);

      // Send login request
      final response = await client.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'deviceToken': deviceToken,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      late final Map<String, dynamic> responseBody;
      try {
        responseBody = jsonDecode(response.body);
      } catch (e) {
        print('JSON decode error: $e');

        return {
          'success': false,
          'error': 'Invalid response format from server: ${response.body}',
        };
      }

      if (response.statusCode == 200) {
        final data = responseBody['data'];
        String? token = data?['token'];
        String? refreshToken = data?['refreshToken'];
        final userJson = data?['user'];

        if (token != null && userJson != null && refreshToken != null) {
          // Add token to user JSON before saving
          userJson['token'] = token;

          await prefs.setString('token', token);
          await prefs.setString('ref_token', refreshToken);
          await prefs.setString('user', jsonEncode(userJson));

          token = prefs.getString('token');

          print("accessToken: ${token.toString()}");
          print("Refresh token: ${prefs.getString("ref_token").toString()}");

          return {'success': true, 'data': data};
        } else {
          return {
            'success': false,
            'error': 'Token or user data missing in server response',
          };
        }
      } else if (response.statusCode == 400) {
        return {
          'success': false,
          'error': responseBody['message'] ?? 'Invalid email or password',
        };
      } else if (response.statusCode == 401) {
        return {'success': false, 'error': 'Invalid credentials'};
      } else if (response.statusCode == 404) {
        return {'success': false, 'error': 'User not found'};
      } else {
        return {
          'success': false,
          'error': responseBody['message'] ?? 'Login failed',
        };
      }
    } catch (e, stack) {
      developer.log('Unexpected error during login: $e', stackTrace: stack);
      return {
        'success': false,
        'error': 'An error occurred during login: ${e.toString()}',
      };
    }
  }

  @override
  Future<Map<String, dynamic>> register(
    String email,
    String password,
    String name,
    String studentId,
  ) async {
    try {
      // Log input
      // developer.log(
      //   'Attempting to register user',
      //   name: 'Register',
      //   error: {'email': email, 'name': name},
      // );
      print('Attempting to register user: email=$email');
      print("Name: $name");
      print("Id: $studentId");

      // Send request
      final response = await client.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'fullName': name,
          'studentId': studentId,
        }),
      );

      print('Status Code for rigester: ${response.statusCode}');
      print('Response for rigester Body: ${response.body}');

      late final Map<String, dynamic> data;
      try {
        data = jsonDecode(response.body);
      } catch (e) {
        developer.log('JSON decode error: $e', name: 'Register');
        return {
          'success': false,
          'error': 'Invalid response format from server: ${response.body}',
        };
      }

      if (response.statusCode == 201) {
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'error': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e, stack) {
      developer.log(
        'Unexpected error during registration: $e',
        name: 'Register',
        stackTrace: stack,
      );
      print(
        "An unexpected error occurred during registration: ${e.toString()}",
      );
      return {
        'success': false,
        'error':
            'An unexpected error occurred during registration: ${e.toString()}',
      };
    }
  }

  @override
  Future<void> logout() async {
    // Get the current device token before logging out
    final deviceToken = await _firebaseMessaging.getToken();
    final userToken = prefs.getString('token');

    if (deviceToken != null && userToken != null) {
      try {
        // Remove the device token from the backend
        // await client.post(
        //   Uri.parse('$baseUrl/auth/remove-device-token'),
        //   headers: {
        //     'Content-Type': 'application/json',
        //     'Authorization': 'Bearer $userToken',
        //   },
        //   body: jsonEncode({
        //     'deviceToken': deviceToken,
        //   }),
        // );
        // prefs.remove('token');
        await prefs.remove('token');
        await prefs.remove('user');
      } catch (e) {
        print('Failed to remove device token: $e');
      }
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return prefs.containsKey('token');
  }

  @override
  Future<String?> getToken() async {
    return prefs.getString('token');
  }

  // change it to fetch user
  @override
  Future<User?> getUser() async {
    final userJson = prefs.getString('user');
    if (userJson != null) {
      /*
        from service: User(
        693ac7aa94b724e6443fd634, 
        name, 
        alehegne23@gmail.com, 
        student, 
        ETS****, 
        [] 
        null, 
        null, 
        eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
        eyJ1c2VySWQiOiI2OTNhYzdhYTk0YjcyNGU2NDQzZmQ2MzQiLCJy
        b2xlIjoic3R1ZGVudCIsImVtYWlsIjoiYWxlaGVnbmUyM0BnbWFp
        bC5jb20iLCJpYXQiOjE3NjU0NjAwODksImV4cCI6MTc2NTQ2MDE0
        OX0.m3VBaAD4_jmZJdlDtiLf9FCB8teP8tKatQfV-IMvmAM)

        User(
        693ac7aa94b724e6443fd634, 
        name, 
        alehegne23@gmail.com, 
        student, 
        ETS****, 
        [], 
        null, 
        null, 
        eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
        eyJ1c2VySWQiOiI2OTNhYzdhYTk0YjcyNGU2
        NDQzZmQ2MzQiLCJyb2xlIjoic3R1ZGVudCIs
        ImVtYWlsIjoiYWxlaGVnbmUyM0BnbWFpbC5j
        
        b20iLCJpYXQiOjE3NjU0NjAwODksImV4cCI6
        MTc2NTQ2MDE0OX0.m3VBaAD4_jmZJdlDtiLf
        9FCB8teP8tKatQfV-IMvmAM)

      */
      print("from service: ${User.fromJson(jsonDecode(userJson))}");
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // @override
  // Future<void> updateUser(String fullName, String email)async{
  //   final endPoint = "${baseUrl}/profile";
  //   try{

  //     final userToken = prefs.getString('token');
  //     final req = await http.put(
  //       Uri.parse(endPoint),
  //       headers: {
  //         // 'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $userToken',
  //       },
  //       body: {
  //         'fullName': fullName,
  //         'email':email,
  //       }
  //     );
  //     print(req.body);
  //     if(req.statusCode == 200){
  //       Fluttertoast.showToast(msg: "User updated successfully.");
  //     } else{
  //       Fluttertoast.showToast(msg: "Error on updating use data. Please try again later.");
  //     }

  //   }catch(e){
  //     print(e);
  //   }

  // }

  @override
  Future<void> updateUser(String fullName, String email) async {
    final endPoint = "$baseUrl/profile";

    try {
      final userToken = prefs.getString('token') ?? '';
      final refreshToken = prefs.getString('ref_token') ?? '';

      var response = await http.put(
        Uri.parse(endPoint),
        headers: {'Authorization': 'Bearer $userToken'},
        body: {'fullName': fullName, 'email': email},
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: "User updated successfully.");
        final userJson = jsonDecode(response.body);
        await prefs.setString('user', jsonEncode(userJson));
        return;
      }

      if (response.statusCode == 401) {
        print("Token expired. Attempting refresh...");

        final authService = AuthService(prefs);
        final bool refreshSuccess = await authService.refreshToken(
          refToken: refreshToken,
        );

        if (!refreshSuccess) {
          Fluttertoast.showToast(msg: "Session expired. Please log in again.");
          return;
        }

        final newToken = prefs.getString('token') ?? '';

        response = await http.put(
          Uri.parse(endPoint),
          headers: {'Authorization': 'Bearer $newToken'},
          body: {'fullName': fullName, 'email': email},
        );

        if (response.statusCode == 200) {
          Fluttertoast.showToast(msg: "User updated successfully.");
        } else {
          Fluttertoast.showToast(msg: "Update failed. Please try again.");
        }
        return;
      }

      Fluttertoast.showToast(
        msg: "Error updating user (${response.statusCode}). Try again later.",
      );
    } catch (e) {
      print("updateUser error: $e");
      Fluttertoast.showToast(msg: "Unexpected error. Please try again.");
    }
  }

  @override
  Future<bool> refreshToken({required String refreshToken}) async {
    final endPoint = "$baseUrl/auth/refresh";
    final token = prefs.getString('token');
    print("token: $token");
    try {
      print("ref token: $refreshToken");
      final res = await http.post(
        Uri.parse(endPoint),
       
        body: {'refresh_token': refreshToken},
      );

      developer.log('Refresh token response status: ${res.body}');
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        print(data);
        print("new token: ${data['data']['token']}");
        await prefs.setString('token', data['data']['token']);

        return true;
      } else {
        print("on else bloc: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      print("error on refresh token: $e");
      return false;
    }
  }
}
