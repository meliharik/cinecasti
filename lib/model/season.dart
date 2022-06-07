class Season {
  String? sId;
  String? airDate;
  List<EpisodeSeason>? episodes;
  String? name;
  String? overview;
  int? id;
  String? posterPath;
  int? seasonNumber;

  Season(
      {this.sId,
      this.airDate,
      this.episodes,
      this.name,
      this.overview,
      this.id,
      this.posterPath,
      this.seasonNumber});

  Season.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    airDate = json['air_date'];
    if (json['episodes'] != null) {
      episodes = <EpisodeSeason>[];
      json['episodes'].forEach((v) {
        episodes!.add(EpisodeSeason.fromJson(v));
      });
    }
    name = json['name'];
    overview = json['overview'];
    id = json['id'];
    posterPath = json['poster_path'];
    seasonNumber = json['season_number'];
  }
}

class EpisodeSeason {
  String? airDate;
  int? episodeNumber;
  List<CrewSeason>? crew;
  List<GuestStarsSeason>? guestStars;
  int? id;
  String? name;
  String? overview;
  String? productionCode;
  int? runtime;
  int? seasonNumber;
  String? stillPath;
  double? voteAverage;
  int? voteCount;

  EpisodeSeason(
      {this.airDate,
      this.episodeNumber,
      this.crew,
      this.guestStars,
      this.id,
      this.name,
      this.overview,
      this.productionCode,
      this.runtime,
      this.seasonNumber,
      this.stillPath,
      this.voteAverage,
      this.voteCount});

  EpisodeSeason.fromJson(Map<String, dynamic> json) {
    airDate = json['air_date'];
    episodeNumber = json['episode_number'];
    if (json['crew'] != null) {
      crew = <CrewSeason>[];
      json['crew'].forEach((v) {
        crew!.add(CrewSeason.fromJson(v));
      });
    }
    if (json['guest_stars'] != null) {
      guestStars = <GuestStarsSeason>[];
      json['guest_stars'].forEach((v) {
        guestStars!.add(GuestStarsSeason.fromJson(v));
      });
    }
    id = json['id'];
    name = json['name'];
    overview = json['overview'];
    productionCode = json['production_code'];
    runtime = json['runtime'];
    seasonNumber = json['season_number'];
    stillPath = json['still_path'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }
}

class CrewSeason {
  String? job;
  String? department;
  String? creditId;
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  dynamic profilePath;

  CrewSeason(
      {this.job,
      this.department,
      this.creditId,
      this.adult,
      this.gender,
      this.id,
      this.knownForDepartment,
      this.name,
      this.originalName,
      this.popularity,
      this.profilePath});

  CrewSeason.fromJson(Map<String, dynamic> json) {
    job = json['job'];
    department = json['department'];
    creditId = json['credit_id'];
    adult = json['adult'];
    gender = json['gender'];
    id = json['id'];
    knownForDepartment = json['known_for_department'];
    name = json['name'];
    originalName = json['original_name'];
    popularity = json['popularity'];
    profilePath = json['profile_path'];
  }
}

class GuestStarsSeason {
  String? character;
  String? creditId;
  int? order;
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;

  GuestStarsSeason(
      {this.character,
      this.creditId,
      this.order,
      this.adult,
      this.gender,
      this.id,
      this.knownForDepartment,
      this.name,
      this.originalName,
      this.popularity,
      this.profilePath});

  GuestStarsSeason.fromJson(Map<String, dynamic> json) {
    character = json['character'];
    creditId = json['credit_id'];
    order = json['order'];
    adult = json['adult'];
    gender = json['gender'];
    id = json['id'];
    knownForDepartment = json['known_for_department'];
    name = json['name'];
    originalName = json['original_name'];
    popularity = json['popularity'];
    profilePath = json['profile_path'];
  }
}
