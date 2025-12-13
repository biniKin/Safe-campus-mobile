import 'package:safe_campus/features/map_marking/domain/entites/map_marker.dart';
import 'package:safe_campus/features/map_marking/domain/repository/map_repository.dart';

class GetDangerAreas {
  final MapRepository repository;

  GetDangerAreas(this.repository);

  Future<List<MapMarker>> call({
    int page = 1,
    int limit = 15,
    String? status,
    String? types,
    String? severity,
    String? source,
  }) {
    return repository.getDangerAreas(
      page: page,
      limit: limit,
      status: status,
      types: types,
      severity: severity,
      source: source,
    );
  }
}
