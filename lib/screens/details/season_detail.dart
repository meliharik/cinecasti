import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_suggestion/helper/ad_helper.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/season.dart';
import 'package:movie_suggestion/screens/details/episode_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';

class SeasonDetail extends ConsumerStatefulWidget {
  final int seasonNumber;
  final int tvSerieId;
  final String? tvSerieName;

  const SeasonDetail(
      {required this.seasonNumber,
      required this.tvSerieId,
      required this.tvSerieName,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SeasonDetailState();
}

class _SeasonDetailState extends ConsumerState<SeasonDetail> {

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
    return FutureBuilder(
      future: ApiService.getSeasonById(
          context: context,
          seasonNumber: widget.seasonNumber,
          tvSerieId: widget.tvSerieId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Season season = snapshot.data as Season;
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
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(FontAwesomeIcons.angleLeft),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                '${widget.tvSerieName} - ' +
                    'season'.tr().toString() +
                    ' ${widget.seasonNumber}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            body: ListView.builder(
              itemCount: season.episodes!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: ((context) => EpisodeDetail(
                                episodeNumber: index + 1,
                                seasonNumber: widget.seasonNumber,
                                tvSerieId: widget.tvSerieId,
                              )),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Image.network(
                          season.episodes![index].stillPath == null
                              ? LinkHelper.episodeEmptyLink
                              : 'https://image.tmdb.org/t/p/original/${season.episodes![index].stillPath}',
                          width: MediaQuery.of(context).size.width * 0.4,
                          loadingBuilder: (context, child, loadingProgress) =>
                              loadingProgress == null
                                  ? child
                                  : SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.4,
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
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'episode'.tr().toString() +
                                      ' ${season.episodes![index].episodeNumber}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${season.episodes![index].name}',
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
        } else if (snapshot.hasError) {
          debugPrint('error');
          debugPrint(snapshot.error.toString());

          return const Scaffold(
            body: Center(
              child: Text('error'),
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
