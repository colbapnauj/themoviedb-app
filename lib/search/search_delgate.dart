import 'package:flutter/material.dart';
import 'package:peliculas_app/constants/assets.dart';
import 'package:peliculas_app/constants/routes_names.dart';
import 'package:peliculas_app/domain/models/models.dart';

class MovieSearchDelegate extends SearchDelegate {
  MovieSearchDelegate({
    required this.onSearch,
    required this.suggestionStream,
  });

  final Function(String) onSearch;
  final Stream<List<Movie>> suggestionStream;

  @override
  String? get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return emptyContainer(context);
    }

    onSearch(query);

    return StreamBuilder(
      stream: suggestionStream,
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) {
          return emptyContainer(context);
        }

        final movies = snapshot.data!;

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: movies.length,
          itemBuilder: (_, int index) {
            movies[index] = movies[index].copyWith(
              heroId: 'search-${movies[index].id}',
            );
            return SearchMovieItem(
              movies[index],
            );
          },
        );
      },
    );
  }

  Widget emptyContainer(BuildContext context) {
    return Center(
      child: Icon(
        Icons.movie_creation_outlined,
        color: Theme.of(context).backgroundColor,
        size: 130,
      ),
    );
  }
}

class SearchMovieItem extends StatelessWidget {
  const SearchMovieItem(this.movie, {Key? key}) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Hero(
        tag: movie.heroId,
        child: FadeInImage(
            placeholder: const AssetImage(Assets.noImage),
            image: NetworkImage(movie.fullPosterImg),
            width: 50,
            fit: BoxFit.contain),
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(
          context,
          RoutesNames.details,
          arguments: <String, dynamic>{
            'movie_details': movie,
          },
        );
      },
    );
  }
}
