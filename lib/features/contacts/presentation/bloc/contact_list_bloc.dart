// import 'package:bloc/bloc.dart';
// import 'package:equatable/equatable.dart';
// import 'package:safe_campus/features/contacts/data/model/contact_model.dart';
// import 'package:safe_campus/features/contacts/domain/entities/contact.dart';
// import 'package:safe_campus/features/contacts/domain/usecases/add_contacts.dart';
// import 'package:safe_campus/features/contacts/domain/usecases/delete_contacts.dart';
// import 'package:safe_campus/features/contacts/domain/usecases/fetch_contacts.dart';
// import 'package:safe_campus/features/contacts/domain/usecases/update_contacts.dart';
// import 'dart:developer' as console show log;
// part 'contact_list_event.dart';
// part 'contact_list_state.dart';

// class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
//   AddContacts addContact;
//   FetchContacts fetchContacts;
//   UpdateContacts updateContacts;
//   DeleteContacts deleteContacts;

//   ContactListBloc({
//     required this.addContact,
//     required this.fetchContacts,
//     required this.updateContacts,
//     required this.deleteContacts,
//   }) : super(ContactListInitial()) {
//     on<FetchContactListEvent>((event, emit) async {
//       emit(ContactListLoading());
//       try {
//         final contacts = await fetchContacts.call();
//         console.log('Fetched contacts: $contacts');
//         emit(ContactListLoaded(contacts: contacts));
//       } catch (e) {
//         emit(ContactListError(message: e.toString()));
//       }
//     });

//     on<AddContactEvent>((event, emit) async {
//       try {
//         await addContact.call(contact: event.contact);
//         emit(ContactOperationSuccess(message: "Contact added successfully"));
//       } catch (e) {
//         emit(ContactListError(message: e.toString()));
//       }
//     });

//     on<UpdateContactEvent>((event, emit) async {
//       try {
//         await updateContacts.call(
//           email: event.email,
//           updatedContact: event.updatedContact,
//         );
//         emit(ContactOperationSuccess(message: "Contact updated successfully"));
//       } catch (e) {
//         emit(ContactListError(message: e.toString()));
//       }
//     });

//     on<DeleteContactEvent>((event, emit) async {
//       try {
//         await deleteContacts.call(email: event.email);
//         emit(ContactOperationSuccess(message: "Contact deleted successfully"));
//       } catch (e) {
//         emit(ContactListError(message: e.toString()));
//       }
//     });
//   }
// }


import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model_hive.dart';
import 'package:safe_campus/features/contacts/data/repository/contact_repo_imp.dart';
import 'package:safe_campus/features/contacts/domain/repository/contact_list_repository.dart';

import '../../domain/entities/contact.dart';


import 'contact_list_event.dart';
import 'contact_list_state.dart';
class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactListRepository repository;

  late final ValueListenable<Box<ContactModelHive>> _contactsListenable;
  late final VoidCallback _hiveListener;

  ContactListBloc({required this.repository})
      : super(ContactListInitial()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
    on<DeleteContactEvent>(_onDeleteContact);
    

    _listenToHive();
  }

  void _listenToHive() {
  _contactsListenable = repository.watchContacts();

  _hiveListener = () {
    final box = _contactsListenable.value;
    final contacts = box.values
        .map((hiveModel) => hiveModel.toContactModel())
        .toList();
    add(ContactsUpdatedFromHive(contacts));
  };

  _contactsListenable.addListener(_hiveListener);
}

  Future<void> _onLoadContacts(
    LoadContactsEvent event,
    Emitter<ContactListState> emit,
  ) async {
    emit(ContactListLoading());

    try {
      await repository.fetchContacts();
      // Hive listener will emit loaded state
    } catch (e) {
      emit(ContactListError(e.toString()));
    }
  }

  Future<void> _onAddContact(
    AddContactEvent event,
    Emitter<ContactListState> emit,
  ) async {
    try {
      await repository.addContact(event.contact);
    } catch (e) {
      emit(ContactListError(e.toString()));
    }
  }

  Future<void> _onDeleteContact(
    DeleteContactEvent event,
    Emitter<ContactListState> emit,
  ) async {
    try {
      await repository.deleteContact(event.email);
    } catch (e) {
      emit(ContactListError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _contactsListenable.removeListener(_hiveListener);
    return super.close();
  }
}