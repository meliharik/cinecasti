import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:movie_suggestion/data/genres.dart';
import 'package:movie_suggestion/helper/height_width.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/members.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/model/movie_provider.dart';
import 'package:movie_suggestion/screens/details/person_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetail extends ConsumerStatefulWidget {
  final int id;

  const MovieDetail({required this.id, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MovieDetailState();
}

class _MovieDetailState extends ConsumerState<MovieDetail> {
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
    controller.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getMovieById(widget.id, context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Movie movie = snapshot.data as Movie;
          return getMovieDetail(movie);
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

  Widget getMovieDetail(Movie movie) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          controller: controller,
          slivers: [
            getAppBar(movie),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  card1(movie),
                  card2(movie),
                  card3(movie),
                  card4(movie),
                  card5(movie),
                  card6(movie),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAppBar(Movie movie) {
    return SliverAppBar(
      centerTitle: true,
      title: isTitleCentered
          ? Text(
              movie.title.toString(),
              overflow: TextOverflow.clip,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          : const SizedBox(),
      pinned: true,
      automaticallyImplyLeading: false,
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
                    movie.title.toString(),
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
                    movie.tagline.toString(),
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
                  movie.posterPath == null
                      ? LinkHelper.posterEmptyLink
                      : 'https://image.tmdb.org/t/p/original/${movie.posterPath}',
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

  Widget card1(Movie movie) {
    String formattedDate =
        DateFormat.yMMMd().format(DateTime.parse(movie.releaseDate.toString()));
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  movie.runtime.toString() + ' min',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                movie.adult == true
                    ? const Text(
                        '18+ ',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      )
                    : const Text(
                        'PG  ',
                        style: TextStyle(
                          fontSize: 15,
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
              movie.overview!.isNotEmpty
                  ? (movie.overview.toString() + movie.id.toString())
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
            getGenres(movie),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget card2(Movie movie) {
    return FutureBuilder(
      future: ApiService.getMovieVideoId(movie, context),
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

  Widget card3(Movie movie) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'cast'.tr().toString(),
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
              future: ApiService.getMovieCastMembers(movie, context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Cast> cast = snapshot.data as List<Cast>;
                  if (cast.isEmpty) {
                    return  Text('no_cast'.tr().toString());
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

  Widget card4(Movie movie) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'crew'.tr().toString(),
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
              future: ApiService.getMovieCrewMembers(movie, context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Crew> crew = snapshot.data as List<Crew>;

                  if (crew.isEmpty) {
                    return  Text('no_crew'.tr().toString());
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

  Widget card5(Movie movie) {
    //similar movies
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'similar_movies'.tr().toString(),
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
              future: ApiService.getSimilarMovies(movie, context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Movie> movies = snapshot.data as List<Movie>;

                  if (movies.isEmpty) {
                    return  Text('no_similar_movies'.tr().toString());
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
                                    builder: (context) => MovieDetail(
                                        id: movies[index].id!.toInt()),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Image.network(
                                    movies[index].posterPath != null
                                        ? 'https://image.tmdb.org/t/p/w500' +
                                            movies[index].posterPath.toString()
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
                                    movies[index].title!.length > 18
                                        ? movies[index]
                                                .title!
                                                .substring(0, 18) +
                                            '...'
                                        : movies[index].title.toString(),
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
                                        movies[index]
                                                .releaseDate!
                                                .substring(0, 4) +
                                            '   -',
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
                                                  text: movies[index]
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

  Widget card6(Movie movie) {
    //see on
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              'see_on'.tr().toString(),
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
              future: ApiService.getMovieProviders(movie, context),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<MovieAndTvSerieProvider> providers =
                      snapshot.data as List<MovieAndTvSerieProvider>;

                  if (providers.isEmpty) {
                    return Column(
                      children: [
                        ListTile(
                          trailing: const Icon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.white54,
                          ),
                          onTap: () async {
                            await launchUrl(Uri.parse(
                                'https://www.imdb.com/title/${movie.imdbId}/'));
                          },
                          title:  Text(
                            'imdb'.tr().toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Image.asset(
                            'assets/icons/imdb_icon.png',
                            width: MediaQuery.of(context).size.width * 0.1,
                          ),
                        ),
                        ListTile(
                          trailing: const Icon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.white54,
                          ),
                          onTap: () async {
                            String editedText = movie.title!
                                .replaceAll(RegExp(r'[^\w\s]+'), '');
                            String editedText2 =
                                editedText.replaceAll(' ', '_');
                            await launchUrl(Uri.parse(
                                'https://www.rottentomatoes.com/m/$editedText2/'));
                          },
                          title:  Text(
                            'rotten_tomatoes'.tr().toString(),
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
                        ListTile(
                          trailing: const Icon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.white54,
                          ),
                          onTap: () async {
                            String editedText = movie.title!
                                .replaceAll(RegExp(r'[^\w\s]+'), '');
                            String editedText2 =
                                editedText.replaceAll(' ', '+');
                            await launchUrl(Uri.parse(
                                'https://www.google.com/search?q=$editedText2'));
                          },
                          title:  Text(
                            'google'.tr().toString(),
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
                      ],
                    );
                  }

                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: providers.length + 3,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return ListTile(
                          trailing: const Icon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.white54,
                          ),
                          onTap: () async {
                            await launchUrl(Uri.parse(
                                'https://www.imdb.com/title/${movie.imdbId}/'));
                          },
                          title:  Text(
                            'imdb'.tr().toString(),
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          leading: Image.asset(
                            'assets/icons/imdb_icon.png',
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
                            String editedText = movie.title!
                                .replaceAll(RegExp(r'[^\w\s]+'), '');
                            String editedText2 =
                                editedText.replaceAll(' ', '_');
                            await launchUrl(Uri.parse(
                                'https://www.rottentomatoes.com/m/$editedText2/'));
                          },
                          title:  Text(
                            'rotten_tomatoes'.tr().toString(),
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
                      } else if (index == 2) {
                        return ListTile(
                          trailing: const Icon(
                            FontAwesomeIcons.angleRight,
                            color: Colors.white54,
                          ),
                          onTap: () async {
                            String editedText = movie.title!
                                .replaceAll(RegExp(r'[^\w\s]+'), '');
                            String editedText2 =
                                editedText.replaceAll(' ', '+');
                            await launchUrl(Uri.parse(
                                'https://www.google.com/search?q=$editedText2'));
                          },
                          title:  Text(
                            'google'.tr().toString(),
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
                      return getListTile(providers, index - 3, movie);
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
      List<MovieAndTvSerieProvider> providers, int index, Movie movie) {
    if (providers[index].providerName == 'YouTube') {
      return ListTile(
        trailing: const Icon(
          FontAwesomeIcons.angleRight,
          color: Colors.white54,
        ),
        onTap: () async {
          String editedText = movie.title!.replaceAll(RegExp(r'[^\w\s]+'), '');
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
          String editedText = movie.title!.replaceAll(RegExp(r'[^\w\s]+'), '');
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
          String editedText = movie.title!.replaceAll(RegExp(r'[^\w\s]+'), '');
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
          String editedText = movie.title!.replaceAll(RegExp(r'[^\w\s]+'), '');
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

  Widget getGenres(Movie movie) {
    List<Widget> genres = [];

    if (movie.genres!.isEmpty) {
      return const SizedBox();
    }

    Widget genre1 = Row(
      children: [
        Icon(
            GetGenre.getGenreAndIcon(movie.genres![0].id!.toInt(), context)[1]),
        boslukWidth(context, 0.03),
        Text(
          GetGenre.getGenreAndIcon(movie.genres![0].id!.toInt(), context)[0],
          style: const TextStyle(
            fontSize: 15,
          ),
        ),
      ],
    );
    Widget genre2 = Row();
    if (movie.genres!.length > 1) {
      genre2 = Row(
        children: [
          Icon(GetGenre.getGenreAndIcon(
              movie.genres![1].id!.toInt(), context)[1]),
          boslukWidth(context, 0.03),
          Text(
            GetGenre.getGenreAndIcon(movie.genres![1].id!.toInt(), context)[0],
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
        ],
      );
    }
    genres.add(genre1);
    if (movie.genres!.length > 1) genres.add(genre2);
    // genres.add(genre3);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: genres,
    );
  }
}
