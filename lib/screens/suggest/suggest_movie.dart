import 'dart:convert';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/data/genres.dart';
import 'package:movie_suggestion/helper/height_width.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:http/http.dart' as http;
import 'package:movie_suggestion/screens/details/movie_detail.dart';
import 'package:movie_suggestion/screens/suggest/suggsted_movies.dart';

class SuggestMovie extends ConsumerStatefulWidget {
  const SuggestMovie({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SuggestMovieState();
}

class _SuggestMovieState extends ConsumerState<SuggestMovie> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getRandomMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Movie> movies = snapshot.data as List<Movie>;
            return Stack(
              children: [
                Story(
                  fullscreen: true,
                  onFlashForward: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SuggestedMoviesScreen(
                          movies: movies,
                        ),
                      ),
                    );
                  },
                  onFlashBack: Navigator.of(context).pop,
                  momentCount: movies.length,
                  momentDurationGetter: (idx) => const Duration(seconds: 5),
                  momentBuilder: (context, index) {
                    Movie movie = movies[index];
                    return Stack(
                      children: [
                        Image.network(
                          movie.posterPath == null
                              ? LinkHelper.posterEmptyLink
                              : 'https://image.tmdb.org/t/p/original/${movie.posterPath}',
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? child
                                  : Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                                    .toInt()
                                            : null,
                                      ),
                                    ),
                          fit: BoxFit.cover,
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(0.0)
                              ],
                              stops: const [
                                0.0,
                                0.5,
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 25,
                          left: 25,
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(5),
                              ),
                              color: Colors.black45,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.imdb,
                                  color: Color(0xfff5c518),
                                  size: 30,
                                ),
                                const SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  movie.voteAverage.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                movie.title.toString(),
                                style: const TextStyle(
                                  overflow: TextOverflow.clip,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 50,
                                ),
                              ),
                              getGenres(movie),
                              boslukHeight(context, 0.02),
                              boslukHeight(context, 0.05),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
                Positioned(
                  top: 25,
                  right: 25,
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.xmark,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            debugPrint('error');
            debugPrint(snapshot.error.toString());
            return const Center(
              child: Text('error'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List<Movie>> getRandomMovies() async {
    int randomNumber = 0;
    List<Movie> movies = [];

    while (movies.length < 5) {
      randomNumber = Random().nextInt(1000000);
      debugPrint("randomNumber: " + randomNumber.toString());
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/$randomNumber?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US"));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == false ||
            jsonResponse['adult'] == true ||
            jsonResponse['poster_path'] == null) {
          debugPrint(movies.length.toString());

          continue;
        } else {
          Movie movie = Movie.fromJson(jsonResponse);
          movies.add(movie);
          if (movies.length == 5) break;
        }
      }
    }
    return movies;
  }

  Widget getGenres(Movie movie) {
    List<Widget> genres = [];

    if (movie.genres!.isEmpty) {
      return const SizedBox();
    }

    Widget genre1 = Row(
      children: [
        Icon(
            GetGenre.getGenreAndIcon(movie.genres![0].id!.toInt(), context)[1]),
        boslukWidth(context, 0.03),
        Text(
          GetGenre.getGenreAndIcon(movie.genres![0].id!.toInt(), context)[0],
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
    Widget genre2 = Row();
    if (movie.genres!.length > 1) {
      genre2 = Row(
        children: [
          Icon(GetGenre.getGenreAndIcon(
              movie.genres![1].id!.toInt(), context)[1]),
          boslukWidth(context, 0.03),
          Text(
            GetGenre.getGenreAndIcon(movie.genres![1].id!.toInt(), context)[0],
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      );
    }
    genres.add(genre1);
    if (movie.genres!.length > 1) genres.add(genre2);
    // genres.add(genre3);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: genres,
    );
  }
}
