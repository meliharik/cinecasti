import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/episode.dart';
import 'package:movie_suggestion/model/movie_provider.dart';
import 'package:movie_suggestion/screens/details/person_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class EpisodeDetail extends ConsumerStatefulWidget {
  final int episodeNumber;
  final int seasonNumber;
  final int tvSerieId;
  const EpisodeDetail(
      {required this.episodeNumber,
      required this.seasonNumber,
      required this.tvSerieId,
      Key? key})
      : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _EpisodeDetailState();
}

class _EpisodeDetailState extends ConsumerState<EpisodeDetail> {
  final controller = ScrollController();
  bool isTitleCentered = false;

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.pixels >=
          MediaQuery.of(context).size.height / 8) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ApiService.getEpisodeById(
          episodeNumber: widget.episodeNumber,
          seasonNumber: widget.seasonNumber,
          context: context,
          tvserieId: widget.tvSerieId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Episode episode = snapshot.data as Episode;
          return getEpisodeDetail(episode);
        } else if (snapshot.hasError) {
          debugPrint('error');
          debugPrint(snapshot.error.toString());

          return const Scaffold(body: Text('error'));
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget getEpisodeDetail(Episode episode) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          controller: controller,
          slivers: [
            getAppBar(episode),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  card1(episode),
                  card2(episode),
                  card3(episode),
                  // card4(movie),
                  // card5(movie),
                  // card6(movie),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getAppBar(Episode episode) {
    return SliverAppBar(
      centerTitle: true,
      title: isTitleCentered
          ? Text(
              'Episode ' + widget.episodeNumber.toString(),
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
      expandedHeight: MediaQuery.of(context).size.height * 0.25,
      flexibleSpace: FlexibleSpaceBar(
        title: isTitleCentered
            ? const SizedBox()
            : Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Episode ' + widget.episodeNumber.toString(),
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
                    episode.name.toString(),
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
                  episode.stillPath == null
                      ? LinkHelper.episodeEmptyLink
                      : 'https://image.tmdb.org/t/p/original/${episode.stillPath}',
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

  Widget card1(Episode episode) {
    String formattedDate = episode.airDate!.isNotEmpty
        ? DateFormat.yMMMd().format(DateTime.parse(episode.airDate.toString()))
        : '';
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
                  'Season ' + episode.seasonNumber.toString(),
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formattedDate != '' ? formattedDate : '',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  episode.runtime != null
                      ? (episode.runtime.toString() + ' min')
                      : '',
                  style: const TextStyle(
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
              episode.overview!.isNotEmpty
                  ? (episode.overview.toString())
                  : 'No overview',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget card2(Episode episode) {
    if (episode.guestStars!.isEmpty) {
      return const SizedBox();
    }
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Guest Stars',
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.33,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: episode.guestStars!.length,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PersonDetail(
                                  id: episode.guestStars![index].id!.toInt()),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.network(
                              episode.guestStars![index].profilePath != null
                                  ? 'https://image.tmdb.org/t/p/w500' +
                                      episode.guestStars![index].profilePath
                                          .toString()
                                  : 'https://www.diabetes.ie/wp-content/uploads/2017/02/no-image-available.png',

                              loadingBuilder:
                                  (context, child, loadingProgress) =>
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
                              height: MediaQuery.of(context).size.height * 0.25,
                              // width: 100,
                            ),
                            Text(
                              episode.guestStars![index].name.toString(),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              episode.guestStars![index].character.toString(),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget card3(Episode episode) {
    //see on
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'See On',
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
            ListTile(
              trailing: const Icon(
                FontAwesomeIcons.angleRight,
                color: Colors.white54,
              ),
              onTap: () async {
                String editedText =
                    episode.name!.replaceAll(RegExp(r'[^\w\s]+'), '');
                await launchUrl(Uri.parse(
                    'https://www.google.com/search?q=$editedText+Season+${episode.seasonNumber}+Episode+${episode.episodeNumber}'));
              },
              title: const Text(
                'Google',
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
        ),
      ),
    );
  }

  Widget getListTile(
      List<MovieAndTvSerieProvider> providers, int index, Episode episode) {
    if (providers[index].providerName == 'YouTube') {
      return ListTile(
        trailing: const Icon(
          FontAwesomeIcons.angleRight,
          color: Colors.white54,
        ),
        onTap: () async {
          String editedText = episode.name!.replaceAll(RegExp(r'[^\w\s]+'), '');
          String editedText2 = editedText.replaceAll(' ', '+');
          await launchUrl(Uri.parse(
              'https://www.youtube.com/results?search_query=$editedText2'));
        },
        title: Text(
          providers[index].providerName.toString(),
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
          String editedText = episode.name!.replaceAll(RegExp(r'[^\w\s]+'), '');
          String editedText2 = editedText.replaceAll(' ', '+');
          await launchUrl(Uri.parse(
              'https://www.google.com/search?q=Amazon+Video+$editedText2'));
        },
        title: Text(
          providers[index].providerName.toString(),
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
          String editedText = episode.name!.replaceAll(RegExp(r'[^\w\s]+'), '');
          String editedText2 = editedText.replaceAll(' ', '+');
          await launchUrl(Uri.parse(
              'https://www.google.com/search?q=Netflix+$editedText2'));
        },
        title: Text(
          providers[index].providerName.toString(),
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
          providers[index].providerName.toString(),
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
          String editedText = episode.name!.replaceAll(RegExp(r'[^\w\s]+'), '');
          String editedText2 = editedText.replaceAll(' ', '%20');
          await launchUrl(Uri.parse(
              'https://play.google.com/store/search?q=$editedText2&c=movies'));
        },
        title: Text(
          providers[index].providerName.toString(),
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
}
