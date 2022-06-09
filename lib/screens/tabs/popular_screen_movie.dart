import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/screens/details/movie_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';

class PopularScreenMovie extends ConsumerStatefulWidget {
  const PopularScreenMovie({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PopularScreenState();
}

class _PopularScreenState extends ConsumerState<PopularScreenMovie>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<dynamic>> popularMoviesFuture;
  List<Movie> popularMovies = [];
  final controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        debugPrint('max scroll');
        setState(() {
          page++;
        });
        debugPrint('page: $page');
        popularMoviesFuture = ApiService.getPopularMovies(page, context);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    popularMoviesFuture = ApiService.getPopularMovies(page, context);

    return FutureBuilder(
      future: popularMoviesFuture,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data.length; i++) {
            popularMovies.add(snapshot.data[i]);
          }

          List<Movie> popularMoviesNew = popularMovies.toSet().toList();
          debugPrint('snapshot.data.length: ${snapshot.data.length}');
          debugPrint('poopularMovies.length: ${popularMovies.length}');
          debugPrint('popularMoviesNew.length: ${popularMoviesNew.length}');
          return GridView.count(
            controller: controller,
            childAspectRatio: 0.69,
            crossAxisCount: 3,
            children: [
              for (var i = 0; i < popularMoviesNew.length + 1; i++)
                loadMovie(popularMoviesNew, i)
            ],
          );
        } else if (snapshot.hasError) {
          debugPrint('error');
          debugPrint(snapshot.error.toString());
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget loadMovie(List<Movie> movies, int index) {
    if (index == movies.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MovieDetail(
                id: movies[index].id!.toInt(),
              ),
            ),
          );
        },
        child: Image.network(
          movies[index].posterPath == null
              ? LinkHelper.posterEmptyLink
              : 'https://image.tmdb.org/t/p/w500/${movies[index].posterPath}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null
                  ? child
                  : Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!.toInt()
                            : null,
                      ),
                    ),
        ),
      );
    }
  }
}
