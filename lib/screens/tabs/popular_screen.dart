import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/popular_movies.dart';
import 'package:movie_suggestion/screens/movie_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';

class PopularScreen extends ConsumerStatefulWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PopularScreenState();
}

class _PopularScreenState extends ConsumerState<PopularScreen> {
  late Future<List<dynamic>> popularMoviesFuture;
  List<PopularMovie> popularMovies = [];
  final controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    popularMoviesFuture = ApiService.getPopularMovies(page);

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        debugPrint('max scroll');
        setState(() {
          page++;
        });
        debugPrint('page: $page');
        popularMoviesFuture = ApiService.getPopularMovies(page);
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
    return FutureBuilder(
      future: popularMoviesFuture,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data.length; i++) {
            popularMovies.add(snapshot.data[i]);
          }

          List<PopularMovie> popularMoviesNew = popularMovies.toSet().toList();
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
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget loadMovie(List<PopularMovie> movies, int index) {
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
        child: Stack(
          children: [
            Image.network(
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
            Text(index.toString() + ' ' + movies[index].id.toString()),
          ],
        ),
      );
    }
  }
}
