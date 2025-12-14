import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safe_campus/features/contacts/data/contact_list_datasource/contact_list_local_datasource.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model_hive.dart';

class ContactLocalDataSourceImpl implements ContactLocalDataSource {
  final Box<ContactModelHive> box;

  ContactLocalDataSourceImpl(this.box);

  @override
  List<ContactModel> getContacts() {
    print("on getting contacts.......");
    
    return box.values
        .map((hiveContact) => hiveContact.toContactModel())
        .toList();
  }

  @override
  Future<void> saveContacts(List<ContactModel> contacts) async {
    await box.clear();
    for (final contact in contacts) {
      await box.put(contact.email, contact.toHive());
    }
  }

  @override
  Future<void> addContact(ContactModel contact) async {
    await box.put(contact.email, contact.toHive());
  }

  @override
  Future<void> deleteContact(String email) async {
    print("on delete locally");
    await box.delete(email.trim());
  }
  
  @override
  Future<void> clear() async{
    // TODO: implement clear
    await box.clear();
  }

  @override
  ValueListenable<Box<ContactModelHive>> watchContacts() {
    return box.listenable();
  }

}
