class TvSerie {
  List<CastTvSeries>? cast;
  List<CrewTvSeries>? crew;
  int? id;

  TvSerie({this.cast, this.crew, this.id});

  TvSerie.fromJson(Map<String, dynamic> json) {
    if (json['cast'] != null) {
      cast = <CastTvSeries>[];
      json['cast'].forEach((v) {
        cast!.add(CastTvSeries.fromJson(v));
      });
    }
    if (json['crew'] != null) {
      crew = <CrewTvSeries>[];
      json['crew'].forEach((v) {
        crew!.add(CrewTvSeries.fromJson(v));
      });
    }
    id = json['id'];
  }
}

class CastTvSeries {
  double? voteAverage;
  String? originalName;
  List<String>? originCountry;
  int? id;
  String? backdropPath;
  String? name;
  List<int>? genreIds;
  String? originalLanguage;
  int? voteCount;
  String? firstAirDate;
  String? posterPath;
  String? overview;
  double? popularity;
  String? character;
  String? creditId;
  int? episodeCount;

  CastTvSeries(
      {this.voteAverage,
      this.originalName,
      this.originCountry,
      this.id,
      this.backdropPath,
      this.name,
      this.genreIds,
      this.originalLanguage,
      this.voteCount,
      this.firstAirDate,
      this.posterPath,
      this.overview,
      this.popularity,
      this.character,
      this.creditId,
      this.episodeCount});

  CastTvSeries.fromJson(Map<String, dynamic> json) {
    voteAverage = json['vote_average'];
    originalName = json['original_name'];
    originCountry = json['origin_country'].cast<String>();
    id = json['id'];
    backdropPath = json['backdrop_path'];
    name = json['name'];
    genreIds = json['genre_ids'].cast<int>();
    originalLanguage = json['original_language'];
    voteCount = json['vote_count'];
    firstAirDate = json['first_air_date'];
    posterPath = json['poster_path'];
    overview = json['overview'];
    popularity = json['popularity'];
    character = json['character'];
    creditId = json['credit_id'];
    episodeCount = json['episode_count'];
  }
}

class CrewTvSeries {
  String? firstAirDate;
  double? voteAverage;
  String? overview;
  int? id;
  int? voteCount;
  String? backdropPath;
  String? posterPath;
  String? originalName;
  List<String>? originCountry;
  String? originalLanguage;
  List<int>? genreIds;
  String? name;
  double? popularity;
  String? creditId;
  String? department;
  int? episodeCount;
  String? job;

  CrewTvSeries(
      {this.firstAirDate,
      this.voteAverage,
      this.overview,
      this.id,
      this.voteCount,
      this.backdropPath,
      this.posterPath,
      this.originalName,
      this.originCountry,
      this.originalLanguage,
      this.genreIds,
      this.name,
      this.popularity,
      this.creditId,
      this.department,
      this.episodeCount,
      this.job});

  CrewTvSeries.fromJson(Map<String, dynamic> json) {
    firstAirDate = json['first_air_date'];
    voteAverage = json['vote_average'];
    overview = json['overview'];
    id = json['id'];
    voteCount = json['vote_count'];
    backdropPath = json['backdrop_path'];
    posterPath = json['poster_path'];
    originalName = json['original_name'];
    originCountry = json['origin_country'].cast<String>();
    originalLanguage = json['original_language'];
    genreIds = json['genre_ids'].cast<int>();
    name = json['name'];
    popularity = json['popularity'];
    creditId = json['credit_id'];
    department = json['department'];
    episodeCount = json['episode_count'];
    job = json['job'];
  }
}
