import 'package:equatable/equatable.dart';

abstract class ShortenerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ShortenUrl extends ShortenerEvent {
  final String url;
  ShortenUrl(this.url);

  @override
  List<Object> get props => [url];
}
