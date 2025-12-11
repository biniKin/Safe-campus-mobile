import 'package:safe_campus/features/contacts/domain/entities/contact.dart';
import 'package:safe_campus/features/contacts/domain/repository/contact_list_repository.dart';

class FetchContacts {
  ContactListRepository repository;
  FetchContacts({required this.repository});
  Future<Contact> call() async {
    return await repository.fetchContacts();
  }
}
