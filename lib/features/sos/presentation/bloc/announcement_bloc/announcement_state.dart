import 'package:safe_campus/features/sos/data/models/announcement_model.dart';

abstract class AnnouncementState {}

class AnnouncementsInitial extends AnnouncementState {}

class FetchingAnnouncements extends AnnouncementState {}

class FetchAnnouncementsError extends AnnouncementState {
  final String msg;
  FetchAnnouncementsError(this.msg);
}

class FetchedAnnouncements extends AnnouncementState {
  final List<AnnouncementModel> announcements;
  FetchedAnnouncements({required this.announcements});
}
