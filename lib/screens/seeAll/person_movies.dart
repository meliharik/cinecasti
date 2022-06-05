import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/screens/details/movie_detail.dart';

class PersonAllMovies extends ConsumerStatefulWidget {
  final String personName;
  final List<Movie> movies;
  const PersonAllMovies(
      {required this.personName, required this.movies, Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonAllMovieState();
}

class _PersonAllMovieState extends ConsumerState<PersonAllMovies> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.personName),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.angleLeft,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GridView.count(
        childAspectRatio: 0.69,
        crossAxisCount: 3,
        children: [
          for (var i = 0; i < widget.movies.length; i++)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetail(
                      id: widget.movies[i].id!.toInt(),
                    ),
                  ),
                );
              },
              child: Image.network(
                widget.movies[i].posterPath == null
                    ? LinkHelper.posterEmptyLink
                    : 'https://image.tmdb.org/t/p/w500/${widget.movies[i].posterPath}',
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
