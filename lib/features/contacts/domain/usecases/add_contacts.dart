import 'package:safe_campus/features/contacts/domain/repository/contact_list_repository.dart';

class AddContacts {
  ContactListRepository repository;
  AddContacts({required this.repository});
  Future<void> call({required Map<String, dynamic> contact}) async {
    return await repository.addContact(contact);
  }
}
