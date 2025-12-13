import 'package:location/location.dart';
import 'package:safe_campus/features/map_marking/domain/entites/map_marker.dart';

abstract class MapRepository {
  Future<List<MapMarker>> getDangerAreas({
    int page = 1,
    int limit = 15,
    String? status,
    String? types,
    String? severity,
    String? source,
  });
}
