import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movie_suggestion/data/genres.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/members.dart';
import 'package:movie_suggestion/model/movie_provider.dart';
import 'package:movie_suggestion/model/similar_tv_series.dart';
import 'package:movie_suggestion/model/tv_serie.dart';
import 'package:movie_suggestion/screens/details/person_detail.dart';
import 'package:movie_suggestion/screens/details/season_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TvSerieDetail extends ConsumerStatefulWidget {
  final int id;
  const TvSerieDetail({required this.id, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TvSerieDetailState();
}

class _TvSerieDetailState extends ConsumerState<TvSerieDetail> {
  late YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: '',
  );

  final controller = ScrollController();
  bool isTitleCentered = false;

  @override
  void initState() {
    super.initState();
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getTvSerieById(widget.id),
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
          onPressed: () {},
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
            //TODO: buradaki idyi kaldır
            Text(
              tvSerie.overview!.isNotEmpty
                  ? (tvSerie.overview.toString() + tvSerie.id.toString())
                  : 'No overview',
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
      future: ApiService.getTvSerieVideoId(tvSerie),
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
                  const Text(
                    'Trailer',
                    style: TextStyle(
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
            'Seasons (${tvSerie.seasons!.length})',
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
            const Text(
              'Cast',
              style: TextStyle(
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
              future: ApiService.getTvSerieCastMembers(tvSerie),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Cast> cast = snapshot.data as List<Cast>;

                  if (cast.isEmpty) {
                    return const Text('No Cast Members Found');
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
            const Text(
              'Crew',
              style: TextStyle(
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
              future: ApiService.getTvSerieCrewMembers(tvSerie),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Crew> crew = snapshot.data as List<Crew>;
                  if (crew.isEmpty) {
                    return const Text('No Crew Members Found');
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
            const Text(
              'Similar Tv Series',
              style: TextStyle(
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
              future: ApiService.getSimilarTvSeries(tvSerie),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SimilarTvSeries> tvSeries =
                      snapshot.data as List<SimilarTvSeries>;

                  if (tvSeries.isEmpty) {
                    return const Text('No Similar Tv Series Found');
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
                                            ' Seasons   - ',
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
            const Text(
              'See On',
              style: TextStyle(
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
              future: ApiService.getTvSerieProviders(tvSerie),
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
                          title: const Text(
                            'Google',
                            style: TextStyle(
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
                          title: const Text(
                            'Rotten Tomatoes',
                            style: TextStyle(
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
                          title: const Text(
                            'Rotten Tomatoes',
                            style: TextStyle(
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
                          title: const Text(
                            'Google',
                            style: TextStyle(
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

                  return const Text('No Providers');
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
          providers[index].providerName.toString(),
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
          providers[index].providerName.toString(),
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
          providers[index].providerName.toString(),
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
          providers[index].providerName.toString(),
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
          providers[index].providerName.toString(),
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
        Icon(GetGenre.getGenreAndIcon(tvSerie.genres![0].id!.toInt())[1]),
        Text(
          GetGenre.getGenreAndIcon(tvSerie.genres![0].id!.toInt())[0],
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
          Icon(GetGenre.getGenreAndIcon(tvSerie.genres![1].id!.toInt())[1]),
          Text(
            GetGenre.getGenreAndIcon(tvSerie.genres![1].id!.toInt())[0],
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
