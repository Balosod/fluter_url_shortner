import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'shortener_event.dart';
import 'shortener_state.dart';

class ShortenerBloc extends Bloc<ShortenerEvent, ShortenerState> {
  ShortenerBloc() : super(ShortenerInitial()) {
    on<ShortenUrl>(_onShortenUrl);
  }

  List<Map<String, String>> links = [];

  Future<void> _onShortenUrl(ShortenUrl event, Emitter<ShortenerState> emit) async {
    emit(ShortenerLoading());

    try {
      final url = Uri.parse('https://ur-tuki.onrender.com/api/post-link');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"link": event.url}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final shortenedLink = "https://ur-tuki.onrender.com/api/get-link/${responseData['message']['shorted_link']}";

        links.add({"link": event.url, "shorted_link": shortenedLink});
        emit(ShortenerSuccess(List.from(links))); // Emit new state
      } else {
        emit(ShortenerFailure("Failed to shorten URL"));
      }
    } catch (e) {
      emit(ShortenerFailure("Something went wrong"));
    }
  }
}
