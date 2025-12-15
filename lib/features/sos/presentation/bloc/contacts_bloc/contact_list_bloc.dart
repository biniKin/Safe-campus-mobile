import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model_hive.dart';
import 'package:safe_campus/features/contacts/domain/repository/contact_list_repository.dart';

import 'contact_list_event.dart';
import 'contact_list_state.dart';

class ContactListBloc extends Bloc<ContactListEvent, ContactListState> {
  final ContactListRepository repository;

  late final ValueListenable<Box<ContactModelHive>> _contactsListenable;
  late final VoidCallback _hiveListener;

  ContactListBloc({required this.repository}) : super(ContactListInitial()) {
    on<LoadContactsEvent>(_onLoadContacts);
    on<AddContactEvent>(_onAddContact);
    on<DeleteContactEvent>(_onDeleteContact);
    on<ContactsUpdatedFromHive>((event, emit) {
      emit(ContactListLoaded(event.contacts));
    });

    _listenToHive();
  }

  void _listenToHive() {
    _contactsListenable = repository.watchContacts();

    _hiveListener = () {
      final box = _contactsListenable.value;
      final contacts =
          box.values.map((hiveModel) => hiveModel.toContactModel()).toList();
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
      final contacts = await repository.fetchContacts();
      print(contacts.length);
      //final contacts = [
      //  Contact(name: "Biniyam", phoneNumber: "09459094523", email: "biniyamkinfe122@gmail.com"),
      //  Contact(name: "Alex", phoneNumber: "09459094523", email: "Alexkinfe122@gmail.com"),
      //  Contact(name: "Biniyam", phoneNumber: "09459094523", email: "biniyamkinfe122@gmail.com"),
      //];
      // Hive listener will emit loaded state
      emit(ContactListLoaded(contacts));
    } catch (e) {
      print("error on loading contacts: $e");
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
      print("on delete trusted contacts bloc");
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
