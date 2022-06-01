import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_suggestion/data/all_providers.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class CardBack extends ConsumerStatefulWidget {
  const CardBack({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CardBackState();
}

class _CardBackState extends ConsumerState<CardBack> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.grey[400]),
      child: ref.watch(isLoadingProvider)
          ? loadingWidget()
          : buildMovieWidget(ref),
    );
  }

  Widget loadingWidget() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Colors.grey[400]),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildMovieWidget(ref) {
    Movie movie = ref.watch(movieProvider);
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            color: Colors.grey[400],
            image: DecorationImage(
              image: NetworkImage(
                  'https://image.tmdb.org/t/p/original/${movie.posterPath}'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(15),
            ),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.0)
              ],
              stops: const [
                0.0,
                0.5,
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
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
                  ref.watch(movieRatingProvider).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 10,
          child: SizedBox(
            width: MediaQuery.of(context).size.width - 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  movie.title.toString(),
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  movie.overview.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 4,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          EvaIcons.clockOutline,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          durationToString(movie.runtime!.toInt()),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        const Icon(
                          EvaIcons.calendarOutline,
                          color: Colors.white,
                          size: 15,
                        ),
                        const SizedBox(
                          width: 3,
                        ),
                        Text(
                          movie.releaseDate.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  String durationToString(int minutes) {
    var d = Duration(minutes: minutes);
    List<String> parts = d.toString().split(':');
    return '${parts[0].padLeft(1, '0')}h ${parts[1].padLeft(2, '0')}m';
  }
}
