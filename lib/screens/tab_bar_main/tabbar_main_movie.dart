import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_suggestion/auth/login.dart';
import 'package:movie_suggestion/drawer/settings_screen.dart';
import 'package:movie_suggestion/helper/ad_helper.dart';
import 'package:movie_suggestion/screens/lists/my_collection.dart';
import 'package:movie_suggestion/screens/lists/watch_list.dart';
import 'package:movie_suggestion/screens/lists/watched_list.dart';
import 'package:movie_suggestion/screens/search/movie_search.dart';
import 'package:movie_suggestion/screens/search/person_search.dart';
import 'package:movie_suggestion/screens/search/tv_serie_search.dart';
import 'package:movie_suggestion/screens/tab_bar_main/tabbar_main_tv_serie.dart';
import 'package:movie_suggestion/screens/tabs/playing_screen_movie.dart';
import 'package:movie_suggestion/screens/tabs/popular_screen_movie.dart';
import 'package:movie_suggestion/screens/tabs/top_rated_screen_movie.dart';
import 'package:movie_suggestion/service/auth_service.dart';

class TabBarMainMovie extends ConsumerStatefulWidget {
  const TabBarMainMovie({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<TabBarMainMovie> {
  bool isSearching = false;
  final textFieldController = TextEditingController();
  String searchQuery = '';
  bool showLists = false;

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
    textFieldController.dispose();
    super.dispose();
    _bottomBannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tab = TabBar(
      tabs: <Tab>[
        Tab(
          text: 'popular'.tr().toString(),
        ),
        Tab(
          text: 'top_rated'.tr().toString(),
        ),
        Tab(
          text: 'playing'.tr().toString(),
        ),
      ],
    );
    final tab2 = TabBar(
      tabs: <Tab>[
        Tab(
          text: 'movies'.tr().toString(),
        ),
        Tab(
          text: 'tv_series'.tr().toString(),
        ),
        Tab(
          text: 'people'.tr().toString(),
        ),
      ],
    );
    if (isSearching) {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(FontAwesomeIcons.angleLeft),
              onPressed: () {
                setState(() {
                  isSearching = false;
                });
              },
            ),
            bottom: tab2,
            title: TextField(
              controller: textFieldController,
              autofocus: true,
              onSubmitted: (value) {
                setState(() {
                  searchQuery = value;
                });
                //TODO: search fix
                debugPrint(value);
              },
              decoration: InputDecoration(
                focusColor: Theme.of(context).appBarTheme.backgroundColor,
                fillColor: Theme.of(context).appBarTheme.backgroundColor,
                hintText: 'search'.tr().toString(),
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      textFieldController.text = '';
                    });
                  },
                ),
              ),
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              searchQuery != ''
                  ? MovieSearchScreen(query: textFieldController.text)
                  : const SizedBox(),
              searchQuery != ''
                  ? TvSerieSearchScreen(query: textFieldController.text)
                  : const SizedBox(),
              searchQuery != ''
                  ? PersonSearchScreen(query: textFieldController.text)
                  : const SizedBox(),
            ],
          ),
        ),
      );
    }

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        bottomNavigationBar: _isBottomBannerAdLoaded
            ? Container(
                height: _bottomBannerAd.size.height.toDouble(),
                width: _bottomBannerAd.size.width.toDouble(),
                child: AdWidget(
                  ad: _bottomBannerAd,
                ),
              )
            : null,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                ),
                accountName: Text(
                  '${FirebaseAuth.instance.currentUser?.displayName}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onDetailsPressed: () {
                  setState(() {
                    showLists = !showLists;
                  });
                },
                accountEmail: Text(
                  '${FirebaseAuth.instance.currentUser?.email}',
                  style: const TextStyle(
                    fontSize: 15,
                  ),
                ),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    '${FirebaseAuth.instance.currentUser?.photoURL}',
                  ),
                ),
              ),
              lists(),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.house,
                ),
                title: Text('home'.tr().toString()),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.tv,
                  // color: Colors.blue,
                ),
                title: Text('tv_series'.tr().toString()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TabBarMainTvSerie(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.gear,
                ),
                title: Text('settings'.tr().toString()),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ));
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.solidHeart,
                ),
                title: Text('recommend_cinecasti'.tr().toString()),
                onTap: () {
                  // Navigator.pushNamed(context, '/');
                },
              ),
              _cikisYap()
            ],
          ),
        ),
        appBar: AppBar(
          title: Text('movies'.tr().toString()),
          bottom: tab,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = !isSearching;
                });
              },
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            PopularScreenMovie(),
            TopRatedScreenMovie(),
            PlayingScreenMovie(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(
            FontAwesomeIcons.shuffle,
          ),
        ),
      ),
    );
  }

  Widget lists() {
    if (showLists) {
      return Column(
        children: [
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.list,
              color: Colors.blueAccent,
            ),
            title: Text('watch_list'.tr().toString()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WatchListScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.check,
              color: Colors.greenAccent,
            ),
            title: Text('watched_list'.tr().toString()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WatchedListScreen(),
                  ));
            },
          ),
          ListTile(
            leading: const Icon(
              FontAwesomeIcons.bookmark,
              color: Colors.redAccent,
            ),
            title: Text('my_collection'.tr().toString()),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyCollectionScreen(),
                  ));
            },
          ),
          const Divider()
        ],
      );
    } else {
      return const SizedBox();
    }
  }

  Widget _cikisYap() {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'sign_out'.tr().toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            content: Text(
              'are_you_sure'.tr().toString(),
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'cancel'.tr().toString(),
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              TextButton(
                onPressed: _cikisYapFonk,
                child: Text(
                  'sign_out'.tr().toString(),
                  style: TextStyle(
                    color: Theme.of(context).errorColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      child: ListTile(
        minVerticalPadding: 0,
        horizontalTitleGap: 0,
        leading: const Icon(
          FontAwesomeIcons.rightFromBracket,
          // color: Theme.of(context).primaryColor,
        ),
        title: Text('sign_out'.tr().toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            )),
        // trailing: Icon(
        //   FontAwesomeIcons.angleRight,
        //   color: Theme.of(context).primaryColor,
        // ),
      ),
    );
  }

  void _cikisYapFonk() async {
    try {
      await AuthService().cikisYap();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } catch (hata) {
      debugPrint("hata");
      debugPrint(hata.hashCode.toString());
      debugPrint(hata.toString());
      var snackBar = SnackBar(
          content: Text('${'an_error_accured'.tr().toString()}: $hata'));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
