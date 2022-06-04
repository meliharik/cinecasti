import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/screens/tabs/popular_screen.dart';
import 'package:movie_suggestion/screens/tabs/top_rated_screen.dart';

class TabBarMain extends ConsumerStatefulWidget {
  const TabBarMain({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<TabBarMain> {
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
        appBar: AppBar(
          title: const Text('movieus'),
          bottom: tab,
        ),
        body: const TabBarView(
          children: [
            PopularScreen(),
            TopRatedScreen(),
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
