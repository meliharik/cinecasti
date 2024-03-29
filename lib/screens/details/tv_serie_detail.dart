import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:movie_suggestion/data/all_providers.dart';
import 'package:movie_suggestion/data/genres.dart';
import 'package:movie_suggestion/helper/ad_helper.dart';
import 'package:movie_suggestion/helper/height_width.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/members.dart';
import 'package:movie_suggestion/model/movie_provider.dart';
import 'package:movie_suggestion/model/similar_tv_series.dart';
import 'package:movie_suggestion/model/tv_serie.dart';
import 'package:movie_suggestion/screens/details/person_detail.dart';
import 'package:movie_suggestion/screens/details/season_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';
import 'package:movie_suggestion/service/firestore_service.dart';
import 'package:movie_suggestion/widgets/fab_button.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TvSerieDetail extends ConsumerStatefulWidget {
  final int id;
  const TvSerieDetail({required this.id, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TvSerieDetailState();
}

const int maxFailedLoad = 3;

class _TvSerieDetailState extends ConsumerState<TvSerieDetail> {
  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '',
  );

  final controller = ScrollController();
  bool isTitleCentered = false;

  bool isAddedWatchList = false;
  bool isAddedWatchedList = false;
  bool isAddedMyCollection = false;

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
    _createBottomBannerAd();
    _createInterstitialAd();

    isAddedControls();

    controller.addListener(() {
      if (controller.position.pixels >=
          MediaQuery.of(context).size.height / 2) {
        debugPrint('centered');
        if (isTitleCentered == false) {
          setState(() {
            isTitleCentered = true;
          });
        }
        debugPrint('isTitleCentered: $isTitleCentered');
      } else {
        if (isTitleCentered == true) {
          setState(() {
            isTitleCentered = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    _interstitialAd?.dispose();

    _controller.dispose();
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

  isAddedControls() async {
    await FirestoreService().isTvSerieInWatchList(widget.id).then((value) {
      setState(() {
        isAddedWatchList = value;
      });
      debugPrint('isAddedWatchList: $isAddedWatchList');
    });
    await FirestoreService().isTvSerieInWatchedList(widget.id).then((value) {
      setState(() {
        isAddedWatchedList = value;
      });
      debugPrint('isAddedWatchedList: $isAddedWatchedList');
    });
    await FirestoreService().isTvSerieInMyCollection(widget.id).then((value) {
      setState(() {
        isAddedMyCollection = value;
      });
      debugPrint('isAddedMyCollection: $isAddedMyCollection');
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getTvSerieById(widget.id, context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          TvSerie tvSerie = snapshot.data as TvSerie;

          return getTvSerieDetail(tvSerie);
        } else if (snapshot.hasError) {
          debugPrint('error');
          debugPrint(snapshot.error.toString());

          return const Scaffold(
            body: Center(child: Text('Error')),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget getTvSerieDetail(TvSerie tvSerie) {
    return SafeArea(
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
        floatingActionButton: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).size.height / 18),
          child: getFabButton(tvSerie),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: CustomScrollView(
          controller: controller,
          slivers: [
            getAppBar(tvSerie),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  card1(tvSerie),
                  card2(tvSerie),
                  seasonsListTile(tvSerie),
                  card3(tvSerie),
                  card4(tvSerie),
                  card5(tvSerie),
                  card6(tvSerie),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getFabButton(TvSerie tvSerie) {
    return ExpandableFab(
      distance: 150,
      children: [
        FloatingActionButton.extended(
          heroTag: null,
          onPressed: () async {
            isAddedMyCollection
                ? _showAlreadyInList(context, tvSerie)
                : _showAction(context, 2);
            await FirestoreService().myCollectionDiziKaydet(tvSerie);
            setState(() {
              isAddedMyCollection = true;
            });
          },
          label: Text('my_collection'.tr().toString()),
          icon: const Icon(
            FontAwesomeIcons.bookmark,
            color: Colors.redAccent,
          ),
        ),
        FloatingActionButton.extended(
          onPressed: () async {
            isAddedWatchedList
                ? _showAlreadyInList(context, tvSerie)
                : _showAction(context, 1);
            await FirestoreService().watchedListDiziKaydet(tvSerie);
            setState(() {
              isAddedWatchedList = true;
            });
          },
          label: Text('watched_list'.tr().toString()),
          icon: const Icon(
            FontAwesomeIcons.check,
            color: Colors.greenAccent,
          ),
        ),
        FloatingActionButton.extended(
          onPressed: () async {
            isAddedWatchList
                ? _showAlreadyInList(context, tvSerie)
                : _showAction(context, 0);
            await FirestoreService().watchListDiziKaydet(tvSerie);
            setState(() {
              isAddedWatchList = true;
            });
          },
          label: Text('watch_list'.tr().toString()),
          icon: const Icon(
            FontAwesomeIcons.list,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  void _showAction(BuildContext context, int index) {
    List<String> _actionTitles = [
      'watch_list'.tr().toString(),
      'watched_list'.tr().toString(),
      'my_collection'.tr().toString()
    ];

    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            'tv_serie_added_to'.tr().toString() + ': ' + _actionTitles[index],
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ok'.tr().toString(),
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _showAlreadyInList(BuildContext context, TvSerie tvSerie) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(
            tvSerie.name! + ' ' + 'already_in_list'.tr().toString(),
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'ok'.tr().toString(),
                style: TextStyle(
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget getAppBar(TvSerie tvSerie) {
    return SliverAppBar(
      centerTitle: true,
      title: isTitleCentered
          ? Text(
              tvSerie.name.toString(),
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : const SizedBox(),
      automaticallyImplyLeading: false,
      pinned: true,
      leading: IconButton(
        icon: const Icon(
          FontAwesomeIcons.angleLeft,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: const Icon(FontAwesomeIcons.shareNodes),
          onPressed: () {
            Share.share(
              'download_app'.tr().toString() +
                  '\nhttps://play.google.com/store/apps/details?id=com.cinecasti.mobile',
              subject: 'look_what_I_found'.tr().toString(),
            );
          },
        ),
      ],
      expandedHeight: MediaQuery.of(context).size.height * 0.65,
      flexibleSpace: FlexibleSpaceBar(
        title: isTitleCentered
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tvSerie.name.toString(),
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    tvSerie.tagline.toString(),
                    overflow: TextOverflow.clip,
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
        titlePadding: const EdgeInsets.all(16),
        background: Stack(
          children: [
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  tvSerie.posterPath == null
                      ? LinkHelper.posterEmptyLink
                      : 'https://image.tmdb.org/t/p/original/${tvSerie.posterPath}',
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
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                // borderRadius: const BorderRadius.all(
                //   Radius.circular(15),
                // ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor,
                    Colors.black.withOpacity(0.0)
                  ],
                  stops: const [
                    0.0,
                    0.5,
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget card1(TvSerie tvSerie) {
    String formattedDate = DateFormat.yMMMd()
        .format(DateTime.parse(tvSerie.lastAirDate.toString()));
    // DateTime parsedDate = DateTime.parse(tvSerie.lastAirDate.toString());
    // DateTime now = DateTime.now();
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$formattedDate (${tvSerie.status})',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tvSerie.episodeRunTime![0].toString() + ' min',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                tvSerie.adult == true
                    ? const Text(
                        '18+     ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                    : const Text(
                        'TV-MA     ',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              tvSerie.overview!.isNotEmpty
                  ? (tvSerie.overview.toString())
                  : 'no_overview'.tr().toString(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            getGenres(tvSerie),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget card2(TvSerie tvSerie) {
    return FutureBuilder(
      future: ApiService.getTvSerieVideoId(tvSerie, context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          String videoId = snapshot.data as String;
          if (videoId.isEmpty) {
            return const SizedBox();
          }

          _controller = YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(
              enableCaption: true,
              showLiveFullscreenButton: false,
              autoPlay: false,
              disableDragSeek: true,
              mute: false,
            ),
          );
          return Card(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'trailer'.tr().toString(),
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 8),
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    bottomActions: [
                      CurrentPosition(),
                      const SizedBox(width: 8),
                      ProgressBar(isExpanded: true),
                      const SizedBox(width: 8),
                      RemainingDuration(),
                      const SizedBox(width: 8),
                      // FullScreenButton(),
                    ],
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.red,
                      handleColor: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          );
        } else if (snapshot.hasError) {
          debugPrint('error');
          debugPrint(snapshot.error.toString());

          return const Text('error');
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Widget seasonsListTile(TvSerie tvSerie) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: ExpansionTile(
          title: Text(
            "seasons".tr().toString() + ' (${tvSerie.seasons!.length})',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            SizedBox(
              height: (tvSerie.seasons!.length * 50) +
                  MediaQuery.of(context).size.height * 0.05,
              child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tvSerie.seasons!.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    height: 50,
                    child: ListTile(
                      title: Text(
                        tvSerie.seasons![index].name.toString(),
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        tvSerie.seasons![index].airDate.toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: const Icon(
                        FontAwesomeIcons.angleRight,
                        size: 15,
                      ),
                      onTap: () {
                        ref.read(showAdIndexProvider.state).state++;
                        if (ref.watch(showAdIndexProvider) % 5 == 0) {
                          _showInterstitialAd();
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => SeasonDetail(
                                  seasonNumber: tvSerie
                                      .seasons![index].seasonNumber!
                                      .toInt(),
                                  tvSerieId: tvSerie.id!.toInt(),
                                  tvSerieName: tvSerie.name.toString(),
                                )),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget card3(TvSerie tvSerie) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'cast'.tr().toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: ApiService.getTvSerieCastMembers(tvSerie, context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Cast> cast = snapshot.data as List<Cast>;

                  if (cast.isEmpty) {
                    return Text('no_cast'.tr().toString());
                  }

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.33,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: cast.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                ref.read(showAdIndexProvider.state).state++;
                                if (ref.watch(showAdIndexProvider) % 5 == 0) {
                                  _showInterstitialAd();
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PersonDetail(
                                        id: cast[index].id!.toInt()),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Image.network(
                                    cast[index].profilePath != null
                                        ? 'https://image.tmdb.org/t/p/w500' +
                                            cast[index].profilePath.toString()
                                        : 'https://www.diabetes.ie/wp-content/uploads/2017/02/no-image-available.png',

                                    loadingBuilder:
                                        (context, child, loadingProgress) =>
                                            loadingProgress == null
                                                ? child
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(
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
                                    height: MediaQuery.of(context).size.height *
                                        0.25,
                                    // width: 100,
                                  ),
                                  Text(
                                    cast[index].name.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    cast[index].character.toString(),
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  debugPrint('error');
                  debugPrint(snapshot.error.toString());

                  return const Text('error');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget card4(TvSerie tvSerie) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'crew'.tr().toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: ApiService.getTvSerieCrewMembers(tvSerie, context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Crew> crew = snapshot.data as List<Crew>;
                  if (crew.isEmpty) {
                    return Text('no_crew'.tr().toString());
                  }

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.33,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: crew.length > 4 ? 4 : crew.length,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            Column(
                              children: [
                                Image.network(
                                  crew[index].profilePath != null
                                      ? 'https://image.tmdb.org/t/p/w500' +
                                          crew[index].profilePath.toString()
                                      : 'https://www.diabetes.ie/wp-content/uploads/2017/02/no-image-available.png',

                                  loadingBuilder: (context, child,
                                          loadingProgress) =>
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
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  // width: 100,
                                ),
                                Text(
                                  crew[index].name.toString(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  crew[index].job.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  debugPrint('error');
                  debugPrint(snapshot.error.toString());

                  return const Text('error');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget card5(TvSerie tvSerie) {
    //similar tv series
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'similar_tv_series'.tr().toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: ApiService.getSimilarTvSeries(tvSerie, context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SimilarTvSeries> tvSeries =
                      snapshot.data as List<SimilarTvSeries>;

                  if (tvSeries.isEmpty) {
                    return Text('no_tv_series'.tr().toString());
                  }

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.41,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                ref.read(showAdIndexProvider.state).state++;
                                if (ref.watch(showAdIndexProvider) % 5 == 0) {
                                  _showInterstitialAd();
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TvSerieDetail(
                                        id: tvSeries[index].id!.toInt()),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Image.network(
                                    tvSeries[index].posterPath != null
                                        ? 'https://image.tmdb.org/t/p/w500' +
                                            tvSeries[index]
                                                .posterPath
                                                .toString()
                                        : 'https://www.diabetes.ie/wp-content/uploads/2017/02/no-image-available.png',

                                    loadingBuilder:
                                        (context, child, loadingProgress) =>
                                            loadingProgress == null
                                                ? child
                                                : Center(
                                                    child:
                                                        CircularProgressIndicator(
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
                                    height: MediaQuery.of(context).size.height *
                                        0.3,
                                    // width: 100,
                                  ),
                                  Text(
                                    tvSeries[index].name!.length > 18
                                        ? tvSeries[index]
                                                .name!
                                                .substring(0, 18) +
                                            '...'
                                        : tvSeries[index].name.toString(),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        tvSerie.numberOfSeasons.toString() +
                                            ' ' +
                                            'seasons'.tr().toString() +
                                            '   - ',
                                        style: const TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            FontAwesomeIcons.imdb,
                                            color: Color(0xfff5c518),
                                          ),
                                          const SizedBox(
                                            width: 3,
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: tvSeries[index]
                                                      .voteAverage!
                                                      .toStringAsFixed(1),
                                                  style: const TextStyle(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const TextSpan(
                                                  text: '/10',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.white70,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                } else if (snapshot.hasError) {
                  debugPrint('error');
                  debugPrint(snapshot.error.toString());

                  return const Text('error');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget card6(TvSerie tvSerie) {
    //see on
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'see_on'.tr().toString(),
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            FutureBuilder(
              future: ApiService.getTvSerieProviders(tvSerie, context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MovieAndTvSerieProvider> providers =
                      snapshot.data as List<MovieAndTvSerieProvider>;
                  List<MovieAndTvSerieProvider> providers2 = [];
                  for (int i = 0; i < providers.length; i++) {
                    if (providers[i].providerName == 'Netflix' ||
                        providers[i].providerName == 'Amazon Prime Video' ||
                        providers[i].providerName == 'Amazon Video' ||
                        providers[i].providerName == 'Google Play Movies' ||
                        providers[i].providerName == 'Disney Plus' ||
                        providers[i].providerName == 'YouTube') {
                      providers2.add(providers[i]);
                    }
                  }

                  if (providers2.isEmpty) {
                    return Column(
                      children: [
                        ListTile(
                          trailing: const Icon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.white54,
                          ),
                          onTap: () async {
                            String editedText = tvSerie.name!
                                .replaceAll(RegExp(r'[^\w\s]+'), '');
                            String editedText2 =
                                editedText.replaceAll(' ', '+');
                            await launchUrl(Uri.parse(
                                'https://www.google.com/search?q=$editedText2'));
                          },
                          title: Text(
                            'google'.tr().toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Image.asset(
                            'assets/icons/google_icon.png',
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                        ListTile(
                          trailing: const Icon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.white54,
                          ),
                          onTap: () async {
                            String editedText = tvSerie.name!
                                .replaceAll(RegExp(r'[^\w\s]+'), '');
                            String editedText2 =
                                editedText.replaceAll(' ', '_');
                            await launchUrl(Uri.parse(
                                'https://www.rottentomatoes.com/m/$editedText2/'));
                          },
                          title: Text(
                            'rotten_tomatoes'.tr().toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Image.asset(
                            'assets/icons/tomato_icon.png',
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: providers2.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          trailing: const Icon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.white54,
                          ),
                          onTap: () async {
                            String editedText = tvSerie.name!
                                .replaceAll(RegExp(r'[^\w\s]+'), '');
                            String editedText2 =
                                editedText.replaceAll(' ', '_');
                            await launchUrl(Uri.parse(
                                'https://www.rottentomatoes.com/m/$editedText2/'));
                          },
                          title: Text(
                            'rotten_tomatoes'.tr().toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Image.asset(
                            'assets/icons/tomato_icon.png',
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        );
                      } else if (index == 1) {
                        return ListTile(
                          trailing: const Icon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.white54,
                          ),
                          onTap: () async {
                            String editedText = tvSerie.name!
                                .replaceAll(RegExp(r'[^\w\s]+'), '');
                            String editedText2 =
                                editedText.replaceAll(' ', '+');
                            await launchUrl(Uri.parse(
                                'https://www.google.com/search?q=$editedText2'));
                          },
                          title: Text(
                            'google'.tr().toString(),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Image.asset(
                            'assets/icons/google_icon.png',
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        );
                      }
                      // return Text(index.toString());
                      return getListTile(providers2, index - 2, tvSerie);
                    },
                  );
                } else if (snapshot.hasError) {
                  debugPrint('error');
                  debugPrint(snapshot.error.toString());

                  return Text('no_providers'.tr().toString());
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget getListTile(
      List<MovieAndTvSerieProvider> providers, int index, TvSerie tvSerie) {
    if (providers[index].providerName == 'YouTube') {
      return ListTile(
        trailing: const Icon(
          FontAwesomeIcons.angleRight,
          color: Colors.white54,
        ),
        onTap: () async {
          String editedText = tvSerie.name!.replaceAll(RegExp(r'[^\w\s]+'), '');
          String editedText2 = editedText.replaceAll(' ', '+');
          await launchUrl(Uri.parse(
              'https://www.youtube.com/results?search_query=$editedText2'));
        },
        title: Text(
          'youtube'.tr().toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Image.asset(
          'assets/icons/youtube_icon.png',
          width: MediaQuery.of(context).size.width * 0.1,
        ),
      );
    } else if (providers[index].providerName == 'Amazon Prime Video' ||
        providers[index].providerName == 'Amazon Video') {
      return ListTile(
        trailing: const Icon(
          FontAwesomeIcons.angleRight,
          color: Colors.white54,
        ),
        onTap: () async {
          String editedText = tvSerie.name!.replaceAll(RegExp(r'[^\w\s]+'), '');
          String editedText2 = editedText.replaceAll(' ', '+');
          await launchUrl(Uri.parse(
              'https://www.google.com/search?q=Amazon+Video+$editedText2'));
        },
        title: Text(
          'amazon_video'.tr().toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Image.asset(
          'assets/icons/amazon_icon.png',
          width: MediaQuery.of(context).size.width * 0.1,
        ),
      );
    } else if (providers[index].providerName == 'Netflix') {
      return ListTile(
        trailing: const Icon(
          FontAwesomeIcons.angleRight,
          color: Colors.white54,
        ),
        onTap: () async {
          String editedText = tvSerie.name!.replaceAll(RegExp(r'[^\w\s]+'), '');
          String editedText2 = editedText.replaceAll(' ', '+');
          await launchUrl(Uri.parse(
              'https://www.google.com/search?q=Netflix+$editedText2'));
        },
        title: Text(
          'netflix'.tr().toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Image.asset(
          'assets/icons/netflix_icon.png',
          width: MediaQuery.of(context).size.width * 0.1,
        ),
      );
    } else if (providers[index].providerName == 'Disney Plus') {
      return ListTile(
        trailing: const Icon(
          FontAwesomeIcons.angleRight,
          color: Colors.white54,
        ),
        onTap: () {},
        title: Text(
          'disney_plus'.tr().toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Image.asset(
          'assets/icons/disney_icon.png',
          width: MediaQuery.of(context).size.width * 0.1,
        ),
      );
    } else if (providers[index].providerName == 'Google Play Movies') {
      return ListTile(
        trailing: const Icon(
          FontAwesomeIcons.angleRight,
          color: Colors.white54,
        ),
        onTap: () async {
          String editedText = tvSerie.name!.replaceAll(RegExp(r'[^\w\s]+'), '');
          String editedText2 = editedText.replaceAll(' ', '%20');
          await launchUrl(Uri.parse(
              'https://play.google.com/store/search?q=$editedText2&c=movies'));
        },
        title: Text(
          'google_play_movies'.tr().toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Image.asset(
          'assets/icons/google_play_icon.png',
          width: MediaQuery.of(context).size.width * 0.1,
        ),
      );
    } else {
      return ListTile(
        trailing: const Icon(
          FontAwesomeIcons.angleRight,
          color: Colors.white54,
        ),
        onTap: () {},
        title: Text(
          providers[index].providerName.toString(),
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
  }

  Widget getGenres(TvSerie tvSerie) {
    List<Widget> genres = [];

    if (tvSerie.genres!.isEmpty) {
      return const SizedBox();
    }

    Widget genre1 = Row(
      children: [
        Icon(GetGenre.getGenreAndIcon(
            tvSerie.genres![0].id!.toInt(), context)[1]),
        boslukWidth(context, 0.03),
        Text(
          GetGenre.getGenreAndIcon(tvSerie.genres![0].id!.toInt(), context)[0],
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
    Widget genre2 = Row();
    if (tvSerie.genres!.length > 1) {
      genre2 = Row(
        children: [
          Icon(GetGenre.getGenreAndIcon(
              tvSerie.genres![1].id!.toInt(), context)[1]),
          boslukWidth(context, 0.03),
          Text(
            GetGenre.getGenreAndIcon(
                tvSerie.genres![1].id!.toInt(), context)[0],
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      );
    }
    genres.add(genre1);
    if (tvSerie.genres!.length > 1) genres.add(genre2);
    // genres.add(genre3);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: genres,
    );
  }
}
