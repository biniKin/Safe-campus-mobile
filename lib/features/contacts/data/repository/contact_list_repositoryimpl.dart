import 'package:safe_campus/features/contacts/data/contact_list_datasource/contact_list_datasource.dart';
import 'package:safe_campus/features/contacts/domain/entities/contact.dart';
import 'package:safe_campus/features/contacts/domain/repository/contact_list_repository.dart';

class ContactListRepositoryImpl implements ContactListRepository {
  ContactListDataSource contactListDataSource;
  ContactListRepositoryImpl({required this.contactListDataSource});
  @override
  Future<void> addContact(Map<String, dynamic> contact) async {
    try {
      await contactListDataSource.addContact(contact);
    } catch (e) {
      throw Exception('Failed to add contact: $e');
    }
  }

  @override
  Future<void> deleteContact(String email) async {
    try {
      await contactListDataSource.deleteContact(email);
    } catch (e) {
      throw Exception('Failed to delete contact: $e');
    }
  }

  @override
  Future<Contact> fetchContacts() async {
    try {
      final contactsList = await contactListDataSource.fetchContacts();
      return contactsList;
    } catch (e) {
      throw Exception('Failed to fetch contacts: $e');
    }
  }

  @override
  Future<void> updateContact(
    String email,
    Map<String, dynamic> updatedContact,
  ) {
    try {
      return contactListDataSource.updateContact(email, updatedContact);
    } catch (e) {
      throw Exception('Failed to update contact: $e');
    }
  }
}
