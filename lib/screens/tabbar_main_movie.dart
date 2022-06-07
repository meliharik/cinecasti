import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/screens/tabbar_main_tv_serie.dart';
import 'package:movie_suggestion/screens/tabs/popular_screen_movie.dart';
import 'package:movie_suggestion/screens/tabs/top_rated_screen_movie.dart';

class TabBarMainMovie extends ConsumerStatefulWidget {
  const TabBarMainMovie({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<TabBarMainMovie> {
  @override
  Widget build(BuildContext context) {
    const tab = TabBar(
      tabs: <Tab>[
        Tab(
          text: 'Popular',
        ),
        Tab(
          text: 'Top Rated',
        ),
        Tab(
          text: 'My List',
        ),
      ],
    );
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                child: Text(
                  'Movie Suggestion',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                decoration:  BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.house,
                  color: Colors.blue,
                ),
                title: const Text('Home'),
                onTap: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              ListTile(
                leading: const Icon(
                  FontAwesomeIcons.tv,
                  color: Colors.blue,
                ),
                title: const Text('TV Shows'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TabBarMainTvSerie(),
                      ));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('movieus'),
          bottom: tab,
        ),
        body: const TabBarView(
          children: [
            PopularScreenMovie(),
            TopRatedScreenMovie(),
            Icon(Icons.directions_car, size: 350),
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
}
