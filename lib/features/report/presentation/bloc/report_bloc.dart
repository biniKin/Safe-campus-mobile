import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:safe_campus/features/report/domain/usecases/send_report.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  SendReport sendReport;

  ReportBloc({required this.sendReport}) : super(ReportInitial()) {
    on<SendReportEvent>((event, emit) async {
      emit(ReportLoading());
      try {
        print('ReportBloc: SendReportEvent received');
        final response = await sendReport.call(
          description: event.description,
          tags: event.tags,
          image: event.image,
          location: event.location,
          token: event.token,
        );
        if (response.success) {
          emit(ReportSuccess(message: response.message));
        } else {
          print("error from bloc: ${response.message}");
          emit(ReportFailed(response.message));
        }
      } catch (e) {
        print("Error on report block: $e");
        emit(
          ReportFailed(e.toString()),
        ); // You might want to emit an error state here
      }
    });
  }
}
