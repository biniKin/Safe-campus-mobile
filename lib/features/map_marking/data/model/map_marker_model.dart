import 'dart:convert';

import 'package:safe_campus/features/map_marking/domain/entites/map_marker.dart';

class MapMarkerModel extends MapMarker {
  MapMarkerModel({
    required super.id,
    required super.lat,
    required super.lng,
    required super.status,
    required super.reportCount,
    required super.types,
    required super.reports,
    required super.source,
    super.severity,
    super.createdAt,
    super.updatedAt,
    super.lastReportedAt,
  });

  factory MapMarkerModel.fromMap(Map<String, dynamic> map) {
    final coordinates = map['location']?['coordinates'] ?? [0.0, 0.0];

    return MapMarkerModel(
      id: map['_id'] ?? '',
      lat: (coordinates[1] as num).toDouble(),
      lng: (coordinates[0] as num).toDouble(),
      status: map['status'] ?? 'unknown',
      severity: map['severity'],
      reportCount: map['reportCount'] ?? 0,
      types: List<String>.from(map['types'] ?? []),
      reports: map['reports'] ?? [],
      source: List<String>.from(map['source'] ?? []),
      createdAt:
          map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt:
          map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
      lastReportedAt:
          map['lastReportedAt'] != null
              ? DateTime.parse(map['lastReportedAt'])
              : null,
    );
  }
}
