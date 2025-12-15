import 'package:safe_campus/features/sos/data/models/alerts_model.dart';

abstract class AlertsState {}

class AlertsInitial extends AlertsState {}

class FetchingAlerts extends AlertsState {}

class FetchedAlerts extends AlertsState {
  final List<AlertsModel> alerts;
  FetchedAlerts({required this.alerts});
}

class FetchAlertError extends AlertsState {
  final String msg;
  FetchAlertError(this.msg);
}
