import 'dart:convert';

class MapMarker {
  final String id;
  final double lat;
  final double lng;
  final String status;
  final String? severity;
  final int reportCount;
  final List<String> types;
  final List<dynamic> reports;
  final List<String> source;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastReportedAt;

  const MapMarker({
    required this.id,
    required this.lat,
    required this.lng,
    required this.status,
    this.severity,
    required this.reportCount,
    required this.types,
    required this.reports,
    required this.source,
    this.createdAt,
    this.updatedAt,
    this.lastReportedAt,
  });
}
