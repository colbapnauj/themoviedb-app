import 'dart:convert';

import 'package:peliculas_app/domain/models/movie.dart';

class SearchMovieResponse {
  SearchMovieResponse({
    required this.page,
    required this.movies,
    required this.totalPages,
    required this.totalResults,
  });

  final int page;
  final List<Movie> movies;
  final int totalPages;
  final int totalResults;

  factory SearchMovieResponse.fromJson(String str) =>
      SearchMovieResponse.fromMap(json.decode(str));

  factory SearchMovieResponse.fromMap(Map<String, dynamic> json) =>
      SearchMovieResponse(
        page: json["page"],
        movies: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
      );
}
