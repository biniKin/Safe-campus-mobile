import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:safe_campus/features/contacts/data/model/activity_model.dart';
import 'package:safe_campus/features/contacts/data/model/activity_model_hive.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/recent_activity_bloc/recent_activity_state.dart';

class RecentActivityBloc extends Bloc<RecentActivityEvent, RecentActivityState>{
  RecentActivityBloc():super(RecentActivitiesInitialState()){
    on<LoadActivitiesEvent>(_loadActivity);
    on<SaveActivityEvent>(_onSaveActivity);
    on<DeleteActivityEvent>(_onDeleteActivity); 
    on<ActivitiesUpdatedEvent>((event, emit) {
      emit(RecentActivitiesLoaded(activities: event.activities));
    });

    _listenToHive();
  }

  final recentBox = Hive.box<ActivityModelHive>("recent_activities");
  late final ValueListenable<Box<ActivityModelHive>> _boxListener;
  late final VoidCallback _listener;

  void _listenToHive(){
    _boxListener = recentBox.listenable();
    _listener = () {
      final activities = recentBox.values
          .map((hiveModel) => ActivityModel(
                id: hiveModel.id,
                time: hiveModel.time,
              ))
          .toList()
          .reversed
          .toList(); // most recent first

      add(ActivitiesUpdatedEvent(activities: activities));
    };
    _boxListener.addListener(_listener);
  }

  Future<void> _loadActivity(
      LoadActivitiesEvent event, Emitter<RecentActivityState> emit) async {
    final activities = (recentBox.values
        .map((hiveModel) => ActivityModel(
              id: hiveModel.id,
              time: hiveModel.time,
            ))
        .toList()
        .reversed
        .toList())
        ..sort((b, a) => a.time.compareTo(b.time));
        // final activities = [
        //   ActivityModel(id: '12', time: DateTime.now()),
        //   ActivityModel(id: '12', time: DateTime.now()),
        //   ActivityModel(id: '12', time: DateTime.now()),
        //   ActivityModel(id: '12', time: DateTime.now()),
        // ];
    emit(RecentActivitiesLoaded(activities: activities));
  }

  Future<void> _onSaveActivity(
      SaveActivityEvent event, Emitter<RecentActivityState> emit) async {
    // Example: you could pass the activity in the event
    final activity = ActivityModelHive(
      id: event.activity.id,
      time: event.activity.time,
    );

    await recentBox.put(activity.id, activity);
    // No need to emit, listener will handle it
  }

  Future<void> _onDeleteActivity(
      DeleteActivityEvent event, Emitter<RecentActivityState> emit) async {
        print("on delete bloc");
    await recentBox.delete(event.id.trim());
    // Listener will update state
  }

  @override
  Future<void> close() {
    _boxListener.removeListener(_listener);
    return super.close();
  }
}