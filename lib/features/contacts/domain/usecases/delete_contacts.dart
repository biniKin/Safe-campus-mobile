import 'package:safe_campus/features/contacts/domain/repository/contact_list_repository.dart';

class DeleteContacts {
  final ContactListRepository repository;

  DeleteContacts({required this.repository});

  Future<void> call({required String email}) async {
    return await repository.deleteContact(email);
  }
}
