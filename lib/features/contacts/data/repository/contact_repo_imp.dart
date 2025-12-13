import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:safe_campus/features/contacts/data/contact_list_datasource/contact_list_datasource.dart';
import 'package:safe_campus/features/contacts/data/contact_list_datasource/contact_list_local_datasource.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model_hive.dart';
import 'package:safe_campus/features/contacts/domain/entities/contact.dart';
import 'package:safe_campus/features/contacts/domain/repository/contact_list_repository.dart';

class ContactRepositoryImpl implements ContactListRepository {
  final ContactListDataSource remote;
  final ContactLocalDataSource local;

  ContactRepositoryImpl({
    required this.remote,
    required this.local,
  });

  // ---------------- FETCH ----------------
  @override
  Future<List<Contact>> fetchContacts() async {
    final localContacts = local.getContacts();

    //if (localContacts.isNotEmpty) {
      // print("Loacl storage for contacts is not empty");
      //_syncInBackground();
      //print(localContacts[0]);
      return localContacts;
    //}

    //final remoteContacts = await remote.fetchContacts();
    //await local.saveContacts(remoteContacts);
    //return remoteContacts;
  }

  // ---------------- ADD (optimistic) ----------------
  @override
  Future<void> addContact(Map<String, dynamic> contact) async {
    final model = ContactModel.fromMap(contact);

    // 1. save locally
    await local.addContact(model);

    // 2. send to backend
    try {
      await remote.addContact(contact);
    } catch (e) {
      // optional rollback later
      throw Exception('Failed to sync add contact: $e');
    }
  }

  // ---------------- DELETE (optimistic) ----------------
  @override
  Future<void> deleteContact(String email) async {
    // 1. delete locally
    await local.deleteContact(email);

    // 2. delete remotely
    try {
      //await remote.deleteContact(email);
    } catch (e) {
      throw Exception('Failed to sync delete contact: $e');
    }
  }

  // ---------------- UPDATE ----------------
  @override
  Future<void> updateContact(
    String email,
    Map<String, dynamic> updatedContact,
  ) async {
    final updatedModel = ContactModel(
      name: updatedContact['name'],
      phoneNumber: updatedContact['phone'],
      email: email, // authoritative source
    );


    // update local
    await local.addContact(updatedModel);

    // update remote
    try {
      await remote.updateContact(email, updatedContact);
    } catch (e) {
      throw Exception('Failed to sync update contact: $e');
    }
  }

  @override
  ValueListenable<Box<ContactModelHive>> watchContacts() {
    return local.watchContacts();
  }


  // ---------------- BACKGROUND SYNC ----------------
  Future<void> _syncInBackground() async {
    try {
      //final remoteContacts = await remote.fetchContacts();
      print("on sync contacts");
      //await local.saveContacts(remoteContacts);
    } catch (e) {
      // silent fail (offline, server down)
      print("error on sync contacts: $e");
      return;
    }
  }

  
}
