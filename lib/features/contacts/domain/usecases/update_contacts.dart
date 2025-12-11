import 'package:safe_campus/features/contacts/domain/repository/contact_list_repository.dart';

class UpdateContacts {
  ContactListRepository repository;
  UpdateContacts({required this.repository});

  Future<void> call({
    required String email,
    required Map<String, dynamic> updatedContact,
  }) async {
    return await repository.updateContact(email, updatedContact);
  }
}
