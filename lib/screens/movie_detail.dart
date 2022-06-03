import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_suggestion/model/movie.dart';

class MovieDetail extends ConsumerStatefulWidget {
  final int id;

  const MovieDetail({required this.id, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MovieDetailState();
}

class _MovieDetailState extends ConsumerState<MovieDetail> {
  Future getMovieById() async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.id}?api_key=cb7c804a5ca858c46d783add66f4de13'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      return Movie.fromJson(document);
    } else {
      Exception('Failed to load movie');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getMovieById(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Movie movie = snapshot.data as Movie;
            return Center(child: Text(movie.id.toString()));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error'));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
