import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/members.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/model/person.dart';
import 'package:movie_suggestion/model/tv_serie.dart';
import 'package:movie_suggestion/screens/movie_detail.dart';
import 'package:movie_suggestion/screens/seeAll/person_movies.dart';
import 'package:movie_suggestion/screens/seeAll/person_tv_series.dart';
import 'package:movie_suggestion/service/movie_service.dart';

class PersonDetail extends ConsumerStatefulWidget {
  final int id;
  const PersonDetail({required this.id, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonDetailState();
}

class _PersonDetailState extends ConsumerState<PersonDetail> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getPersonById(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Person person = snapshot.data as Person;
          return getPersonDetail(person);
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

  Widget getPersonDetail(Person person) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            getAppBar(person),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  card1(person),
                  card2(person),
                  card3(person),
                  // card4(movie),
                  // card5(movie),
                  // card6(movie),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAppBar(Person person) {
    String formattedDate =
        DateFormat.yMMMd().format(DateTime.parse(person.birthday.toString()));
    return SliverAppBar(
      pinned: true,
      collapsedHeight: MediaQuery.of(context).size.height * 0.2,
      leading: IconButton(
        icon: const Icon(
          FontAwesomeIcons.angleLeft,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        // IconButton(
        //   icon: const Icon(FontAwesomeIcons.solidHeart),
        //   onPressed: () {},
        // ),
        IconButton(
          icon: const Icon(FontAwesomeIcons.shareNodes),
          onPressed: () {},
        ),
      ],
      expandedHeight: MediaQuery.of(context).size.height * 0.65,
      flexibleSpace: FlexibleSpaceBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              person.name.toString(),
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
              "Born on " + formattedDate,
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
                  'https://image.tmdb.org/t/p/original/${person.profilePath}',
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

  Widget card1(Person person) {
    DateTime birthday = DateTime.parse(person.birthday.toString());
    DateTime now = DateTime.now();

    int age = now.year - birthday.year;

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
                  '$age years old',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FutureBuilder(
                  future: ApiService.getPersonMovies(person.id!.toInt()),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Movie> movies = snapshot.data as List<Movie>;
                      return Text(
                        '${movies.length} movies',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      debugPrint('error');
                      debugPrint(snapshot.error.toString());

                      return const Text('error');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                FutureBuilder<List<CastTvSeries>>(
                  future: ApiService.getPersonTvSeries(person.id!.toInt()),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      List<CastTvSeries> series =
                          snapshot.data as List<CastTvSeries>;

                      return Text(
                        '${series.length} tv series',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      debugPrint('error');
                      debugPrint(snapshot.error.toString());
                      return const Text('Error');
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Divider(
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            const Text(
              'Biography',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ExpandableText(person.biography.toString()),
            const SizedBox(height: 8),
            // const Divider(
            //   color: Colors.grey,
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   'Birthday',
            //   style: const TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   DateFormat.yMMMd()
            //       .format(DateTime.parse(person.birthday.toString())),
            //   style: const TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // const Divider(
            //   color: Colors.grey,
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   'Place of birth',
            //   style: const TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // Text(
            //   person.placeOfBirth.toString(),
            //   style: const TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            // const SizedBox(height: 8),
            // const Divider(
            //   color: Colors.grey,
            // ),
            // const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget card2(Person person) {
    //similar movies
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Movies',
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
              future: ApiService.getPersonMovies(person.id!.toInt()),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Movie> movies = snapshot.data as List<Movie>;

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.41,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: movies.length > 9 ? 9 : movies.length,
                      itemBuilder: (context, index) {
                        if (index == 8) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonAllMovies(
                                    personName: person.name.toString(),
                                    movies: movies,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      FontAwesomeIcons.arrowRight,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                Text(
                                  'SEE ALL MOVIES',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
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
                                        : LinkHelper.posterEmptyLink,

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
                                        movies[index].releaseDate!.isNotEmpty
                                            ? movies[index]
                                                    .releaseDate!
                                                    .substring(0, 4) +
                                                '   -'
                                            : '',
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

  Widget card3(Person person) {
    //similar movies
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TV Series',
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
            FutureBuilder<List<CastTvSeries>>(
              future: ApiService.getPersonTvSeries(person.id!.toInt()),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  List<CastTvSeries> tvSeries =
                      snapshot.data as List<CastTvSeries>;

                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.41,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: tvSeries.length > 9 ? 9 : tvSeries.length,
                      itemBuilder: (context, index) {
                        if (index == 8) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PersonAllTvSeries(
                                    personName: person.name.toString(),
                                    series: tvSeries,
                                  ),
                                ),
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      FontAwesomeIcons.arrowRight,
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ),
                                Text(
                                  'SEE ALL TV SERIES',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return Row(
                          children: [
                            InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => MovieDetail(
                                //         id: series[index].id!.toInt()),
                                //   ),
                                // );
                              },
                              child: Column(
                                children: [
                                  Image.network(
                                    tvSeries[index].posterPath != null
                                        ? 'https://image.tmdb.org/t/p/w500' +
                                            tvSeries[index]
                                                .posterPath
                                                .toString()
                                        : LinkHelper.posterEmptyLink,

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
                                        tvSeries[index]
                                                .episodeCount
                                                .toString() +
                                            ' Seasons',
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
}

// ignore: must_be_immutable
class ExpandableText extends StatefulWidget {
  ExpandableText(this.text, {Key? key}) : super(key: key);

  final String text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      AnimatedSize(
          // ignore: deprecated_member_use
          vsync: this,
          duration: const Duration(milliseconds: 500),
          child: ConstrainedBox(
              constraints: widget.isExpanded
                  ? const BoxConstraints()
                  : const BoxConstraints(maxHeight: 50.0),
              child: Text(
                widget.text,
                softWrap: true,
                overflow: TextOverflow.fade,
              ))),
      widget.isExpanded
          ? ConstrainedBox(constraints: const BoxConstraints())
          : TextButton(
              child: const Text('show more'),
              onPressed: () => setState(() => widget.isExpanded = true))
    ]);
  }
}
