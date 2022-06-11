import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/model/tv_serie.dart';
import 'package:movie_suggestion/screens/details/movie_detail.dart';
import 'package:movie_suggestion/screens/details/tv_serie_detail.dart';
import 'package:movie_suggestion/service/firestore_service.dart';

class WatchListScreen extends ConsumerStatefulWidget {
  const WatchListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _WatchListScreenState();
}

class _WatchListScreenState extends ConsumerState<WatchListScreen> 
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  
  @override
  Widget build(BuildContext context) {
    final tab = TabBar(
      tabs: <Tab>[
        Tab(
          text: 'movies'.tr().toString(),
        ),
        Tab(
          text: 'tv_series'.tr().toString(),
        ),
      ],
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.angleLeft),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'watch_list'.tr().toString(),
          ),
          bottom: tab,
        ),
        body: TabBarView(
          children: [
            getMovies,
            getTvSeries,
          ],
        ),
      ),
    );
  }

  Widget get getMovies => FutureBuilder<List<Movie>>(
        future: FirestoreService().getWatchListMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Movie> movies = snapshot.data as List<Movie>;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                Movie movie = movies[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => MovieDetail(
                                id: movie.id!.toInt(),
                              )),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Stack(children: [
                          Image.network(
                            movie.backdropPath == null
                                ? LinkHelper.episodeEmptyLink
                                : 'https://image.tmdb.org/t/p/w500/${movie.backdropPath}',
                            width: MediaQuery.of(context).size.width * 0.4,
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Center(
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
                                      ),
                            fit: BoxFit.cover,
                          ),
                          Container(
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
                          )
                        ]),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${movie.title}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${movie.releaseDate}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            debugPrint('error');
            debugPrint(snapshot.error.toString());
            return const Text('error');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

  Widget get getTvSeries => FutureBuilder<List<TvSerie>>(
        future: FirestoreService().getWatchListTvSeries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TvSerie> tvSeries = snapshot.data as List<TvSerie>;
            return ListView.builder(
              itemCount: tvSeries.length,
              itemBuilder: (context, index) {
                TvSerie tvSerie = tvSeries[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => TvSerieDetail(
                                id: tvSerie.id!.toInt(),
                              )),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Stack(children: [
                          Image.network(
                            tvSerie.backdropPath == null
                                ? LinkHelper.episodeEmptyLink
                                : 'https://image.tmdb.org/t/p/w500/${tvSerie.backdropPath}',
                            width: MediaQuery.of(context).size.width * 0.4,
                            loadingBuilder: (context, child, loadingProgress) =>
                                loadingProgress == null
                                    ? child
                                    : SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        child: Center(
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
                                      ),
                            fit: BoxFit.cover,
                          ),
                          Container(
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
                                  tvSerie.voteAverage.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${tvSerie.name}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${tvSerie.firstAirDate}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            debugPrint('error');
            debugPrint(snapshot.error.toString());
            return const Text('error');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );
}
