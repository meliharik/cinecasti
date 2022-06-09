import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/data/languages.dart';
import 'package:movie_suggestion/drawer/change_password.dart';
import 'package:movie_suggestion/drawer/edit_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  List languages = [
    'tr-TR',
    'en-US',
    'ru-RU',
    'de-DE',
    'fr-FR',
    'es-ES',
    'it-IT',
    'pt-PT',
    'zh-CN',
    'ja-JP',
    'ko-KR',
    'hi-IN',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              //TODO: language picker
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
                    print("dil: ");

                    print(prefs.getString('languageCode'));

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
