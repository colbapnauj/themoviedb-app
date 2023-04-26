import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_card_swipper/flutter_card_swiper.dart';
import 'package:peliculas_app/domain/models/movie.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class CardSwiper extends StatelessWidget {
  const CardSwiper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    final movies = moviesProvider.playingNowMovies;
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: movies.isEmpty
          ? MovieCard(movie: Movie.empty)
          : Swiper(
              itemCount: movies.length,
              layout: SwiperLayout.STACK,
              itemWidth: size.width * 0.6,
              itemHeight: size.height * 0.45,
              itemBuilder: (_, index) {
                if (kDebugMode) {
                  print(movies[index].posterPath ?? '');
                }

                movies[index] = movies[index]
                    .copyWith(heroId: 'swiper-${movies[index].id}');
                return GestureDetector(
                  onTap: () =>
                      Navigator.pushNamed(context, 'details', arguments: {
                    'movie_details': movies[index],
                  }),
                  child: MovieCard(movie: movies[index]),
                );
              },
            ),
    );
  }
}
