part of 'map_bloc.dart';

abstract class MapState {}

class MapInitial extends MapState {}

class MapLoading extends MapState {}

class MapLoaded extends MapState {
  final List<MapMarker> markers;

  MapLoaded({required this.markers});
}

class MapError extends MapState {
  final String message;
  MapError(this.message);
}
