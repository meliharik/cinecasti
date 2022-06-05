import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:movie_suggestion/model/members.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/model/movie_provider.dart';
import 'package:movie_suggestion/model/person.dart';
import 'package:movie_suggestion/model/person_social.dart';
import 'package:movie_suggestion/model/popular_movies.dart';
import 'package:movie_suggestion/model/similar_tv_series.dart';
import 'package:movie_suggestion/model/top_rated_movies.dart';
import 'package:movie_suggestion/model/tv_serie.dart';
import 'package:movie_suggestion/model/tv_serie_credit.dart';

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

  static Future getTvSerieById(int id) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/$id?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      TvSerie tvSerie = TvSerie.fromJson(document);
      return tvSerie;
    } else {
      Exception('Failed to load tv serie');
    }
  }

  static Future<List<PopularMovie>> getPopularMovies(int pageNumber) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&page=$pageNumber'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      List results = document['results'];
      List<PopularMovie> popMovies = [];
      for (var i = 0; i < results.length; i++) {
        num rating = results[i]['vote_average'];
        if (rating != 0.0) {
          popMovies.add(PopularMovie.fromJson(results[i]));
        }
      }
      return popMovies;
    } else {
      Exception('Failed to load popular movies');
      return [];
    }
  }

  static Future<List<TopRatedMovie>> getTopRatedMovies(int pageNumber) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&page=$pageNumber'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      List results = document['results'];
      List<TopRatedMovie> popMovies = [];
      for (var i = 0; i < results.length; i++) {
        double rating = results[i]['vote_average'];
        if (rating != 0.0) {
          popMovies.add(TopRatedMovie.fromJson(results[i]));
        }
      }
      return popMovies;
    } else {
      Exception('Failed to load top rated movies');
      return [];
    }
  }

  static Future<String> getMovieVideoId(Movie movie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/videos?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['results'];

      if (results.isEmpty) {
        return '';
      }

      for (var i = 0; i < results.length; i++) {
        if (results[i]['type'] == 'Trailer') {
          return results[i]['key'].toString();
        }
      }

      return results[0]['key'].toString();
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<String> getTvSerieVideoId(TvSerie tvSerie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/${tvSerie.id}/videos?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['results'];
      if (results.isEmpty) {
        return '';
      }

      for (var i = 0; i < results.length; i++) {
        if (results[i]['type'] == 'Trailer') {
          return results[i]['key'].toString();
        }
      }

      return results[0]['key'].toString();
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<Cast>> getMovieCastMembers(Movie movie) async {
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

  static Future<List<Cast>> getTvSerieCastMembers(TvSerie tvSerie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/${tvSerie.id}/credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
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

  static Future<List<Crew>> getMovieCrewMembers(Movie movie) async {
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

  static Future<List<Crew>> getTvSerieCrewMembers(TvSerie tvSerie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/${tvSerie.id}/credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
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
        double rating = results[i]['vote_average'];
        if (rating != 0.0) {
          similarMovies.add(Movie.fromJson(results[i]));
        }
      }
      return similarMovies;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<SimilarTvSeries>> getSimilarTvSeries(
      TvSerie tvSerie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/${tvSerie.id}/similar?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&page=1'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['results'];
      List<SimilarTvSeries> similarTvSeries = [];
      for (var i = 0; i < results.length; i++) {
        double rating = results[i]['vote_average'];
        if (rating != 0.0) {
          similarTvSeries.add(SimilarTvSeries.fromJson(results[i]));
        }
      }
      return similarTvSeries;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<MovieAndTvSerieProvider>> getMovieProviders(
      Movie movie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/watch/providers?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var results = jsonResponse['results'];
      if (results.isNotEmpty) {
        results = jsonResponse['results']['US']['buy'] ?? [];
      }
      var results2 = jsonResponse['results'];
      if (results2.isNotEmpty) {
        results2 = jsonResponse['results']['US']['flatrate'] ?? [];
      }
      results.addAll(results2);
      List<MovieAndTvSerieProvider> providers = [];
      List<MovieAndTvSerieProvider> providers2 = [];
      for (var i = 0; i < results.length; i++) {
        providers.add(MovieAndTvSerieProvider.fromJson(results[i]));
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

  static Future<List<MovieAndTvSerieProvider>> getTvSerieProviders(
      TvSerie tvSerie) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/${tvSerie.id}/watch/providers?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var results = jsonResponse['results'];
      if (results.isNotEmpty) {
        results = jsonResponse['results']['US']['buy'] ?? [];
      }
      var results2 = jsonResponse['results'];
      if (results2.isNotEmpty) {
        results2 = jsonResponse['results']['US']['flatrate'] ?? [];
      }
      results.addAll(results2);
      List<MovieAndTvSerieProvider> providers = [];
      List<MovieAndTvSerieProvider> providers2 = [];
      for (var i = 0; i < results.length; i++) {
        providers.add(MovieAndTvSerieProvider.fromJson(results[i]));
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
        double rating = results[i]['vote_average'];
        if (rating != 0.0) {
          movies.add(Movie.fromJson(results[i]));
        }
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

  static Future<PersonSocial> getPersonSocial(int id) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/$id/external_ids?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return PersonSocial.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }
}
