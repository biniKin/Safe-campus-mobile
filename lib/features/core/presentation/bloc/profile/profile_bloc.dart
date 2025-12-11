import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:safe_campus/features/auth/data/services/auth_service.dart';
import 'package:safe_campus/features/auth/domain/entities/user.dart';
import 'package:safe_campus/features/core/presentation/bloc/profile/profile_event.dart';
import 'package:safe_campus/features/core/presentation/bloc/profile/profile_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState>{
  
  ProfileBloc() : super(ProfileInitial()){
    on<GetUser>((event, emit) async{
      final prefs = await SharedPreferences.getInstance();
      final AuthService _authService = AuthService(prefs);

      try{
        final user = await _authService.getUser();
        if(user == null) return;
        emit(FetchedUserData(user: user));
        print(user);
      }catch(e){
        print("Error on fetching user data: $e");
      }
    });
  }
}