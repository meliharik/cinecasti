import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/auth/model/kullanici.dart';
import 'package:movie_suggestion/policy/privacy_policy.dart';
import 'package:movie_suggestion/policy/user_agreement.dart';

class PoliciesScreen extends ConsumerStatefulWidget {
  const PoliciesScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PoliciesScreenState();
}

class _PoliciesScreenState extends ConsumerState<PoliciesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(FontAwesomeIcons.angleLeft),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios),
            title: Text('privacy_policy'.tr().toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GizlilikPolitikasi(),
                ),
              );
            },
          ),
          ListTile(
            trailing: Icon(Icons.arrow_forward_ios),
            title: Text('user_agreement'.tr().toString()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KullanimKosullari(),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
