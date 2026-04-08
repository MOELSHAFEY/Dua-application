import 'package:equatable/equatable.dart';

abstract class AccessState extends Equatable {
  const AccessState();

  @override
  List<Object> get props => [];
}

class AccessInitial extends AccessState {}

class AccessLoading extends AccessState {}

class AccessUpdateRequired extends AccessState {
  final String updateUrl;
  const AccessUpdateRequired(this.updateUrl);

  @override
  List<Object> get props => [updateUrl];
}

class AccessAuthorized extends AccessState {}

class AccessError extends AccessState {
  final String message;
  const AccessError(this.message);

  @override
  List<Object> get props => [message];
}
