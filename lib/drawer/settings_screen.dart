import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/drawer/change_password.dart';
import 'package:movie_suggestion/drawer/edit_profile.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.angleLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ListTile(
              title:  Text('Language'),
              subtitle:  Text('English'),
              //TODO: language picker
              trailing:  Icon(
                Icons.arrow_forward_ios,
                size: 17,
              ),
            ),
            const Divider(
              thickness: 2,
            ),
            ListTile(
              title: const Text('Edit Profile'),
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
              title: const Text('Change Password'),
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
            )
          ],
        ),
      ),
    );
  }
}
