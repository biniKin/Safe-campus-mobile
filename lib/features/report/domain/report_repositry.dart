abstract class ReportRepository {
  Future<void> sendReport({
    required String description,
    required String tags,
    required String image,
    required Map<String, String> location,
    required String token,
  });
}
