import 'package:safe_campus/features/sos/data/models/notification_model.dart';

abstract class PanicNotificationState {}

class PanicNotificationInitial extends PanicNotificationState {}

class PanicNotificationReceived extends PanicNotificationState {
  final PanicNotification notification;

  PanicNotificationReceived(this.notification);
}
