import 'dart:developer';

import 'package:safe_campus/features/map_marking/data/data_source/map_remote_datasource.dart';
import 'package:safe_campus/features/map_marking/domain/entites/map_marker.dart';
import 'package:safe_campus/features/map_marking/domain/repository/map_repository.dart';
import 'dart:developer' as console show log;

class MapRepositoryImpl implements MapRepository {
  final MapRemoteDataSource remote;

  MapRepositoryImpl(this.remote);

  @override
  Future<List<MapMarker>> getDangerAreas({
    int page = 1,
    int limit = 15,
    String? status,
    String? types,
    String? severity,
    String? source,
  }) async {
    try {
      final dangersArea = await remote.getDangerAreas(
        page: page,
        limit: limit,
        status: status,
        types: types,
        severity: severity,
        source: source,
      );
      return dangersArea;
    } catch (e, s) {
  print('MapRemoteDataSource error: $e');
  print('$s');
  rethrow;
}
  }
}
