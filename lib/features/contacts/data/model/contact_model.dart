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
      phoneNumber: map['phone'] ?? '', // backend uses 'phone'
      email: map['email'] ?? '',
    );
  }

  @override
  String toString() {
    return 'ContactModel(name: $name, phoneNumber: $phoneNumber, email: $email)';
  }

  @override
  Map<String, dynamic> toMap() {
    return {'name': name, 'phone': phoneNumber, 'email': email};
  }
}
