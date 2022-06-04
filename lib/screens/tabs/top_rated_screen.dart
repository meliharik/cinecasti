import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_suggestion/data/all_providers.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/top_rated_movies.dart';
import 'package:movie_suggestion/screens/movie_detail.dart';
import 'package:movie_suggestion/service/movie_service.dart';

class TopRatedScreen extends ConsumerStatefulWidget {
  const TopRatedScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TopRatedScreenState();
}

class _TopRatedScreenState extends ConsumerState<TopRatedScreen> {
  late Future<List<dynamic>> topRatedMovies;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(topRatedMoviesPageControllerIndexProvider.state).state = 1;
    topRatedMovies = ApiService.getTopRatedMovies(1);
    controller.addListener(() {
      // listen to scroll events
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        // load more data
        debugPrint('max scroll');
        ref.read(topRatedMoviesPageControllerIndexProvider.state).state++;
        topRatedMovies = ApiService.getTopRatedMovies(
            ref.watch(topRatedMoviesPageControllerIndexProvider));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: topRatedMovies,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<TopRatedMovie> topRatedMovies =
              snapshot.data as List<TopRatedMovie>;
//https://image.tmdb.org/t/p/original/${movie.posterPath}
          return GridView.count(
            controller: controller,
            childAspectRatio: 0.69,
            crossAxisCount: 3,
            children: [
              for (var i = 0; i < topRatedMovies.length; i++)
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetail(
                          id: topRatedMovies[i].id!.toInt(),
                        ),
                      ),
                    );
                  },
                  child: Image.network(
                    topRatedMovies[i].posterPath == null
                        ? LinkHelper.posterEmptyLink
                        : 'https://image.tmdb.org/t/p/w500/${topRatedMovies[i].posterPath}',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) =>
                        loadingProgress == null
                            ? child
                            : Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                              .toInt()
                                      : null,
                                ),
                              ),
                  ),
                ),
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
}
