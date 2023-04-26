import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:peliculas_app/domain/models/models.dart';
import 'package:peliculas_app/domain/repository/movies_repository.dart';
import 'package:peliculas_app/helpers/helpers.dart';

class MoviesProvider extends ChangeNotifier {
  MoviesProvider({required this.moviesRepository}) {
    if (kDebugMode) {
      print('provider movies');
    }

    getOnDisplayMovies();
    getPopularMovies();
  }

  bool isLoading = false;

  final MoviesRepository moviesRepository;

  List<Movie> playingNowMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> moviesCast = {};
  Map<String, List<Movie>> moviesSearch = {};

  CreditsResponse credits = CreditsResponse(id: 0, cast: [], crew: []);

  int _popularPage = 0;

  final debouncer = Debouncer(
    duration: const Duration(milliseconds: 800),
  );

  final StreamController<List<Movie>> _suggestionStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionStreamController.stream;

  void getSuggestionsByQuery(String query) {
    debouncer.value = query;
    debouncer.onValue = (value) async {
      final result = await searchMovie(query);
      _suggestionStreamController.add(result);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }

  Future<List<Movie>> searchMovie(String query) async {
    try {
      if (moviesSearch.containsKey(query)) return moviesSearch[query]!;

      final response = await moviesRepository.searchMovie(query);

      moviesSearch[query] = response.movies;
      return response.movies;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<List<Cast>> getMovieCredits(int movieId) async {
    try {
      if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

      credits = await moviesRepository.getCredits(movieId);
      moviesCast[movieId] = credits.cast;

      return credits.cast;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<void> getOnDisplayMovies() async {
    try {
      playingNowMovies = await moviesRepository.getMoviesPlayingNow();
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }

  Future<void> getPopularMovies() async {
    isLoading = true;
    _popularPage++;

    try {
      final movies = await moviesRepository.getPopularMovies(
        page: _popularPage,
      );
      await Future.delayed(const Duration(seconds: 1));
      isLoading = false;
      popularMovies = [...popularMovies, ...movies];
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      isLoading = false;
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
    _suggestionStreamController.close();
  }
}
