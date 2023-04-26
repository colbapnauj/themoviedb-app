import 'package:peliculas_app/domain/models/models.dart';
import 'package:peliculas_app/domain/repository/movies_repository.dart';

class MovieLocal implements MoviesRepository {
  @override
  Future<List<Movie>> getMoviesPlayingNow({int page = 1}) {
    // TODO: implement getMoviesPlayNow
    throw UnimplementedError();
  }

  @override
  Future<List<Movie>> getPopularMovies({int page = 1}) {
    // TODO: implement getMoviesPopular
    throw UnimplementedError();
  }
  
  @override
  Future<CreditsResponse> getCredits(int movieId) {
    // TODO: implement getCredits
    throw UnimplementedError();
  }
  
  @override
  Future<SearchMovieResponse> searchMovie(String query) {
    // TODO: implement searchMovie
    throw UnimplementedError();
  }
  
}
