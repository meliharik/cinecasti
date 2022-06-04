import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_suggestion/data/all_providers.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/popular_movies.dart';
import 'package:movie_suggestion/screens/movie_detail.dart';
import 'package:movie_suggestion/service/movie_service.dart';

class PopularScreen extends ConsumerStatefulWidget {
  const PopularScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PopularScreenState();
}

class _PopularScreenState extends ConsumerState<PopularScreen> {
  late Future<List<dynamic>> popularMovies;
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    ref.read(popularMoviesPageControllerIndexProvider.state).state = 1;
    popularMovies = ApiService.getPopularMovies(1);
    controller.addListener(() {
      // listen to scroll events
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        // load more data
        debugPrint('max scroll');
        ref.read(popularMoviesPageControllerIndexProvider.state).state++;
        popularMovies = ApiService.getPopularMovies(
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
                    popularMovies[i].posterPath == null
                        ? LinkHelper.posterEmptyLink
                        : 'https://image.tmdb.org/t/p/w500/${popularMovies[i].posterPath}',
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
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
