import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_suggestion/helper/ad_helper.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/screens/details/movie_detail.dart';

class SuggestedMoviesScreen extends ConsumerStatefulWidget {
  final List<Movie> movies;
  const SuggestedMoviesScreen({required this.movies, Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SuggestedMoviesScreenState();
}

class _SuggestedMoviesScreenState extends ConsumerState<SuggestedMoviesScreen> {
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

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
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.angleLeft),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: widget.movies.length,
        itemBuilder: (context, index) {
          Movie movie = widget.movies[index];
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
                  Stack(
                    children: [
                      Image.network(
                        movie.backdropPath == null
                            ? LinkHelper.episodeEmptyLink
                            : 'https://image.tmdb.org/t/p/original/${movie.backdropPath}',
                        width: MediaQuery.of(context).size.width * 0.4,
                        loadingBuilder: (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.4,
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
                    ],
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
      ),
    );
  }
}
