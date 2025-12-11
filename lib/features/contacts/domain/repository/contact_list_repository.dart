import 'package:safe_campus/features/contacts/domain/entities/contact.dart';

abstract class ContactListRepository {
  Future<Contact> fetchContacts();
  Future<void> addContact(Map<String, dynamic> contact);
  Future<void> deleteContact(String email);
  Future<void> updateContact(String email, Map<String, dynamic> updatedContact);
}
