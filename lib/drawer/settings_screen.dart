import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_suggestion/data/languages.dart';
import 'package:movie_suggestion/drawer/change_password.dart';
import 'package:movie_suggestion/drawer/edit_profile.dart';
import 'package:movie_suggestion/helper/ad_helper.dart';
import 'package:movie_suggestion/policy/policies.dart';
import 'package:movie_suggestion/policy/privacy_policy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  List languages = [
    'en-US',
    'de-DE',
    'ru-RU',
    'fr-FR',
    'it-IT',
    'hi-IN',
    'tr-TR',
    'es-ES',
    'pt-PT',
    'zh-CN',
    'ja-JP',
    'ko-KR',
  ];

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.getBannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint("error");
          debugPrint(error.toString());
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
  }

  @override
  void dispose() {
    _bottomBannerAd.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? Container(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(
                ad: _bottomBannerAd,
              ),
            )
          : null,
      appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.angleLeft),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('settings'.tr().toString())),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: Text('language'.tr().toString()),
              subtitle:
                  Text(GetLanguage.getLanguage(context.locale.languageCode)),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
              onTap: () {
                _showLanguageDialog();
              },
            ),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              title: Text("edit_profile".tr().toString()),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EditProfileScreen()));
              },
            ),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              title: Text("change_password".tr().toString()),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen()));
              },
            ),
            // const Divider(
            //   thickness: 2,
            // ),
            // ListTile(
            //   //TODO:translate
            //   title: Text("policies".tr().toString()),
            //   trailing: const Icon(
            //     Icons.arrow_forward_ios,
            //     size: 17,
            //   ),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => const PoliciesScreen()));
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  _showLanguageDialog() {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('select_language'.tr().toString()),
          actions: [
            TextButton(
              child: Text(
                'cancel'.tr().toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: languages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    GetLanguage.getLanguage(languages[index].substring(0, 2)),
                    style: TextStyle(
                      color: context.locale.languageCode ==
                              languages[index].substring(0, 2)
                          ? Theme.of(context).errorColor
                          : Colors.white70,
                    ),
                  ),
                  onTap: () async {
                    context.locale = Locale(languages[index].substring(0, 2),
                        languages[index].substring(3));
                    final prefs = await SharedPreferences.getInstance();

                    prefs.setString(
                        'languageCode', context.locale.languageCode);
                    debugPrint("dil: ");

                    debugPrint(prefs.getString('languageCode'));

                    Phoenix.rebirth(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
