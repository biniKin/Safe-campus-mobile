// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:http_parser/http_parser.dart';
// import 'dart:developer' as console show log;

// abstract class ReportDataSource {
//   Future<void> sendReport({
//     required String description,
//     required String tag,
//     required String image, // file path
//     required Map<String, dynamic>
//     location, // {"type":"Point","coordinates":[lon,lat]}
//     required String token,
//     bool anonymous = false,
//   });
// }

// class ReportDataSourceImpl implements ReportDataSource {
//   @override
//   Future<void> sendReport({
//     required String description,
//     required String tag,
//     required String image,
//     required Map<String, dynamic> location,
//     required String token,
//     bool anonymous = false,
//   }) async {
//     console.log('ReportDataSourceImpl: sendReport called');
//     final uri = Uri.parse('http://10.2.75.1:5000/api/report');
//     try {
//       final mimeType = lookupMimeType(image)!.split('/');
//       final req =
//           http.MultipartRequest('POST', uri)
//             ..headers['Authorization'] = 'Bearer $token'
//             ..fields['description'] = description
//             ..fields['tag'] = tag
//             ..fields['anonymous'] = anonymous.toString()
//             ..fields['location'] = jsonEncode(location)
//             ..files.add(
//               await http.MultipartFile.fromPath(
//                 'image',
//                 image,
//                 contentType: MediaType('image', 'png'), // adjust if needed
//               ),
//             );

//       final resp = await req.send();
//       if (resp.statusCode < 200 || resp.statusCode >= 300) {
//         throw Exception('Failed to send report (${resp.statusCode})');
//       }
//       console.log('Report sent successfully (${resp.statusCode})');
//     } catch (e) {
//       console.log('Error happening while sending report $e');
//       rethrow;
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'dart:developer' as console show log;

import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ReportResponse {
  final bool success;
  final String message;
  final Map<String, dynamic>? data;

  ReportResponse({required this.success, required this.message, this.data});
}

abstract class ReportDataSource {
  Future<ReportResponse> sendReport({
    required String description,
    required String tag,
    required String image, // file path
    required Map<dynamic, dynamic>
    location, // {"type":"Point","coordinates":[lon,lat]}
    required String token,
    bool anonymous = false,
  });
}



class ReportDataSourceImpl implements ReportDataSource {
  @override
  Future<ReportResponse> sendReport({
    required String description,
    required String tag,
    required String image,
    required Map<dynamic, dynamic> location,
    required String token,
    bool anonymous = false,
  }) async {
    console.log('ReportDataSourceImpl: sendReport called');

    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService(prefs);
    final refToken = prefs.getString("ref_token") ?? '';

    final uri = Uri.parse('http://10.2.75.1:5000/api/report');

    // Wrap upload logic so it can be reused after refresh
    Future<http.StreamedResponse> _send() async {
      final mime = lookupMimeType(image)!.split('/');
      final bytes = await File(image).readAsBytes();

      final req = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token'
        ..fields['description'] = description
        ..fields['tag'] = tag
        ..fields['anonymous'] = anonymous.toString()
        ..fields['location'] = jsonEncode(location)
        ..files.add(
          http.MultipartFile.fromBytes(
            'image',
            bytes,
            filename: image.split('/').last,
            contentType: MediaType(mime[0], mime[1]),
          ),
        );

      return await req.send();
    }

    try {
      // FIRST TRY
      var resp = await _send();
      var respBody = await resp.stream.bytesToString();
      print('First attempt response: ${resp.statusCode} -> $respBody');

      // If token expired
      if (resp.statusCode == 401) {
        print("Token expired — attempting refresh...");

        final refreshed = await authService.refreshToken(refToken: refToken);

        if (!refreshed) {
          return ReportResponse(
            success: false,
            message: "Token refresh failed — user must log in again.",
          );
          //throw Exception("Token refresh failed — user must log in again.");
        }

        // Get the new access token
        token = prefs.getString("token") ?? "";

        // SECOND TRY with new token
        resp = await _send();
        respBody = await resp.stream.bytesToString();
        print('Second attempt response: ${resp.statusCode} -> $respBody');
        

        if (resp.statusCode >= 200 && resp.statusCode < 300) {
          // Success, return parsed response data
          final data = jsonDecode(respBody) as Map<String, dynamic>;
          return ReportResponse(
            success: true,
            message: 'Report sent successfully',
            data: data,
          );
        } else {
          // Upload failed for some reason
          return ReportResponse(
            success: false,
            message: 'Failed to send report (${resp.statusCode})',
            data: respBody.isNotEmpty ? jsonDecode(respBody) : null,
          );
        }
      }else {
        return ReportResponse(
          success: false,
          message: 'Failed to send report (${resp.statusCode})',
          data: respBody.isNotEmpty ? jsonDecode(respBody) : null,
        );
      }
    } catch (e) {
      console.log('Error happening while sending report $e');
      return ReportResponse(
        success: false,
        message: 'Exception occurred while sending report',
      );
    
    }
  }
}
