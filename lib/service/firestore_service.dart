import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:movie_suggestion/auth/model/kullanici.dart';
import 'package:movie_suggestion/model/movie.dart';
import 'package:movie_suggestion/model/tv_serie.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DateTime now = DateTime.now();
  final FirebaseMessaging messaging = FirebaseMessaging.instance;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  Future<void> kullaniciOlustur(
      {id,
      email,
      adSoyad,
      token,
      fotoUrl =
          "https://firebasestorage.googleapis.com/v0/b/uludag-online-30c96.appspot.com/o/resimler%2FprofileDefault%2Fdefault_profile.png?alt=media&token=358d18e1-f9aa-448e-b3f6-5112989c5110",
      isVerified = "false",
      sifre = 'null'}) async {
    await _firestore.collection("users").doc(id).set({
      "id": id,
      "adSoyad": adSoyad,
      "email": email,
      "sifre": sifre,
      "fotoUrl": fotoUrl,
      "olusturulmaZamani": now,
      "isVerified": isVerified,
      "token": token
    });
  }

  Future<Kullanici?> kullaniciGetir(id) async {
    DocumentSnapshot doc = await _firestore.collection("users").doc(id).get();
    if (doc.exists) {
      Kullanici kullanici = Kullanici.dokumandanUret(doc);
      return kullanici;
    }
  }

  void kullaniciGuncelle(
      {String? kullaniciId, String? adSoyad, String fotoUrl = ""}) async {
    _firestore
        .collection("users")
        .doc(kullaniciId)
        .update({"adSoyad": adSoyad, "fotoUrl": fotoUrl});

    await _auth.currentUser!.updatePhotoURL(fotoUrl);
    await _auth.currentUser!.updateDisplayName(adSoyad);
  }

  void kullaniciTokenGuncelle(
      {required String kullaniciId, required String newToken}) async {
    _firestore.collection("users").doc(kullaniciId).update({"token": newToken});
  }

  void sifreGuncelle({String? kullaniciId, String? yeniSifre}) {
    _firestore
        .collection("users")
        .doc(kullaniciId)
        .update({'sifre': yeniSifre});
  }

  void dogrulamaGuncelle({String? kullaniciId, String? dogrulandiMi}) {
    _firestore
        .collection("users")
        .doc(kullaniciId)
        .update({"isVerified": dogrulandiMi});
  }

  Future<void> watchListFilmKaydet(Movie movie) async {
    await _firestore
        .collection("watchList")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .doc(movie.id.toString())
        .set({
      "id": movie.id,
      "title": movie.title,
      "original_title": movie.originalTitle,
      "poster_path": movie.posterPath,
      "backdrop_path": movie.backdropPath,
      "overview": movie.overview,
      "vote_average": movie.voteAverage,
      "release_date": movie.releaseDate,
      "imdb_id": movie.imdbId,
      "added_list_date": now,
    });
  }

  Future<void> watchListFilmSil(Movie movie) async {
    await _firestore
        .collection("watchList")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .doc(movie.id.toString())
        .delete();
  }

  Future<void> watchedListFilmKaydet(Movie movie) async {
    await _firestore
        .collection("watchedList")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .doc(movie.id.toString())
        .set({
      "id": movie.id,
      "title": movie.title,
      "original_title": movie.originalTitle,
      "poster_path": movie.posterPath,
      "backdrop_path": movie.backdropPath,
      "overview": movie.overview,
      "vote_average": movie.voteAverage,
      "release_date": movie.releaseDate,
      "imdb_id": movie.imdbId,
      "added_list_date": now,
    });
  }

  Future<void> watchedListFilmSil(Movie movie) async {
    await _firestore
        .collection("watchedList")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .doc(movie.id.toString())
        .delete();
  }

  Future<void> myCollectionFilmKaydet(Movie movie) async {
    await _firestore
        .collection("myCollection")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .doc(movie.id.toString())
        .set({
      "id": movie.id,
      "title": movie.title,
      "original_title": movie.originalTitle,
      "poster_path": movie.posterPath,
      "backdrop_path": movie.backdropPath,
      "overview": movie.overview,
      "vote_average": movie.voteAverage,
      "release_date": movie.releaseDate,
      "imdb_id": movie.imdbId,
      "added_list_date": now,
    });
  }

  Future<void> myCollectionFilmSil(Movie movie) async {
    await _firestore
        .collection("myCollection")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .doc(movie.id.toString())
        .delete();
  }

  Future<void> watchListDiziKaydet(TvSerie tvSerie) async {
    await _firestore
        .collection("watchList")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .doc(tvSerie.id.toString())
        .set({
      "id": tvSerie.id,
      "name": tvSerie.name,
      "poster_path": tvSerie.posterPath,
      "backdrop_path": tvSerie.backdropPath,
      "overview": tvSerie.overview,
      "vote_average": tvSerie.voteAverage,
      "first_air_date": tvSerie.firstAirDate,
      "added_list_date": now,
    });
  }

  Future<void> watchListDiziSil(TvSerie tvSerie) async {
    await _firestore
        .collection("watchList")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .doc(tvSerie.id.toString())
        .delete();
  }

  Future<void> watchedListDiziKaydet(TvSerie tvSerie) async {
    await _firestore
        .collection("watchedList")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .doc(tvSerie.id.toString())
        .set({
      "id": tvSerie.id,
      "name": tvSerie.name,
      "poster_path": tvSerie.posterPath,
      "backdrop_path": tvSerie.backdropPath,
      "overview": tvSerie.overview,
      "vote_average": tvSerie.voteAverage,
      "first_air_date": tvSerie.firstAirDate,
      "added_list_date": now,
    });
  }

  Future<void> watchedListDiziSil(TvSerie tvSerie) async {
    await _firestore
        .collection("watchedList")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .doc(tvSerie.id.toString())
        .delete();
  }

  Future<void> myCollectionDiziKaydet(TvSerie tvSerie) async {
    await _firestore
        .collection("myCollection")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .doc(tvSerie.id.toString())
        .set({
      "id": tvSerie.id,
      "name": tvSerie.name,
      "poster_path": tvSerie.posterPath,
      "backdrop_path": tvSerie.backdropPath,
      "overview": tvSerie.overview,
      "vote_average": tvSerie.voteAverage,
      "first_air_date": tvSerie.firstAirDate,
      "added_list_date": now,
    });
  }

  Future<void> myCollectionDiziSil(TvSerie tvSerie) async {
    await _firestore
        .collection("myCollection")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .doc(tvSerie.id.toString())
        .delete();
  }

  Future<bool> isMovieInWatchList(int id) async {
    var doc = await _firestore
        .collection("watchList")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .doc(id.toString())
        .get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isMovieInWatchedList(int id) async {
    var doc = await _firestore
        .collection("watchList")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .doc(id.toString())
        .get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isMovieInMyCollection(int id) async {
    var doc = await _firestore
        .collection("myCollection")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .doc(id.toString())
        .get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isTvSerieInWatchList(int id) async {
    var doc = await _firestore
        .collection("watchList")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .doc(id.toString())
        .get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isTvSerieInWatchedList(int id) async {
    var doc = await _firestore
        .collection("watchedList")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .doc(id.toString())
        .get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> isTvSerieInMyCollection(int id) async {
    var doc = await _firestore
        .collection("myCollection")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .doc(id.toString())
        .get();
    if (doc.exists) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Movie>> getWatchListMovies() async {
    var doc = await _firestore
        .collection("watchList")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .orderBy('added_list_date', descending: true)
        .get();
    List<Movie> movies = [];
    for (var i = 0; i < doc.docs.length; i++) {
      movies.add(Movie.fromFirebaseList(doc.docs[i].data()));
    }
    return movies;
  }

  Future<List<Movie>> getWatchedListMovies() async {
    var doc = await _firestore
        .collection("watchedList")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .orderBy('added_list_date', descending: true)
        .get();
    List<Movie> movies = [];
    for (var i = 0; i < doc.docs.length; i++) {
      movies.add(Movie.fromFirebaseList(doc.docs[i].data()));
    }
    return movies;
  }

  Future<List<Movie>> getMyCollectionMovies() async {
    var doc = await _firestore
        .collection("myCollection")
        .doc(_currentUser!.uid)
        .collection('userMovies')
        .orderBy('added_list_date', descending: true)
        .get();
    List<Movie> movies = [];
    for (var i = 0; i < doc.docs.length; i++) {
      movies.add(Movie.fromFirebaseList(doc.docs[i].data()));
    }
    return movies;
  }

  Future<List<TvSerie>> getWatchListTvSeries() async {
    var doc = await _firestore
        .collection("watchList")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .orderBy('added_list_date', descending: true)
        .get();
    List<TvSerie> tvSeries = [];
    for (var i = 0; i < doc.docs.length; i++) {
      tvSeries.add(TvSerie.fromFirebaseList(doc.docs[i].data()));
    }
    return tvSeries;
  }

  Future<List<TvSerie>> getWatchedListTvSeries() async {
    var doc = await _firestore
        .collection("watchedList")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .orderBy('added_list_date', descending: true)
        .get();
    List<TvSerie> tvSeries = [];
    for (var i = 0; i < doc.docs.length; i++) {
      tvSeries.add(TvSerie.fromFirebaseList(doc.docs[i].data()));
    }
    return tvSeries;
  }

  Future<List<TvSerie>> getMyCollectionTvSeries() async {
    var doc = await _firestore
        .collection("myCollection")
        .doc(_currentUser!.uid)
        .collection('userTvSeries')
        .orderBy('added_list_date', descending: true)
        .get();
    List<TvSerie> tvSeries = [];
    for (var i = 0; i < doc.docs.length; i++) {
      tvSeries.add(TvSerie.fromFirebaseList(doc.docs[i].data()));
    }
    return tvSeries;
  }
}
