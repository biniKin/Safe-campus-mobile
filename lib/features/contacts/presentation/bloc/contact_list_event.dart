part of 'contact_list_bloc.dart';

sealed class ContactListEvent extends Equatable {
  const ContactListEvent();

  @override
  List<Object> get props => [];
}

final class FetchContactListEvent extends ContactListEvent {}

final class AddContactEvent extends ContactListEvent {
  final Map<String, dynamic> contact;

  const AddContactEvent({required this.contact});

  @override
  List<Object> get props => [contact];
}

final class UpdateContactEvent extends ContactListEvent {
  final String email;
  final Map<String, dynamic> updatedContact;

  const UpdateContactEvent({required this.email, required this.updatedContact});

  @override
  List<Object> get props => [email, updatedContact];
}

final class DeleteContactEvent extends ContactListEvent {
  final String email;

  const DeleteContactEvent({required this.email});

  @override
  List<Object> get props => [email];
}
