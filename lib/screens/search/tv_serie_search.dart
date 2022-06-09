import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/tv_serie.dart';
import 'package:movie_suggestion/screens/details/tv_serie_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';

class TvSerieSearchScreen extends ConsumerStatefulWidget {
  final String query;

  const TvSerieSearchScreen({required this.query, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TvSerieSearchScreenState();
}

class _TvSerieSearchScreenState extends ConsumerState<TvSerieSearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late Future<List<dynamic>> searchedTvSeriesFuture;
  List<TvSerie> tvSeries = [];
  final controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    searchedTvSeriesFuture =
        ApiService.getTvSerieBySearch(page: page, query: widget.query);

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        debugPrint('max scroll');
        setState(() {
          page++;
        });
        debugPrint('page: $page');
        searchedTvSeriesFuture =
            ApiService.getTvSerieBySearch(page: page, query: widget.query);
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
      future: searchedTvSeriesFuture,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data.length; i++) {
            tvSeries.add(snapshot.data[i]);
          }

          List<TvSerie> tvSeriesNew = tvSeries.toSet().toList();
          return GridView.count(
            controller: controller,
            childAspectRatio: 0.45,
            crossAxisCount: 3,
            children: [
              for (var i = 0; i < tvSeriesNew.length + 1; i++)
                loadTvSerie(tvSeriesNew, i)
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

  Widget loadTvSerie(List<TvSerie> tvSeries, int index) {
    if (index == tvSeries.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TvSerieDetail(
                id: tvSeries[index].id!.toInt(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    tvSeries[index].posterPath == null
                        ? LinkHelper.posterEmptyLink
                        : 'https://image.tmdb.org/t/p/w500/${tvSeries[index].posterPath}',
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
                  Positioned(
                    left: 2,
                    top: 2,
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
                            tvSeries[index].voteAverage.toString(),
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                child: Text(
                  tvSeries[index].name.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
