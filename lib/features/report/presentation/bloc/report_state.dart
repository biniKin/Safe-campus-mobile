part of 'report_bloc.dart';

sealed class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object> get props => [];
}

final class ReportInitial extends ReportState {}

final class ReportLoading extends ReportState {}

final class ReportSuccess extends ReportState {
  final String message;
  const ReportSuccess({required this.message});

  @override
  List<Object> get props => [message];
}

final class ReportFailed extends ReportState{
  final String msg;
  const ReportFailed(this.msg);
}
