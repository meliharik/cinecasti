import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_suggestion/data/all_providers.dart';
import 'package:movie_suggestion/helper/ad_helper.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/screens/details/movie_detail.dart';

class PersonAllMovies extends ConsumerStatefulWidget {
  final String personName;
  final List<Movie> movies;
  const PersonAllMovies(
      {required this.personName, required this.movies, Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PersonAllMovieState();
}

const int maxFailedLoad = 3;

class _PersonAllMovieState extends ConsumerState<PersonAllMovies> {
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
        title: Text(widget.personName),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.angleLeft,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: GridView.count(
        childAspectRatio: 0.69,
        crossAxisCount: 3,
        children: [
          for (var i = 0; i < widget.movies.length; i++)
            InkWell(
              onTap: () {
                ref.read(showAdIndexProvider.state).state++;
                if (ref.watch(showAdIndexProvider) % 5 == 0) {
                  _showInterstitialAd();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MovieDetail(
                      id: widget.movies[i].id!.toInt(),
                    ),
                  ),
                );
              },
              child: Image.network(
                widget.movies[i].posterPath == null
                    ? LinkHelper.posterEmptyLink
                    : 'https://image.tmdb.org/t/p/w500/${widget.movies[i].posterPath}',
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
