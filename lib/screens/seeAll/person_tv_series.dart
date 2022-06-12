import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_suggestion/helper/ad_helper.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/tv_serie_credit.dart';
import 'package:movie_suggestion/screens/details/tv_serie_detail.dart';

class PersonAllTvSeries extends ConsumerStatefulWidget {
  final String personName;
  final List<CastTvSeries> series;
  const PersonAllTvSeries(
      {required this.personName, required this.series, Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonAllTvSeriesState();
}

class _PersonAllTvSeriesState extends ConsumerState<PersonAllTvSeries> {

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
  initState() {
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
          for (var i = 0; i < widget.series.length; i++)
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TvSerieDetail(
                      id: widget.series[i].id!.toInt(),
                    ),
                  ),
                );
              },
              child: Image.network(
                widget.series[i].posterPath == null
                    ? LinkHelper.posterEmptyLink
                    : 'https://image.tmdb.org/t/p/w500/${widget.series[i].posterPath}',
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }
}
