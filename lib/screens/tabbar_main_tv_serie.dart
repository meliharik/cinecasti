import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/screens/tabbar_main_movie.dart';
import 'package:movie_suggestion/screens/tabs/popular_screen_tv_serie.dart';
import 'package:movie_suggestion/screens/tabs/top_rated_screen_tv_serie.dart';

class TabBarMainTvSerie extends ConsumerStatefulWidget {
  const TabBarMainTvSerie({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TabBarMainTvSerieState();
}

class _TabBarMainTvSerieState extends ConsumerState<TabBarMainTvSerie> {
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
                decoration: BoxDecoration(
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
                title: const Text('Movies'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TabBarMainMovie(),
                      ));
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text('TV Series'),
          bottom: tab,
        ),
        body: const TabBarView(
          children: [
            PopularScreenTvSerie(),
            TopRatedScreenTvSerie(),
            // Icon(Icons.directions_car, size: 350),

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
