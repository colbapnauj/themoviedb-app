import 'package:peliculas_app/domain/models/models.dart';

abstract class MoviesRepository {
  Future<List<Movie>> getMoviesPlayingNow({int page});

  Future<List<Movie>> getPopularMovies({int page});

  Future<CreditsResponse> getCredits(int movieId);

  Future<SearchMovieResponse> searchMovie(String query);
}
