import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetGenre {
  static List getGenreAndIcon(int id) {
    switch (id) {
      case 10759:
        return ['   Action & Adventure', FontAwesomeIcons.gun];
      case 28:
        return ['   Action', FontAwesomeIcons.gun];
      case 12:
        return ['   Adventure', FontAwesomeIcons.map];
      case 16:
        return ['   Animation', FontAwesomeIcons.dog];
      case 35:
        return ['   Comedy', FontAwesomeIcons.masksTheater];
      case 80:
        return ['   Crime', FontAwesomeIcons.handcuffs];
      case 99:
        return ['   Documentary', FontAwesomeIcons.fish];
      case 18:
        return ['   Drama', FontAwesomeIcons.heartCrack];
      case 10751:
        return ['   Family', FontAwesomeIcons.peopleRoof];
      case 10762:
        return ['   Kids', FontAwesomeIcons.baby];
      case 10763:
        return ['   News', FontAwesomeIcons.newspaper];
      case 10764:
        return ['   Reality', FontAwesomeIcons.tv];
      case 10765:
        return ['   Sci-Fi & Fantasy', EvaIcons.globe2];
      case 10766:
        return ['   Soap', FontAwesomeIcons.soap];
      case 10767:
        return ['   Talk', FontAwesomeIcons.comments];
      case 10768:
        return ['   War & Politics', FontAwesomeIcons.flagUsa];
      case 14:
        return ['   Fantasy', FontAwesomeIcons.dungeon];
      case 36:
        return ['   History', FontAwesomeIcons.landmark];
      case 27:
        return ['   Horror', FontAwesomeIcons.ghost];
      case 10402:
        return ['   Music', FontAwesomeIcons.headphones];
      case 9648:
        return ['   Mystery', FontAwesomeIcons.circleQuestion];
      case 10749:
        return ['   Romance', FontAwesomeIcons.solidHeart];
      case 878:
        return ['   Science Fiction', FontAwesomeIcons.robot];
      case 10770:
        return ['   TV Movie', FontAwesomeIcons.tv];
      case 53:
        return ['   Thriller', FontAwesomeIcons.skull];
      case 10752:
        return ['   War', FontAwesomeIcons.personMilitaryRifle];
      case 37:
        return ['   Western', FontAwesomeIcons.hatCowboy];
      default:
        return ['  ', EvaIcons.alertCircleOutline];
    }
  }
}
