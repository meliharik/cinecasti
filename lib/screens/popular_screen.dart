import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:movie_suggestion/data/all_providers.dart';
import 'package:movie_suggestion/model/popular_movies.dart';
import 'package:movie_suggestion/screens/movie_detail.dart';

class PopularScreen extends ConsumerStatefulWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PopularScreenState();
}

class _PopularScreenState extends ConsumerState<PopularScreen> {
  late Future<List<dynamic>> popularMovies;
  final controller = ScrollController();

  Future<List<PopularMovie>> getPopularMovies(int pageNumber) async {
    if (pageNumber == 1) {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&page=$pageNumber'));
      if (response.statusCode == 200) {
        var document = json.decode(response.body);
        List tempList = document['results'];
        List<PopularMovie> popMovies = [];
        for (var i = 0; i < tempList.length; i++) {
          popMovies.add(PopularMovie.fromJson(tempList[i]));
        }
        return popMovies;
      } else {
        Exception('Failed to load popular movies');
        return [];
      }
    } else {
      List<PopularMovie> popMovies = [];

      for (int i = 1; i < pageNumber; i++) {
        final response = await http.get(Uri.parse(
            'https://api.themoviedb.org/3/movie/popular?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&page=$i'));
        if (response.statusCode == 200) {
          var document = json.decode(response.body);
          List tempList = document['results'];
          for (var i = 0; i < tempList.length; i++) {
            popMovies.add(PopularMovie.fromJson(tempList[i]));
          }
        } else {
          Exception('Failed to load popular movies');
          return [];
        }
      }
      return popMovies;
    }
  }

  @override
  void initState() {
    super.initState();
    ref.read(popularMoviesPageControllerIndexProvider.state).state = 1;
    popularMovies = getPopularMovies(1);
    controller.addListener(() {
      // listen to scroll events
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        // load more data
        debugPrint('max scroll');
        ref.read(popularMoviesPageControllerIndexProvider.state).state++;
        popularMovies = getPopularMovies(
            ref.watch(popularMoviesPageControllerIndexProvider));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: popularMovies,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<PopularMovie> popularMovies =
              snapshot.data as List<PopularMovie>;
//https://image.tmdb.org/t/p/original/${movie.posterPath}
          return GridView.count(
            controller: controller,
            childAspectRatio: 0.69,
            crossAxisCount: 3,
            children: [
              for (var i = 0; i < popularMovies.length; i++)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetail(
                          id: popularMovies[i].id!.toInt(),
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500/${popularMovies[i].posterPath}',
                    fit: BoxFit.cover,
                  ),
                ),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
