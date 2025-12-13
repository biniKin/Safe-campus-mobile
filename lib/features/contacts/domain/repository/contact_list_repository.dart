import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model_hive.dart';
import 'package:safe_campus/features/contacts/domain/entities/contact.dart';

abstract class ContactListRepository {
  Future<List<Contact>> fetchContacts();
  Future<void> addContact(Map<String, dynamic> contact);
  Future<void> deleteContact(String email);
  Future<void> updateContact(String email, Map<String, dynamic> updatedContact);

  ValueListenable<Box<ContactModelHive>> watchContacts();

}
