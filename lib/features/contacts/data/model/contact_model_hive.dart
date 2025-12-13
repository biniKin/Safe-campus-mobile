import 'package:hive/hive.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model.dart';


part 'contact_model_hive.g.dart';

@HiveType(typeId: 0)
class ContactModelHive extends HiveObject{
  @HiveField(0)
  String name;

  @HiveField(1)
  String email;

  @HiveField(2)
  String phoneNumber;

  ContactModelHive({
    required this.email,
    required this.name,
    required this.phoneNumber
  });

  

}

extension ContactHiveMapper on ContactModelHive {
  ContactModel toContactModel() {
    return ContactModel(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}

extension ContactModelToHive on ContactModel {
  ContactModelHive toHive() {
    return ContactModelHive(
      name: name,
      email: email,
      phoneNumber: phoneNumber,
    );
  }
}
