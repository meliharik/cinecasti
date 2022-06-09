import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/tv_serie.dart';
import 'package:movie_suggestion/screens/details/tv_serie_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';

class TodayScreenTvSerie extends ConsumerStatefulWidget {
  const TodayScreenTvSerie({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TodayScreenTvSerieState();
}

class _TodayScreenTvSerieState extends ConsumerState<TodayScreenTvSerie>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late Future<List<dynamic>> todayTvSeriesFuture;
  List<TvSerie> todayTvSeries = [];
  final controller = ScrollController();
  int page = 1;

    @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        debugPrint('max scroll');
        setState(() {
          page++;
        });
        debugPrint('page: $page');
        todayTvSeriesFuture = ApiService.getTodayTvSeries(page, context);
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
    todayTvSeriesFuture = ApiService.getTodayTvSeries(page, context);

        return FutureBuilder(
      future: todayTvSeriesFuture,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data.length; i++) {
            todayTvSeries.add(snapshot.data[i]);
          }

          List<TvSerie> todayTvSeriesNew = todayTvSeries.toSet().toList();
          debugPrint('snapshot.data.length: ${snapshot.data.length}');
          debugPrint('poopularMovies.length: ${todayTvSeries.length}');
          debugPrint('popularMoviesNew.length: ${todayTvSeriesNew.length}');
          return GridView.count(
            controller: controller,
            childAspectRatio: 0.69,
            crossAxisCount: 3,
            children: [
              for (var i = 0; i < todayTvSeriesNew.length + 1; i++)
                loadMovie(todayTvSeriesNew, i)
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

  Widget loadMovie(List<TvSerie> tvSeries, int index) {
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
        child: Image.network(
          tvSeries[index].posterPath == null
              ? LinkHelper.posterEmptyLink
              : 'https://image.tmdb.org/t/p/w500/${tvSeries[index].posterPath}',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) =>
              loadingProgress == null
                  ? child
                  : Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!.toInt()
                            : null,
                      ),
                    ),
        ),
      );
    }

  }
}
