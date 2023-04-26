import 'package:http/http.dart' as http;
import 'package:peliculas_app/data/api_routes.dart';
import 'package:peliculas_app/domain/models/models.dart';
import 'package:peliculas_app/domain/repository/movies_repository.dart';

class MovieImpl implements MoviesRepository {
  final String _apiKey = '46796d25b522e33ed085b1f788734edc';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'es-ES';

  String apiVersion = '3';

  @override
  Future<SearchMovieResponse> searchMovie(String query) async {
    try {
      final jsonData = await _getJsonData(
        ApiRoutes.moviesGetSearchMovie,
        query: query,
      );

      final decodeData = SearchMovieResponse.fromJson(jsonData);
      return decodeData;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<CreditsResponse> getCredits(int movieId) async {
    try {
      final jsonData =
          await _getJsonData('/movie/$movieId${ApiRoutes.moviesGetCredits}');

      final decodeData = CreditsResponse.fromJson(jsonData);
      return decodeData;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final jsonData = await _getJsonData(
        ApiRoutes.moviesPopular,
        page: '$page',
      );
      final decodeData = PopularResponse.fromJson(jsonData);
      return decodeData.movies;
    } catch (_) {
      rethrow;
    }
  }

  @override
  Future<List<Movie>> getMoviesPlayingNow({int page = 1}) async {
    try {
      final jsonData = await _getJsonData(
        ApiRoutes.moviesNowPlaying,
        page: '$page',
      );
      final decodeData = PlayNowResponse.fromJson(jsonData);
      return decodeData.movies;
    } catch (_) {
      rethrow;
    }
  }

  Future<String> _getJsonData(String endpoint,
      {String? page, String? query}) async {
    final Uri url = Uri.https(
      _baseUrl,
      '$apiVersion$endpoint',
      {
        'api_key': _apiKey,
        'language': _language,
        'page': page,
        'query': query,
      },
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw 'Error';
    }

    return response.body;
  }
}
