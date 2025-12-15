import 'package:equatable/equatable.dart';
import 'package:safe_campus/features/contacts/data/model/contact_model.dart';
import 'package:safe_campus/features/contacts/domain/entities/contact.dart';


abstract class ShareRouteEvent extends Equatable {
  const ShareRouteEvent();

  @override
  List<Object?> get props => [];
}

class ShareRouteRequested extends ShareRouteEvent {
  final Map<String, List<dynamic>> coordinates;
  final List<Contact> contacts;

  const ShareRouteRequested({
    required this.coordinates,
    required this.contacts,
  });

  @override
  List<Object?> get props => [coordinates, contacts];
}
