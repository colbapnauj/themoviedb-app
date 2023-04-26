import 'package:flutter/material.dart';
import 'package:peliculas_app/domain/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dynamic arguments = ModalRoute.of(context)?.settings.arguments;

    // final MoviesProvider moviesProvider = context.read<MoviesProvider>();
    final MoviesProvider moviesProvider = Provider.of(context);

    late Movie movie;

    if (arguments == null || arguments['movie_details'] == null) {
      movie = Movie.empty;
    } else {
      movie = arguments['movie_details'] as Movie;
      moviesProvider.getMovieCredits(movie.id).then((value) {});
    }
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _CustomAppBar(
              movie.title, movie.fullBackdropPath, 'movie_${movie.id}'),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      _PosterAndTitle(
                        title: movie.title,
                        originalTitle: movie.originalTitle,
                        poster: movie.fullPosterImg,
                        voteAverage: movie.voteAverage,
                        tag: movie.heroId,
                      ),
                      const SizedBox(height: 10),
                      _OverView(movie.overview),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                CastingCards(movieId: movie.id),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  const _CustomAppBar(this.title, this.poster, this.heroTag, {Key? key})
      : super(key: key);

  final String title;
  final String poster;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: EdgeInsets.zero,
        title: Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.bottomCenter,
            color: Colors.black12,
            child: Text(
              title,
              style: Theme.of(context).textTheme.headline4,
            )),
        background: FadeInImage(
            placeholder: const AssetImage('assets/loading.gif'),
            image: NetworkImage(poster),
            fit: BoxFit.cover),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  const _PosterAndTitle({
    Key? key,
    required this.poster,
    required this.title,
    required this.originalTitle,
    required this.voteAverage,
    required this.tag,
  }) : super(key: key);

  final String poster;
  final String title;
  final String originalTitle;
  final double voteAverage;
  final String tag;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      children: [
        Hero(
          tag: tag,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/no-image.jpg'),
              image: NetworkImage(poster),
              height: 150,
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: textTheme.headline5,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  originalTitle,
                  style: textTheme.subtitle1,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.star_outline, size: 15, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text('$voteAverage', style: textTheme.caption)
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}

class _OverView extends StatelessWidget {
  const _OverView(this.overview, {Key? key}) : super(key: key);

  final String overview;

  @override
  Widget build(BuildContext context) {
    return Text(
      overview,
      textAlign: TextAlign.justify,
      style: Theme.of(context).textTheme.subtitle1,
    );
  }
}
