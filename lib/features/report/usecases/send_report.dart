import 'package:safe_campus/features/report/data/report_data_source.dart';
import 'package:safe_campus/features/report/data/report_repositry._impl.dart';
import 'package:safe_campus/features/report/domain/report_repositry.dart';

class SendReport {
  ReportRepositryImpl reportRepositryImpl;

  SendReport({required this.reportRepositryImpl});
  Future<ReportResponse> call({
    required String description,
    required String tags,
    required String image,
    required Map<dynamic, dynamic> location,
    required String token,
  }) async {
    return await reportRepositryImpl.sendReport(
      description: description,
      tags: tags,
      image: image,
      location: location,
      token: token,
    );
  }
}
