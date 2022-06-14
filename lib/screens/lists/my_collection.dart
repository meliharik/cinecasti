import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_suggestion/data/all_providers.dart';
import 'package:movie_suggestion/helper/ad_helper.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/model/tv_serie.dart';
import 'package:movie_suggestion/screens/details/movie_detail.dart';
import 'package:movie_suggestion/screens/details/tv_serie_detail.dart';
import 'package:movie_suggestion/service/firestore_service.dart';

class MyCollectionScreen extends ConsumerStatefulWidget {
  const MyCollectionScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _MyCollectionScreenState();
}

const int maxFailedLoad = 3;

class _MyCollectionScreenState extends ConsumerState<MyCollectionScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  InterstitialAd? _interstitialAd;
  int _loadAttempt = 0;

  _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.getBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("error");
          debugPrint(error.toString());
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    _createInterstitialAd();

    _createBottomBannerAd();
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    _interstitialAd?.dispose();

    super.dispose();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdHelper.getPageUnitId,
      request: const AdRequest(),
      adLoadCallback:
          InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
        _interstitialAd = ad;
        _loadAttempt = 0;
      }, onAdFailedToLoad: (LoadAdError error) {
        _loadAttempt++;
        _interstitialAd = null;
        debugPrint("error");
        debugPrint(error.toString());
        if (_loadAttempt >= maxFailedLoad) {
          _createInterstitialAd();
        }
      }),
    );
  }

  void _showInterstitialAd() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (InterstitialAd ad) {
          ad.dispose();
          _createInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
          ad.dispose();
          _createInterstitialAd();
        },
      );
      _interstitialAd!.show();
    }
  }

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
        bottomNavigationBar: _isBottomBannerAdLoaded
            ? Container(
                height: _bottomBannerAd.size.height.toDouble(),
                width: _bottomBannerAd.size.width.toDouble(),
                child: AdWidget(
                  ad: _bottomBannerAd,
                ),
              )
            : null,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.angleLeft),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'my_collection'.tr().toString(),
          ),
          bottom: tab,
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            getMovies,
            getTvSeries,
          ],
        ),
      ),
    );
  }

  Widget get getMovies => FutureBuilder<List<Movie>>(
        future: FirestoreService().getMyCollectionMovies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Movie> movies = snapshot.data as List<Movie>;
            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                Movie movie = movies[index];
                return Dismissible(
                  key: Key(movie.id.toString()),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.delete, color: Colors.white),
                          Text('remove_from_list'.tr().toString(),
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    setState(() {
                      movies.removeAt(index);
                    });

                    FirestoreService().myCollectionFilmSil(movie);
                    // Then show a snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${movie.title} ' +
                          'removed_from_list'.tr().toString()),
                      action: SnackBarAction(
                        onPressed: () {
                          FirestoreService().myCollectionFilmKaydet(movie);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${movie.title} ' +
                                'added_to_list'.tr().toString()),
                          ));
                          setState(() {});
                        },
                        label: 'undo'.tr().toString().toUpperCase(),
                      ),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: InkWell(
                      onTap: () {
                        ref.read(showAdIndexProvider.state).state++;
                        if (ref.watch(showAdIndexProvider) % 5 == 0) {
                          _showInterstitialAd();
                        }
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
                              loadingBuilder: (context, child,
                                      loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
        future: FirestoreService().getMyCollectionTvSeries(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<TvSerie> tvSeries = snapshot.data as List<TvSerie>;
            return ListView.builder(
              itemCount: tvSeries.length,
              itemBuilder: (context, index) {
                TvSerie tvSerie = tvSeries[index];
                return Dismissible(
                  key: Key(tvSerie.id.toString()),
                  background: Container(color: Colors.red),
                  direction: DismissDirection.endToStart,
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.delete, color: Colors.white),
                          Text('remove_from_list'.tr().toString(),
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                  onDismissed: (direction) {
                    // Remove the item from the data source.
                    setState(() {
                      tvSeries.removeAt(index);
                    });

                    FirestoreService().myCollectionDiziSil(tvSerie);
                    // Then show a snackbar.
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('${tvSerie.name} ' +
                          'removed_from_list'.tr().toString()),
                      action: SnackBarAction(
                        onPressed: () {
                          FirestoreService().myCollectionDiziKaydet(tvSerie);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('${tvSerie.name} ' +
                                'added_to_list'.tr().toString()),
                          ));
                          setState(() {});
                        },
                        label: 'undo'.tr().toString().toUpperCase(),
                      ),
                    ));
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: InkWell(
                      onTap: () {
                        ref.read(showAdIndexProvider.state).state++;
                        if (ref.watch(showAdIndexProvider) % 5 == 0) {
                          _showInterstitialAd();
                        }
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
                              loadingBuilder: (context, child,
                                      loadingProgress) =>
                                  loadingProgress == null
                                      ? child
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
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
