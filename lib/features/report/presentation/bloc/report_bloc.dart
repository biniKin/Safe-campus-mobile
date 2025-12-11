import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe_campus/features/report/usecases/send_report.dart';
import 'dart:developer' as console show log;
part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  SendReport sendReport;

  ReportBloc({required this.sendReport}) : super(ReportInitial()) {
    on<SendReportEvent>((event, emit) async {
      emit(ReportLoading());
      try {
        console.log('ReportBloc: SendReportEvent received');
        await sendReport.call(
          description: event.description,
          tags: event.tags,
          image: event.image,
          location: event.location,
          token: event.token,
        );
        emit(ReportSuccess(message: 'Report sent successfully'));
      } catch (e) {
        emit(ReportInitial()); // You might want to emit an error state here
      }
    });
  }
}
