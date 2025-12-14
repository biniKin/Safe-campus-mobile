import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/auth/data/services/alert_service.dart';
import 'package:safe_campus/features/core/data/models/announcement_model.dart';
import 'package:safe_campus/features/core/presentation/bloc/announcement_bloc/announcement_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/announcement_bloc/announcement_state.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState>{
  AnnouncementBloc() : super(AnnouncementsInitial()){
    final alertSerive = AlertService();
    on<FetchAnnouncements>((event, emit) async{
      emit(FetchingAnnouncements());
      try{
        // final anno = await alertSerive.fetchAnnouncements();
        // for (final alert in anno){
        //   print("Title: ${alert.title}");
        //   print("Description: ${alert.description}");
        //   print("Status: ${alert.status}");
        //   print("Time: ${alert.time}");
        // }
        final anno = [AnnouncementModel(
          title: "title", 
          description: '''
Students are advised to remain vigilant following multiple reports of suspicious activity near the main library and surrounding parking areas. Individuals have reported being followed by an unknown person during late evening hours, particularly between 8:00 PM and 11:30 PM.

Campus security is actively investigating the situation and has increased patrols in the affected areas. Students are strongly encouraged to avoid walking alone at night and to use designated campus shuttle services whenever possible.

If you notice any unusual behavior or feel unsafe at any time, immediately contact campus security or use the SOS feature within the Safe Campus application. Your safety is our highest priority, and timely reporting can help prevent further incidents.
''', 
          time: DateTime.now(), 
          status: "",
        )];
        emit(FetchedAnnouncements(announcements: anno));
      } catch(e){
        print(e);
        emit(FetchAnnouncementsError(e.toString()));
      }
      
    });
  }
}