import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movie_suggestion/model/episode.dart';
import 'package:movie_suggestion/model/members.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/model/movie_provider.dart';
import 'package:movie_suggestion/model/person.dart';
import 'package:movie_suggestion/model/person_social.dart';
import 'package:movie_suggestion/model/season.dart';
import 'package:movie_suggestion/model/similar_tv_series.dart';
import 'package:movie_suggestion/model/tv_serie.dart';
import 'package:movie_suggestion/model/tv_serie_credit.dart';

class ApiService {
  static Future getMovieById(int id, BuildContext context) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/$id?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      Movie movie = Movie.fromJson(document);
      return movie;
    } else {
      Exception('Failed to load movie');
    }
  }

  static Future getTvSerieById(int id, BuildContext context) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/$id?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      TvSerie tvSerie = TvSerie.fromJson(document);
      return tvSerie;
    } else {
      Exception('Failed to load tv serie');
    }
  }

  static Future<List<Movie>> getPopularMovies(
      int pageNumber, BuildContext context) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/popular?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}&page=$pageNumber'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      List results = document['results'];
      List<Movie> popMovies = [];
      for (var i = 0; i < results.length; i++) {
        num rating = results[i]['vote_average'];
        if (rating != 0.0) {
          popMovies.add(Movie.fromJson(results[i]));
        }
      }
      return popMovies;
    } else {
      Exception('Failed to load popular movies');
      return [];
    }
  }

  static Future<List<TvSerie>> getPopularTvSeries(
      int pageNumber, BuildContext context) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/popular?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}&page=$pageNumber'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      List results = document['results'];
      List<TvSerie> popMovies = [];
      for (var i = 0; i < results.length; i++) {
        num rating = results[i]['vote_average'];
        if (rating != 0.0) {
          popMovies.add(TvSerie.fromJson(results[i]));
        }
      }
      return popMovies;
    } else {
      Exception('Failed to load popular movies');
      return [];
    }
  }

  static Future<List<TvSerie>> getTodayTvSeries(
      int pageNumber, BuildContext context) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/airing_today?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}&page=$pageNumber'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      List results = document['results'];
      List<TvSerie> popMovies = [];
      for (var i = 0; i < results.length; i++) {
        num rating = results[i]['vote_average'];
        if (rating != 0.0) {
          popMovies.add(TvSerie.fromJson(results[i]));
        }
      }
      return popMovies;
    } else {
      Exception('Failed to load popular movies');
      return [];
    }
  }

  static Future<List<Movie>> getNowPlayingMovies(
      int pageNumber, BuildContext context) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/now_playing?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}&page=$pageNumber'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      List results = document['results'];
      List<Movie> popMovies = [];
      for (var i = 0; i < results.length; i++) {
        num rating = results[i]['vote_average'];
        if (rating != 0.0) {
          popMovies.add(Movie.fromJson(results[i]));
        }
      }
      return popMovies;
    } else {
      Exception('Failed to load popular movies');
      return [];
    }
  }

  static Future<List<Movie>> getTopRatedMovies(
      int pageNumber, BuildContext context) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/top_rated?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}&page=$pageNumber'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      List results = document['results'];
      List<Movie> popMovies = [];
      for (var i = 0; i < results.length; i++) {
        double rating = results[i]['vote_average'];
        if (rating != 0.0) {
          popMovies.add(Movie.fromJson(results[i]));
        }
      }
      return popMovies;
    } else {
      Exception('Failed to load top rated movies');
      return [];
    }
  }

  static Future<List<TvSerie>> getTopRatedTvSeries(
      int pageNumber, BuildContext context) async {
    final response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/top_rated?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}&page=$pageNumber'));
    if (response.statusCode == 200) {
      var document = json.decode(response.body);
      List results = document['results'];
      List<TvSerie> popMovies = [];
      for (var i = 0; i < results.length; i++) {
        num rating = results[i]['vote_average'];
        if (rating != 0.0) {
          popMovies.add(TvSerie.fromJson(results[i]));
        }
      }
      return popMovies;
    } else {
      Exception('Failed to load top rated movies');
      return [];
    }
  }

  static Future<String> getMovieVideoId(
      Movie movie, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/videos?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
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

  static Future<String> getTvSerieVideoId(
      TvSerie tvSerie, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/${tvSerie.id}/videos?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
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

  static Future<List<Cast>> getMovieCastMembers(
      Movie movie, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
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

  static Future<List<Cast>> getTvSerieCastMembers(
      TvSerie tvSerie, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/${tvSerie.id}/credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
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

  static Future<List<Crew>> getMovieCrewMembers(
      Movie movie, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
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

  static Future<List<Crew>> getTvSerieCrewMembers(
      TvSerie tvSerie, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/${tvSerie.id}/credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
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

  static Future<List<Movie>> getSimilarMovies(
      Movie movie, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/similar?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}&page=1'));
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
      TvSerie tvSerie, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/${tvSerie.id}/similar?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}&page=1'));
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
      Movie movie, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/movie/${movie.id}/watch/providers?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var results = jsonResponse['results'];
      if (results['US'] == null ||
          results['US'].isEmpty ||
          results['US']['buy'] == null ||
          results['US']['buy'].isEmpty) {
        return [];
      }
      if ((results['US']['buy'] == null && results['US']['flatrate'] == null) ||
          results.isEmpty ||
          results == null) {
        return [];
      }
      if (results.isNotEmpty) {
        results = jsonResponse['results']['US']['buy'] ?? [];
      }
      var results2 = jsonResponse['results'];
      if (results2.isNotEmpty || results2 != null) {
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
      TvSerie tvSerie, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/${tvSerie.id}/watch/providers?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var results = jsonResponse['results'];
      if (results['US'] == null ||
          results['US'].isEmpty ||
          results['US']['buy'] == null ||
          results['US']['buy'].isEmpty) {
        return [];
      }
      if ((results['US']['buy'] == null && results['US']['flatrate'] == null) ||
          results.isEmpty ||
          results == null) {
        return [];
      }
      if (results.isNotEmpty || results != null) {
        results = jsonResponse['results']['US']['buy'] ?? [];
      }
      var results2 = jsonResponse['results'];
      if (results2.isNotEmpty || results2 != null) {
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

  static Future<Person> getPersonById(int id, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/$id?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Person.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<Movie>> getPersonMovies(
      int id, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/$id/movie_credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
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

  static Future<List<CastTvSeries>> getPersonTvSeries(
      int id, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/$id/tv_credits?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
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

  static Future<PersonSocial> getPersonSocial(
      int id, BuildContext context) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/person/$id/external_ids?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return PersonSocial.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<Season> getSeasonById(
      {required int seasonNumber,
      required int tvSerieId,
      required BuildContext context}) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/tv/$tvSerieId/season/$seasonNumber?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      return Season.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<Episode> getEpisodeById(
      {required int episodeNumber,
      required int seasonNumber,
      required int tvserieId,
      required BuildContext context}) {
    return http
        .get(Uri.parse(
            'https://api.themoviedb.org/3/tv/$tvserieId/season/$seasonNumber/episode/$episodeNumber?api_key=cb7c804a5ca858c46d783add66f4de13&language=${context.locale.languageCode}'))
        .then((response) {
      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        return Episode.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to load post');
      }
    });
  }

  ////////////////// search ///////////////////////
  static Future<List<Movie>> getMovieBySearch(
      {required String query,
      required int page,
      required BuildContext context}) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/movie?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&query=$query&page=$page'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['results'];
      List<Movie> movies = [];
      for (var i = 0; i < results.length; i++) {
        movies.add(Movie.fromJson(results[i]));
      }
      return movies;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<TvSerie>> getTvSerieBySearch(
      {required String query,
      required int page,
      required BuildContext context}) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/tv?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&query=$query&page=$page'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['results'];
      List<TvSerie> tvSeries = [];
      for (var i = 0; i < results.length; i++) {
        tvSeries.add(TvSerie.fromJson(results[i]));
      }
      return tvSeries;
    } else {
      throw Exception('Failed to load post');
    }
  }

  static Future<List<Person>> getPersonBySearch(
      {required String query,
      required int page,
      required BuildContext context}) async {
    var response = await http.get(Uri.parse(
        'https://api.themoviedb.org/3/search/person?api_key=cb7c804a5ca858c46d783add66f4de13&language=en-US&query=$query&page=$page'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      List results = jsonResponse['results'];
      List<Person> persons = [];
      for (var i = 0; i < results.length; i++) {
        persons.add(Person.fromJson(results[i]));
      }
      return persons;
    } else {
      throw Exception('Failed to load post');
    }
  }
}
