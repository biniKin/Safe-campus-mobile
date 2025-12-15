import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/auth/data/services/alert_service.dart';
// import 'package:safe_campus/features/core/data/models/alerts_model.dart';
// import 'package:safe_campus/features/core/presentation/bloc/alerts_bloc/alerts_event.dart';
// import 'package:safe_campus/features/core/presentation/bloc/alerts_bloc/alerts_state.dart';
import 'package:safe_campus/features/core/presentation/screens/alerts.dart';
import 'package:safe_campus/features/sos/data/models/alerts_model.dart';
import 'package:safe_campus/features/sos/presentation/bloc/alerts_bloc/alerts_event.dart';
import 'package:safe_campus/features/sos/presentation/bloc/alerts_bloc/alerts_state.dart';

class AlertsBloc extends Bloc<AlertsEvent, AlertsState> {
  AlertsBloc() : super(AlertsInitial()) {
    final alertService = AlertService();
    on<FetchAlerts>((event, emit) async {
      try {
        emit(FetchingAlerts());
        // final alerts = await alertService.fetchAlerts();
        // for (final alert in alerts){
        //   print("Title: ${alert.title}");
        //   print("Content: ${alert.content}");
        //   print("Status: ${alert.status}");
        //   print("Time: ${alert.time}");
        // }
        final alerts = [
          AlertsModel(
          title: "Suspicious Activity", 
          content: '''
Students are advised to remain vigilant following multiple reports of suspicious activity near the main library and surrounding parking areas. Individuals have reported being followed by an unknown person during late evening hours, particularly between 8:00 PM and 11:30 PM.

Campus security is actively investigating the situation and has increased patrols in the affected areas. Students are strongly encouraged to avoid walking alone at night and to use designated campus shuttle services whenever possible.

If you notice any unusual behavior or feel unsafe at any time, immediately contact campus security or use the SOS feature within the Safe Campus application. Your safety is our highest priority, and timely reporting can help prevent further incidents.
''',
          time: DateTime.now(), 
          status: "High",
          
          ),
          
          
        ];
        
        emit(FetchedAlerts(alerts: alerts));
      } catch (e) {
        print("error on fetch alert block: $e");
        emit(FetchAlertError(e.toString()));
      }
    });
  }
}
