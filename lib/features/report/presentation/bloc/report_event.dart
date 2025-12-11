part of 'report_bloc.dart';

class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object> get props => [];
}

class SendReportEvent extends ReportEvent {
  final String description;
  final String tags;
  final String image;
  final Map<String, String> location;
  final String token;

  const SendReportEvent({
    required this.description,
    required this.tags,
    required this.image,
    required this.location,
    required this.token,
  });

  @override
  List<Object> get props => [description, tags, image, location, token];
}
