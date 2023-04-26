import 'package:flutter/material.dart';
import 'package:peliculas_app/constants/routes_names.dart';
import 'package:peliculas_app/data/movie_impl.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/screens/screens.dart';
import 'package:provider/provider.dart';

void main() => runApp(const AppState());

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MoviesProvider>(
          lazy: false,
          create: (_) => MoviesProvider(
            moviesRepository: MovieImpl(),
          ),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'About movies',
      home: const HomeScreen(),
      initialRoute: RoutesNames.home,
      routes: {
        RoutesNames.home: (_) => const HomeScreen(),
        RoutesNames.details: (_) => const DetailsScreen(),
      },
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(color: Colors.indigo),
        textTheme: const TextTheme(
          headline3: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
          ),
          headline4: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
