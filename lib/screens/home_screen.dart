import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/search/search_delgate.dart';

import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = context.read<MoviesProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Películas en cine'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MovieSearchDelegate(
                    onSearch: moviesProvider.getSuggestionsByQuery,
                    suggestionStream: moviesProvider.suggestionStream,
                  ),
                );
              },
              icon: const Icon(Icons.search_rounded))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const <Widget>[
            CardSwiper(),
            MovieSlider(title: 'Populares'),
          ],
        ),
      ),
    );
  }
}
