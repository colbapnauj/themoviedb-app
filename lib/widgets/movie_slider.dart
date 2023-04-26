import 'package:flutter/material.dart';
import 'package:peliculas_app/domain/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieSlider extends StatefulWidget {
  const MovieSlider({
    Key? key,
    this.title,
  }) : super(key: key);

  final String? title;

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  late ScrollController _scrollController;

  late MoviesProvider moviesProvider;

  @override
  void initState() {
    _scrollController = ScrollController();
    moviesProvider = context.read<MoviesProvider>();
    super.initState();

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isEnd && !moviesProvider.isLoading) {
      moviesProvider.getPopularMovies();
    }
  }

  bool get _isEnd {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    final popularMovies = moviesProvider.popularMovies;

    return SizedBox(
      height: 245,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getTitle(widget.title),
          const SizedBox(height: 5),
          (popularMovies.isEmpty)
              ? SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(
                      3,
                      (index) => _MoviePoster(
                        Movie.empty,
                      ),
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: popularMovies.length,
                    itemBuilder: (_, index) {
                      popularMovies[index] = popularMovies[index].copyWith(
                        heroId:
                            '${widget.title}-$index-${popularMovies[index].id}',
                      );

                      if (index == popularMovies.length - 1) {
                        return const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return _MoviePoster(
                        popularMovies[index],
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }

  Widget getTitle([String? title]) {
    if (title == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Theme(
        data: Theme.of(context),
        child: Text(
          title,
          style: Theme.of(context).textTheme.headline3,
        ),
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  const _MoviePoster(
    this.movie, {
    Key? key,
  }) : super(key: key);

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      // height: 190,
      width: 130,
      child: Column(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushNamed(
              context,
              'details',
              arguments: <String, dynamic>{
                'movie_details': movie,
              },
            ),
            child: Hero(
              tag: movie.heroId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: FadeInImage(
                  placeholder: const AssetImage('assets/no-image.jpg'),
                  image: NetworkImage(
                    movie.fullPosterImg,
                  ),
                  width: 130,
                  height: 170,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
