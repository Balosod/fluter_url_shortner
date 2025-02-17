import 'package:equatable/equatable.dart';

abstract class ShortenerState extends Equatable {
  @override
  List<Object> get props => [];
}

class ShortenerInitial extends ShortenerState {}

class ShortenerLoading extends ShortenerState {}

class ShortenerSuccess extends ShortenerState {
  final List<Map<String, String>> links;
  ShortenerSuccess(this.links);

  @override
  List<Object> get props => [links];
}

class ShortenerFailure extends ShortenerState {
  final String error;
  ShortenerFailure(this.error);

  @override
  List<Object> get props => [error];
}
