import 'package:safe_campus/features/auth/domain/entities/user.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState{
  
}


class FetchedUserData extends ProfileState {
  final User user;

  FetchedUserData({required this.user});
}