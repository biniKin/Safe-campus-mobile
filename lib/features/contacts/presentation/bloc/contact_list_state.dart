// part of 'contact_list_bloc.dart';

// sealed class ContactListState extends Equatable {
//   const ContactListState();

//   @override
//   List<Object> get props => [];
// }

// final class ContactListInitial extends ContactListState {}

// final class ContactListLoading extends ContactListState {}

// final class ContactListLoaded extends ContactListState {
//   final List<Contact> contacts;

//   const ContactListLoaded({required this.contacts});

//   @override
//   List<Object> get props => [contacts];
// }

// final class ContactListError extends ContactListState {
//   final String message;
//   const ContactListError({required this.message});

//   @override
//   List<Object> get props => [message];
// }

// final class ContactOperationSuccess extends ContactListState {
//   final String message;
//   const ContactOperationSuccess({required this.message});

//   @override
//   List<Object> get props => [message];
// }


import 'package:equatable/equatable.dart';
import '../../domain/entities/contact.dart';

abstract class ContactListState extends Equatable {
  const ContactListState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ContactListInitial extends ContactListState {}

/// While fetching/syncing
class ContactListLoading extends ContactListState {}

/// Main state – UI will usually live here
class ContactListLoaded extends ContactListState {
  final List<Contact> contacts;

  const ContactListLoaded(this.contacts);

  @override
  List<Object?> get props => [contacts];
}

/// Error state (network / parsing / etc.)
class ContactListError extends ContactListState {
  final String message;

  const ContactListError(this.message);

  @override
  List<Object?> get props => [message];
}


