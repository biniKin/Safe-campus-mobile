import 'package:equatable/equatable.dart';

abstract class ShareRouteState extends Equatable {
  const ShareRouteState();

  @override
  List<Object?> get props => [];
}

class ShareRouteInitial extends ShareRouteState {}

class ShareRouteLoading extends ShareRouteState {}

class ShareRouteSuccess extends ShareRouteState {}

class ShareRouteFailure extends ShareRouteState {
  final String message;

  const ShareRouteFailure(this.message);

  @override
  List<Object?> get props => [message];
}
