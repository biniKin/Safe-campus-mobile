import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:developer' as console show log;

abstract class ReportDataSource {
  Future<void> sendReport({
    required String description,
    required String tag,
    required String image, // file path
    required Map<String, dynamic>
    location, // {"type":"Point","coordinates":[lon,lat]}
    required String token,
    bool anonymous = false,
  });
}

class ReportDataSourceImpl implements ReportDataSource {
  @override
  Future<void> sendReport({
    required String description,
    required String tag,
    required String image,
    required Map<String, dynamic> location,
    required String token,
    bool anonymous = false,
  }) async {
    console.log('ReportDataSourceImpl: sendReport called');
    final uri = Uri.parse('http://10.0.2.2:8000/api/report');
    try {
      final req =
          http.MultipartRequest('POST', uri)
            ..headers['Authorization'] = 'Bearer $token'
            ..fields['description'] = description
            ..fields['tag'] = tag
            ..fields['anonymous'] = anonymous.toString()
            ..fields['location'] = jsonEncode(location)
            ..files.add(
              await http.MultipartFile.fromPath(
                'image',
                image,
                contentType: MediaType('image', 'png'), // adjust if needed
              ),
            );

      final resp = await req.send();
      if (resp.statusCode < 200 || resp.statusCode >= 300) {
        throw Exception('Failed to send report (${resp.statusCode})');
      }
      console.log('Report sent successfully (${resp.statusCode})');
    } catch (e) {
      console.log('Error happening while sending report $e');
      rethrow;
    }
  }
}
