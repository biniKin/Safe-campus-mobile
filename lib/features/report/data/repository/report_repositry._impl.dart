import 'dart:developer' as console show log;

import 'package:safe_campus/features/report/data/data_source/report_data_source.dart';
import 'package:safe_campus/features/report/data/report_data_source.dart';
import 'package:safe_campus/features/report/domain/repository/report_repositry.dart';

class ReportRepositryImpl implements ReportRepository {
  ReportDataSource reportDatasource;
  ReportRepositryImpl({required this.reportDatasource});

  @override
  Future<ReportResponse> sendReport({
    required String description,
    required String tags,
    required String image,
    required Map<dynamic, dynamic> location,
    required String token,
  }) async {
    try {
      console.log(
        'Sending report with description: $description, tags: $tags, image: $image, location: $location',
      );
      final rep = await reportDatasource.sendReport(
        description: description,
        tag: tags,
        image: image,
        location: location,
        token: token,
      );

      console.log('Report sent successfully');
      return rep;
    } catch (e) {
      console.log('Error happening while sending report $e');
      return ReportResponse(success: false, message: "Error occured");
    }
  }
}
