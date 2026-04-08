import 'package:equatable/equatable.dart';
import 'package:dua/core/entities/drug.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Drug> drugs;
  const SearchLoaded(this.drugs);

  @override
  List<Object> get props => [drugs];
}

class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);

  @override
  List<Object> get props => [message];
}
