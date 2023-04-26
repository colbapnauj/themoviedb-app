// To parse this JSON data, do
//
//     final playNowResponse = playNowResponseFromMap(jsonString);

import 'dart:convert';

import 'package:peliculas_app/domain/models/movie.dart';

class PlayNowResponse {
    PlayNowResponse({
        required this.dates,
        required this.page,
        required this.movies,
        required this.totalPages,
        required this.totalResults,
    });

    final Dates dates;
    final int page;
    final List<Movie> movies;
    final int totalPages;
    final int totalResults;

    factory PlayNowResponse.fromJson(String str) => PlayNowResponse.fromMap(json.decode(str));

    factory PlayNowResponse.fromMap(Map<String, dynamic> json) => PlayNowResponse(
        dates: Dates.fromMap(json["dates"]),
        page: json["page"],
        movies: List<Movie>.from(json["results"].map((x) => Movie.fromMap(x))),
        totalPages: json["total_pages"],
        totalResults: json["total_results"],
    );

}

class Dates {
    Dates({
        required this.maximum,
        required this.minimum,
    });

    final DateTime maximum;
    final DateTime minimum;


    factory Dates.fromJson(String str) => Dates.fromMap(json.decode(str));

    

    factory Dates.fromMap(Map<String, dynamic> json) => Dates(
        maximum: DateTime.parse(json["maximum"]),
        minimum: DateTime.parse(json["minimum"]),
    );
}
