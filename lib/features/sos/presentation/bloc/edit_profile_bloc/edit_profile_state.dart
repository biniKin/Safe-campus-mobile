abstract class EditProfileState {}

class EditProfileInit extends EditProfileState {

}

class ProfileEdited extends EditProfileState {

}

class ProfileEditing extends EditProfileState {}

class ProfileEditFailed extends EditProfileState {
  final String msg;
  ProfileEditFailed(this.msg);
}