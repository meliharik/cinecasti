import 'dart:convert';
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:movie_suggestion/data/all_providers.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/screens/card/card_back.dart';
import 'package:movie_suggestion/screens/card/card_front.dart';

class RecomendScreen extends ConsumerStatefulWidget {
  const RecomendScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<RecomendScreen> {
  String selectedGenre = 'Action';
  String selectedScore = "5";
  bool isClicked = false;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  @override
  void initState() {
    super.initState();
    getFirstMovie();
  }

  Future<void> getFirstMovie() async {
    final String response =
        await rootBundle.loadString('assets/json/fight_club.json');
    final data = await json.decode(response);
    final movie = Movie.fromJson(data);
    ref.read(movieProvider.state).state = movie;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: FlipCard(
            key: cardKey,
            flipOnTouch: false,
            front: const CardFront(),
            back: const CardBack(),
          ),
        ),
        bottomNavigationBar: Container(
          height: 100,
          padding: const EdgeInsets.all(15),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isClicked
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Genre',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          padding: const EdgeInsets.only(left: 5),
                          height: 30.0,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.0,
                            ),
                          ),
                          child: Theme(
                            data: ThemeData(canvasColor: Colors.white),
                            child: DropdownButton(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).primaryColor,
                              ),
                              isExpanded: false,
                              underline: Container(),
                              value: selectedGenre,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedGenre = newValue.toString();
                                });
                              },
                              items: <DropdownMenuItem<String>>[
                                dropDownGenre('Any Genre'),
                                dropDownGenre("Action"),
                                dropDownGenre("Adventure"),
                                dropDownGenre("Animation"),
                                dropDownGenre("Comedy"),
                                dropDownGenre("Crime"),
                                dropDownGenre("Documentary"),
                                dropDownGenre("Drama"),
                                dropDownGenre("Family"),
                                dropDownGenre("Fantasy"),
                                dropDownGenre("History"),
                                dropDownGenre("Horror"),
                                dropDownGenre("Music"),
                                dropDownGenre("Mystery"),
                                dropDownGenre("Romance"),
                                dropDownGenre("Science Fiction"),
                                dropDownGenre("TV Movie"),
                                dropDownGenre("Thriller"),
                                dropDownGenre("War"),
                                dropDownGenre("Western"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
              isClicked
                  ? Container()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Min. Score',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12.0,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Container(
                          padding: const EdgeInsets.only(left: 5),
                          height: 30.0,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(
                              color: Theme.of(context).primaryColor,
                              width: 1.0,
                            ),
                          ),
                          child: Theme(
                            data: ThemeData(canvasColor: Colors.white),
                            child: DropdownButton(
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Theme.of(context).primaryColor,
                              ),
                              isExpanded: false,
                              underline: Container(),
                              value: selectedScore,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedScore = newValue.toString();
                                });
                              },
                              items: <DropdownMenuItem<String>>[
                                dropDownScore('Any Score'),
                                dropDownScore("5"),
                                dropDownScore("6"),
                                dropDownScore("7"),
                                dropDownScore("8"),
                                dropDownScore("9"),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
              // SizedBox(
              //   width: 15,
              // ),
              isClicked
                  ? SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
                        label: const Text('Back'),
                        onPressed: () {
                          ref.read(stopSearchingProvider.state).state = true;
                          setState(() {
                            isClicked = false;
                          });
                          cardKey.currentState!.toggleCard();
                        },
                      ),
                    )
                  : SizedBox(
                      height: 40,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text('Suggest'),
                        onPressed: () {
                          ref.read(stopSearchingProvider.state).state = false;

                          setState(() {
                            isClicked = true;
                          });
                          ref.read(isLoadingProvider.state).state = true;
                          getRandomMovie(ref);
                          cardKey.currentState!.toggleCard();
                        },
                      ),
                    ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  dropDownGenre(String genre) {
    return DropdownMenuItem(
      child: Text(genre),
      value: genre,
    );
  }

  dropDownScore(String score) {
    return DropdownMenuItem(
      child: Text(score),
      value: score,
    );
  }

  Future<void> getRandomMovie(ref) async {
    int randomNumber = 0;
    bool isMovieFound = false;

    while (isMovieFound != true) {
      if (ref.watch(stopSearchingProvider) == true) {
        ref.read(stopSearchingProvider.state).state = false;
        break;
      }
      randomNumber = Random().nextInt(99999);
      debugPrint("randomNumber: " + randomNumber.toString());
      final response = await http.get(Uri.parse(
          "https://api.themoviedb.org/3/movie/$randomNumber?api_key=cb7c804a5ca858c46d783add66f4de13"));
      if (response.statusCode == 200) {
        var document = json.decode(response.body);
        if (document['success'] == false) {
          continue;
        } else {
          Movie movie = Movie.fromJson(document);

          if (selectedScore != 'Any Score' &&
              movie.voteAverage! < double.parse(selectedScore)) {
            continue;
          }
          bool isGenreFound = false;

          for (var i = 0; i < movie.genres!.length; i++) {
            Genres genre = movie.genres![i];
            if (genre.name == selectedGenre) {
              isGenreFound = true;
              break;
            }
          }

          if (isGenreFound == false && selectedGenre != 'Any Genre') {
            continue;
          }
          for (var i = 0; i < movie.genres!.length; i++) {
            debugPrint(movie.genres![i].name);
          }

          isMovieFound = true;
          ref.read(isLoadingProvider.state).state = false;

          ref.read(movieProvider.state).state = movie;
        }
      } else {
        Exception("Error");
      }
    }
  }
}
