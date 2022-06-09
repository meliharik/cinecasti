import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/tv_serie.dart';
import 'package:movie_suggestion/screens/details/tv_serie_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';

class PopularScreenTvSerie extends ConsumerStatefulWidget {
  const PopularScreenTvSerie({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PopularScreenTvSerieState();
}

class _PopularScreenTvSerieState extends ConsumerState<PopularScreenTvSerie>     with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late Future<List<dynamic>> popularTvSeriesFuture;
  List<TvSerie> popularTvSeries = [];
  final controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    popularTvSeriesFuture = ApiService.getPopularTvSeries(page,context);

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        debugPrint('max scroll');
        setState(() {
          page++;
        });
        debugPrint('page: $page');
        popularTvSeriesFuture = ApiService.getPopularTvSeries(page,context);
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
      future: popularTvSeriesFuture,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data.length; i++) {
            popularTvSeries.add(snapshot.data[i]);
          }

          List<TvSerie> popularTvSeriesNew =
              popularTvSeries.toSet().toList();
          return GridView.count(
            controller: controller,
            childAspectRatio: 0.69,
            crossAxisCount: 3,
            children: [
              for (var i = 0; i < popularTvSeriesNew.length + 1; i++)
                loadTvSerie(popularTvSeriesNew, i)
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
