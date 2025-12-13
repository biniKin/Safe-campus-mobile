import 'package:equatable/equatable.dart';
import 'package:safe_campus/features/contacts/data/model/activity_model.dart';

abstract class RecentActivityState extends Equatable{
  const RecentActivityState();

  @override
  List<Object?> get props => [];
}


class RecentActivitiesInitialState extends RecentActivityState{
  
  const RecentActivitiesInitialState();
  @override
  List<Object?> get props => [];
}

class RecentActivitiesLoaded extends RecentActivityState{
  final List<ActivityModel> activities;
  const RecentActivitiesLoaded({required this.activities});

  @override
  List<Object?> get props => [activities];
}