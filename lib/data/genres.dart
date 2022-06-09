import 'package:easy_localization/easy_localization.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class GetGenre {
  static List getGenreAndIcon(int id, BuildContext context) {
    switch (id) {
      case 10759:
        return ['action_and_adventure'.tr().toString(), FontAwesomeIcons.gun];
      case 28:
        return ['action'.tr().toString(), FontAwesomeIcons.gun];
      case 12:
        return ['adventure'.tr().toString(), FontAwesomeIcons.map];
      case 16:
        return ['animation'.tr().toString(), FontAwesomeIcons.dog];
      case 35:
        return ['comedy'.tr().toString(), FontAwesomeIcons.masksTheater];
      case 80:
        return ['crime'.tr().toString(), FontAwesomeIcons.handcuffs];
      case 99:
        return ['documentary'.tr().toString(), FontAwesomeIcons.fish];
      case 18:
        return ['drama'.tr().toString(), FontAwesomeIcons.heartCrack];
      case 10751:
        return ['family'.tr().toString(), FontAwesomeIcons.peopleRoof];
      case 10762:
        return ['kids'.tr().toString(), FontAwesomeIcons.baby];
      case 10763:
        return ['news'.tr().toString(), FontAwesomeIcons.newspaper];
      case 10764:
        return ['reality'.tr().toString(), FontAwesomeIcons.tv];
      case 10765:
        return ['sci-Fi_and_fantasy'.tr().toString(), EvaIcons.globe2];
      case 10766:
        return ['soap'.tr().toString(), FontAwesomeIcons.soap];
      case 10767:
        return ['talk'.tr().toString(), FontAwesomeIcons.comments];
      case 10768:
        return ['war_and_politics'.tr().toString(), FontAwesomeIcons.flagUsa];
      case 14:
        return ['fantasy'.tr().toString(), FontAwesomeIcons.dungeon];
      case 36:
        return ['history'.tr().toString(), FontAwesomeIcons.landmark];
      case 27:
        return ['horror'.tr().toString(), FontAwesomeIcons.ghost];
      case 10402:
        return ['music'.tr().toString(), FontAwesomeIcons.headphones];
      case 9648:
        return ['mystery'.tr().toString(), FontAwesomeIcons.circleQuestion];
      case 10749:
        return ['romance'.tr().toString(), FontAwesomeIcons.solidHeart];
      case 878:
        return ['sci-fi'.tr().toString(), FontAwesomeIcons.robot];
      case 10770:
        return ['tv_serie'.tr().toString(), FontAwesomeIcons.tv];
      case 53:
        return ['thriller'.tr().toString(), FontAwesomeIcons.skull];
      case 10752:
        return ['war'.tr().toString(), FontAwesomeIcons.personMilitaryRifle];
      case 37:
        return ['western'.tr().toString(), FontAwesomeIcons.hatCowboy];
      default:
        return ['null'.tr().toString(), EvaIcons.alertCircleOutline];
    }
  }
}
