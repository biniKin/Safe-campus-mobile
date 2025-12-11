import 'package:safe_campus/features/report/domain/report_repositry.dart';

class SendReport {
  ReportRepository repository;

  SendReport({required this.repository});
  Future<void> call({
    required String description,
    required String tags,
    required String image,
    required Map<String, String> location,
    required String token,
  }) async {
    return await repository.sendReport(
      description: description,
      tags: tags,
      image: image,
      location: location,
      token: token,
    );
  }
}
