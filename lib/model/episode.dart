import 'package:movie_suggestion/model/members.dart';

class Episode {
  String? airDate;
  List<CrewEpisode>? crew;
  int? episodeNumber;
  List<GuestStar>? guestStars;
  String? name;
  String? overview;
  int? id;
  String? productionCode;
  int? runtime;
  int? seasonNumber;
  String? stillPath;
  double? voteAverage;
  int? voteCount;

  Episode(
      {this.airDate,
      this.crew,
      this.episodeNumber,
      this.guestStars,
      this.name,
      this.overview,
      this.id,
      this.productionCode,
      this.runtime,
      this.seasonNumber,
      this.stillPath,
      this.voteAverage,
      this.voteCount});

  Episode.fromJson(Map<String, dynamic> json) {
    airDate = json['air_date'];
    if (json['crew'] != null) {
      crew = <CrewEpisode>[];
      json['crew'].forEach((v) {
        crew!.add(CrewEpisode.fromJson(v));
      });
    }
    episodeNumber = json['episode_number'];
    if (json['guest_stars'] != null) {
      guestStars = <GuestStar>[];
      json['guest_stars'].forEach((v) {
        guestStars!.add(GuestStar.fromJson(v));
      });
    }
    name = json['name'];
    overview = json['overview'];
    id = json['id'];
    productionCode = json['production_code'];
    runtime = json['runtime'];
    seasonNumber = json['season_number'];
    stillPath = json['still_path'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }
}

class CrewEpisode {
  String? department;
  String? job;
  String? creditId;
  bool? adult;
  int? gender;
  int? id;
  String? knownForDepartment;
  String? name;
  String? originalName;
  double? popularity;
  String? profilePath;

  CrewEpisode(
      {this.department,
      this.job,
      this.creditId,
      this.adult,
      this.gender,
      this.id,
      this.knownForDepartment,
      this.name,
      this.originalName,
      this.popularity,
      this.profilePath});

  CrewEpisode.fromJson(Map<String, dynamic> json) {
    department = json['department'];
    job = json['job'];
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
