abstract class EditProfileEvent {}



class EditProfile extends EditProfileEvent {
  final String fullName;
  final String email;

  EditProfile({required this.fullName, required this.email});
}