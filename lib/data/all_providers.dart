import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_suggestion/model/movie.dart';

final movieProvider = StateProvider<Movie>((ref) => Movie());

final movieRatingProvider = StateProvider<double>((ref) => 8.8);

final isLoadingProvider = StateProvider<bool>((ref) => false);

final stopSearchingProvider = StateProvider<bool>((ref) => false);