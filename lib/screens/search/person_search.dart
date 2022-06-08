import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/helper/link_helper.dart';
import 'package:movie_suggestion/model/person.dart';
import 'package:movie_suggestion/screens/details/person_detail.dart';
import 'package:movie_suggestion/service/api_service.dart';

class PersonSearchScreen extends ConsumerStatefulWidget {
  final String query;

  const PersonSearchScreen({required this.query, Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PersonSearchScreenState();
}

class _PersonSearchScreenState extends ConsumerState<PersonSearchScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late Future<List<dynamic>> searchedPersonsFuture;
  List<Person> persons = [];
  final controller = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    searchedPersonsFuture =
        ApiService.getPersonBySearch(page: page, query: widget.query);

    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        debugPrint('max scroll');
        setState(() {
          page++;
        });
        debugPrint('page: $page');
        searchedPersonsFuture =
            ApiService.getPersonBySearch(page: page, query: widget.query);
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
      future: searchedPersonsFuture,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data.length; i++) {
            persons.add(snapshot.data[i]);
          }

          List<Person> personsNew = persons.toSet().toList();
          return GridView.count(
            controller: controller,
            childAspectRatio: 0.45,
            crossAxisCount: 3,
            children: [
              for (var i = 0; i < personsNew.length + 1; i++)
                loadPerson(personsNew, i)
            ],
          );
        } else if (snapshot.hasError) {
          debugPrint('error');
          debugPrint(snapshot.error.toString());
          return Text('${snapshot.error}');
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget loadPerson(List<Person> persons, int index) {
    if (index == persons.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PersonDetail(
                id: persons[index].id!.toInt(),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Column(
            children: [
              Image.network(
                persons[index].profilePath == null
                    ? LinkHelper.personEmptyLink
                    : 'https://image.tmdb.org/t/p/w500/${persons[index].profilePath}',
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                        ? child
                        : Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                          .toInt()
                                  : null,
                            ),
                          ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 8, left: 8),
                child: Text(
                  persons[index].name.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
