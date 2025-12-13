import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model_hive.dart';

abstract class ContactLocalDataSource {
  List<ContactModel> getContacts();
  Future<void> saveContacts(List<ContactModel> contacts);
  Future<void> addContact(ContactModel contact);
  Future<void> deleteContact(String email);
  Future<void> clear();

  ValueListenable<Box<ContactModelHive>> watchContacts();

}
