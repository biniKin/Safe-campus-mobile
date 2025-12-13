import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/auth/data/services/alert_service.dart';
import 'package:safe_campus/features/core/presentation/bloc/announcement_bloc/announcement_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/announcement_bloc/announcement_state.dart';

class AnnouncementBloc extends Bloc<AnnouncementEvent, AnnouncementState>{
  AnnouncementBloc() : super(AnnouncementsInitial()){
    final alertSerive = AlertService();
    on<FetchAnnouncements>((event, emit) async{
      emit(FetchingAnnouncements());
      try{
        final anno = await alertSerive.fetchAnnouncements();
        emit(FetchedAnnouncements(announcements: anno));
      } catch(e){
        print(e);
        emit(FetchAnnouncementsError(e.toString()));
      }
      
    });
  }
}