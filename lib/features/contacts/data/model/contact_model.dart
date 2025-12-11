import '../../domain/entities/contact.dart';

class ContactModel extends Contact {
  ContactModel({
    required super.name,
    required super.phoneNumber,
    required super.email,
  });

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      email: map['email'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {'name': name, 'phoneNumber': phoneNumber, 'email': email};
  }
}
