import 'dart:convert';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/screens/card_back.dart';
import 'package:movie_suggestion/screens/card_front.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String selectedGenre = 'Action';
  String selectedScore = "5";
  bool isClicked = false;
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
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
              // SizedBox(
              //   width: 10,
              // ),
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
                  ? Container(
                      height: 40,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
                        label: const Text('Back'),
                        onPressed: () {
                          setState(() {
                            isClicked = false;
                          });
                          cardKey.currentState!.toggleCard();
                        },
                      ),
                    )
                  : Container(
                      height: 40,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text('Suggest'),
                        onPressed: () {
                          setState(() {
                            isClicked = true;
                          });
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

// Future<Movie> getRandomMovie(){}

Future getIMDB(String imdbId) async {
  final response = await http.get(
      Uri.parse("https://imdb-api.com/en/API/UserRatings/k_8dy8at8i/$imdbId"));
  if (response.statusCode == 200) {
    var document = jsonDecode(response.body);
    var id = document["totalRating"];
    debugPrint(id);
  } else {
    throw Exception('Failed to load post');
  }
}
