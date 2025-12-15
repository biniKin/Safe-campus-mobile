import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/features/sos/presentation/bloc/edit_profile_bloc/edit_profile_event.dart';
import 'package:safe_campus/features/sos/presentation/bloc/edit_profile_bloc/edit_profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInit()) {
    on<EditProfile>((event, emit) async {
      try {
        emit(ProfileEditing());
        final prefs = await SharedPreferences.getInstance();
        final _authService = AuthService(prefs);
        print("on updating use");
        print("name: ${event.fullName}");
        print("email: ${event.email}");

        _authService.updateUser(event.fullName, event.email);
        emit(ProfileEdited());
      } catch (e) {
        print("Error while editing profile: $e");
        emit(ProfileEditFailed("failed on editing profile"));
      }
    });
  }
}
