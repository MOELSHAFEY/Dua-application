import 'package:equatable/equatable.dart';

abstract class DrugDetailsState extends Equatable {
  const DrugDetailsState();

  @override
  List<Object> get props => [];
}

class DrugDetailsInitial extends DrugDetailsState {}

class DrugDetailsLoading extends DrugDetailsState {}

class DrugDetailsLoaded extends DrugDetailsState {
  final String info;
  const DrugDetailsLoaded(this.info);

  @override
  List<Object> get props => [info];
}

class DrugDetailsError extends DrugDetailsState {
  final String message;
  const DrugDetailsError(this.message);

  @override
  List<Object> get props => [message];
}
