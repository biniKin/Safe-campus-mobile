import 'package:flutter_bloc/flutter_bloc.dart';
import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterRequested>((event, emit) async {
      emit(RegisterLoading());
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      if (event.studentId.isNotEmpty && event.password.length >= 6) {
        emit(RegisterSuccess());
      } else {
        emit(const RegisterFailure("Invalid Registration Details"));
      }
    });
  }
}
