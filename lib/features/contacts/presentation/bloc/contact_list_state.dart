part of 'contact_list_bloc.dart';

sealed class ContactListState extends Equatable {
  const ContactListState();

  @override
  List<Object> get props => [];
}

final class ContactListInitial extends ContactListState {}

final class ContactListLoading extends ContactListState {}

final class ContactListLoaded extends ContactListState {
  final Contact contacts;
  const ContactListLoaded({required this.contacts});

  @override
  List<Object> get props => [contacts];
}

final class ContactListError extends ContactListState {
  final String message;
  const ContactListError({required this.message});

  @override
  List<Object> get props => [message];
}

final class ContactOperationSuccess extends ContactListState {
  final String message;
  const ContactOperationSuccess({required this.message});

  @override
  List<Object> get props => [message];
}
