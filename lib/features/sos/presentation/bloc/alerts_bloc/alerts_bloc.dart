import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/auth/data/services/alert_service.dart';
import 'package:safe_campus/features/sos/presentation/bloc/alerts_bloc/alerts_event.dart';
import 'package:safe_campus/features/sos/presentation/bloc/alerts_bloc/alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  AlertsBloc() : super(AlertsInitial()) {
    final alertService = AlertService();
    on<FetchAlerts>((event, emit) async {
      try {
        emit(FetchingAlerts());
        final alerts = await alertService.fetchAlerts();
        emit(FetchedAlerts(alerts: alerts));
      } catch (e) {
        print("error on fetch alert block: $e");
        emit(FetchAlertError(e.toString()));
      }
    });
  }
}
