import 'package:eva_icons_flutter/eva_icons_flutter.dart';

class GetGenre {
  static List getGenreAndIcon(int id) {
    switch (id) {
      case 28:
        return [' Action', EvaIcons.alertTriangleOutline];
      case 12:
        return [' Adventure', EvaIcons.activityOutline];
      case 16:
        return [' Animation', EvaIcons.filmOutline];
      case 35:
        return [' Comedy', EvaIcons.headphonesOutline];
      case 80:
        return [' Crime', EvaIcons.alertCircleOutline];
      case 99:
        return [' Documentary', EvaIcons.fileTextOutline];
      case 18:
        return [' Drama', EvaIcons.headphonesOutline];
      case 10751:
        return [' Family', EvaIcons.peopleOutline];
      case 14:
        return [' Fantasy', EvaIcons.starOutline];
      case 36:
        return [' History', EvaIcons.clockOutline];
      case 27:
        return [' Horror', EvaIcons.alertCircleOutline];
      case 10402:
        return [' Music', EvaIcons.musicOutline];
      case 9648:
        return [' Mystery', EvaIcons.questionMarkCircleOutline];
      case 10749:
        return [' Romance', EvaIcons.heartOutline];
      case 878:
        return [' Science Fiction', EvaIcons.flagOutline];
      case 10770:
        return [' TV Movie', EvaIcons.tvOutline];
      case 53:
        return [' Thriller', EvaIcons.flashOutline];
      case 10752:
        return [' War', EvaIcons.shieldOutline];
      case 37:
        return [' Western', EvaIcons.shieldOutline];
      default:
        return [' ', EvaIcons.alertCircleOutline];
    }
  }
}
