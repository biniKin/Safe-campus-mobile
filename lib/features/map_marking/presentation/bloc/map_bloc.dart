import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:location/location.dart';
import 'package:safe_campus/features/map_marking/domain/entites/map_marker.dart';
import 'package:safe_campus/features/map_marking/domain/usecase/get_danger_areas.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final GetDangerAreas getDangerAreas;

  MapBloc({required this.getDangerAreas}) : super(MapInitial()) {
    on<MapLoadRequested>(_onLoadMap);
  }

  Future<void> _onLoadMap(
    MapLoadRequested event,
    Emitter<MapState> emit,
  ) async {
    try {
      emit(MapLoading());

      final dangersArea = await getDangerAreas();

      emit(MapLoaded(markers: dangersArea));
    } catch (e) {
      emit(MapError(e.toString()));
    }
  }
}
