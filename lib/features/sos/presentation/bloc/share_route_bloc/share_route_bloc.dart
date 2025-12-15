import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/sos/service/share_route_service.dart';
import 'share_route_event.dart';
import 'share_route_state.dart';


class ShareRouteBloc extends Bloc<ShareRouteEvent, ShareRouteState> {
  final ShareRouteService service = ShareRouteService();

  ShareRouteBloc() : super(ShareRouteInitial()) {
    on<ShareRouteRequested>(_onShareRouteRequested);
  }

  Future<void> _onShareRouteRequested(
    ShareRouteRequested event,
    Emitter<ShareRouteState> emit,
  ) async {
    emit(ShareRouteLoading());
    try {
      print("on sharing contact bloc");
      final success = await service.shareRoute(event.coordinates, event.contacts);
      if (success) {
        print("sharing passed from bloc");
        emit(ShareRouteSuccess());
      } else {
        print('Failed to share route.');
        emit(const ShareRouteFailure('Failed to share route.'));
      }
    } catch (e) {
      print("error on bloc: $e");
      emit(ShareRouteFailure(e.toString()));
    }
  }
}
