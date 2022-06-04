import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_suggestion/model/members.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/model/movie_provider.dart';
import 'package:movie_suggestion/model/person.dart';
import 'package:movie_suggestion/model/popular_movies.dart';
import 'package:movie_suggestion/model/tv_serie.dart';

class ApiService {
  static Future getMovieById(int id) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$id?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      Movie movie = Movie.fromJson(document);
      return movie;
    } else {
      Exception('Failed to load movie');
    }
  }

  static Future<List<PopularMovie>> getPopularMovies(int pageNumber) async {
    if (pageNumber == 1) {
      final response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/popular?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&page=$pageNumber'));
      if (response.statusCode == 200) {
        var document = json.decode(response.body);
        List tempList = document['results'];
        List<PopularMovie> popMovies = [];
        for (var i = 0; i < tempList.length; i++) {
          popMovies.add(PopularMovie.fromJson(tempList[i]));
        }
        return popMovies;
      } else {
        Exception('Failed to load popular movies');
        return [];
      }
    } else {
      List<PopularMovie> popMovies = [];

      for (int i = 1; i < pageNumber; i++) {
        final response = await http.get(Uri.parse(
            'https://api.themoviedb.org/3/movie/popular?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&page=$i'));
        if (response.statusCode == 200) {
          var document = json.decode(response.body);
          List tempList = document['results'];
          for (var i = 0; i < tempList.length; i++) {
            popMovies.add(PopularMovie.fromJson(tempList[i]));
          }
        } else {
          Exception('Failed to load popular movies');
          return [];
        }
      }
      return popMovies;
    }
  }

  static Future<String> getVideoId(Movie movie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/videos?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['results'];

      return results[0]['key'].toString();
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<Cast>> getCastMembers(Movie movie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['cast'];
      List<Cast> cast = [];
      for (var i = 0; i < results.length; i++) {
        cast.add(Cast.fromJson(results[i]));
      }
      return cast;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<Crew>> getCrewMembers(Movie movie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['crew'];
      List<Crew> cast = [];
      for (var i = 0; i < results.length; i++) {
        cast.add(Crew.fromJson(results[i]));
      }
      return cast;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<Movie>> getSimilarMovies(Movie movie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/similar?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&page=1'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['results'];
      List<Movie> similarMovies = [];
      for (var i = 0; i < results.length; i++) {
        similarMovies.add(Movie.fromJson(results[i]));
      }
      return similarMovies;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<MovieProvider>> getMovieProviders(Movie movie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/watch/providers?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['results']['US']['buy'] ?? [];
      List<MovieProvider> providers = [];
      List<MovieProvider> providers2 = [];
      for (var i = 0; i < results.length; i++) {
        providers.add(MovieProvider.fromJson(results[i]));
      }
      for (var provider in providers) {
        if (provider.providerName == 'Amazon Prime Video' ||
            provider.providerName == 'Netflix' ||
            provider.providerName == 'Amazon Video' ||
            provider.providerName == 'YouTube' ||
            provider.providerName == 'Google Play Movies' ||
            provider.providerName == 'Disney Plus') {
          providers2.add(provider);
        }
      }
      return providers2;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<Person> getPersonById(int id) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/$id?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Person.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<Movie>> getPersonMovies(int id) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/$id/movie_credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['cast'];
      List<Movie> movies = [];
      for (var i = 0; i < results.length; i++) {
        movies.add(Movie.fromJson(results[i]));
      }
      return movies;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<CastTvSeries>> getPersonTvSeries(int id) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/$id/tv_credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['cast'];
      List<CastTvSeries> tvSeries = [];
      for (var i = 0; i < results.length; i++) {
        tvSeries.add(CastTvSeries.fromJson(results[i]));
      }
      return tvSeries;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
