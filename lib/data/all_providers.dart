import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:movie_suggestion/model/movie.dart';

final movieProvider = StateProvider<Movie>((ref) => Movie());

final isLoadingProvider = StateProvider<bool>((ref) => false);

final stopSearchingProvider = StateProvider<bool>((ref) => false);

final showAdIndexProvider = StateProvider<int>((ref) => 0);
