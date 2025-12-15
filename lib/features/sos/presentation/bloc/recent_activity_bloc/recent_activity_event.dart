
import 'package:equatable/equatable.dart';
import 'package:safe_campus/features/contacts/data/model/activity_model.dart';

abstract class RecentActivityEvent extends Equatable {
  const RecentActivityEvent();

  @override
  List<Object?> get props => [];
}

class LoadActivitiesEvent extends RecentActivityEvent {
  const LoadActivitiesEvent();

  @override
  List<Object?> get props => []; 
}

class SaveActivityEvent extends RecentActivityEvent{
  final ActivityModel activity;
  const SaveActivityEvent({required this.activity});

  @override
  List<Object?> get props => [];
}

class DeleteActivityEvent extends RecentActivityEvent {
  final String id;

  const DeleteActivityEvent({required this.id});

  @override
  List<Object?> get props => [id];
}


class ActivitiesUpdatedEvent extends RecentActivityEvent {
  final List<ActivityModel> activities;
  const ActivitiesUpdatedEvent({required this.activities});

  @override
  List<Object?> get props => [activities];
}
