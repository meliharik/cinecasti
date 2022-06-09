import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:movie_suggestion/helper/height_width.dart';
import 'package:movie_suggestion/screens/tab_bar_main/tabbar_main_movie.dart';
import 'package:movie_suggestion/service/firestore_service.dart';
import 'package:movie_suggestion/service/storage_service.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _adSoyad;
  File? _secilmisFoto;
  bool _loading = false;
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  void dispose() {
    _secilmisFoto = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.angleLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile'),
      ),
      body: Stack(children: [
        _sayfaElemanlari(),
        _yuklemeAnimasyonu(),
      ]),
    );
  }

  Widget _yuklemeAnimasyonu() {
    if (_loading) {
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.black.withOpacity(0.5),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Container();
  }

  Widget _sayfaElemanlari() {
    return Column(
      children: [
        boslukHeight(context, 0.04),
        _profilFoto,
        _fotoyuDegistirText,
        boslukHeight(context, 0.04),
        _adSoyadTextField,
        boslukHeight(context, 0.03),
        _emailTextField,
        boslukHeight(context, 0.005),
        _emailDegismezText,
        const Expanded(
            child: SizedBox(
          child: Text(''),
        )),
        _kaydetBtn,
        boslukHeight(context, 0.05),
      ],
    );
  }

  Widget get _profilFoto => Center(
        child: InkWell(
          onTap: _galeridenSec,
          child: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: _fotoGetir(),
            radius: 50.0,
          ),
        ),
      );

  _fotoGetir() {
    if (_secilmisFoto == null) {
      return NetworkImage(_currentUser!.photoURL.toString());
    } else {
      return FileImage(_secilmisFoto!);
    }
  }

  _galeridenSec() async {
    var image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 600,
        imageQuality: 80);
    setState(() {
      _secilmisFoto = File(image!.path);
    });
  }

  Widget get _fotoyuDegistirText => TextButton(
      onPressed: _galeridenSec,
      child: const Text(
        'Change Profile Picture',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ));

  Widget get _adSoyadTextField => Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            autocorrect: true,
            style: const TextStyle(fontWeight: FontWeight.w400),
            initialValue: _currentUser!.displayName,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.all(15),
              border: const OutlineInputBorder(),
              hintText: 'Ad Soyad',
              hintStyle: const TextStyle(),
              errorStyle: const TextStyle(
                fontFamily: 'Manrope',
                fontWeight: FontWeight.w600,
                color: Color(0xffEF2E5B),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    BorderSide(color: Theme.of(context).primaryColor, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xffDA4167), width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 2),
              ),
            ),
            validator: (input) {
              if (input!.isEmpty) {
                debugPrint(input.toString());
                return 'Ad Soyad alanı boş bırakılamaz!';
              } else if (input.contains(',') ||
                  input.contains('.') ||
                  input.contains('*')) {
                debugPrint(input.toString());
                return 'Lütfen noktalama işareti kullanmayın.';
              }
              return null;
            },
            onSaved: (girilenDeger) {
              _adSoyad = girilenDeger;
            },
          ),
        ),
      );

  Widget get _emailTextField => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: TextFormField(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          enableInteractiveSelection: false,
          readOnly: true,
          style: const TextStyle(fontWeight: FontWeight.w400),
          initialValue: _currentUser!.email,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            border: const OutlineInputBorder(),
            hintText: 'Email',
            hintStyle: const TextStyle(),
            errorStyle: const TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              color: Color(0xffEF2E5B),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xffDA4167), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 2),
            ),
          ),
        ),
      );

  Widget get _emailDegismezText => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          'Email replacement is currently inactive.',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: MediaQuery.of(context).size.height * 0.02),
        ),
      );

  Widget get _kaydetBtn => ElevatedButton(
        onPressed: _kaydet,
        child: const Text(
          'Save',
          style: TextStyle(),
        ),
        style: ElevatedButton.styleFrom(
            elevation: 5,
            fixedSize: Size(MediaQuery.of(context).size.width * 0.4,
                MediaQuery.of(context).size.height * 0.06)),
      );

  _kaydet() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();

      String profilFotoUrl;
      if (_secilmisFoto == null) {
        profilFotoUrl = _currentUser!.photoURL.toString();
      } else {
        profilFotoUrl = await StorageService().profilResmiYukle(_secilmisFoto!);
      }

      FirestoreService().kullaniciGuncelle(
          kullaniciId: _currentUser!.uid,
          adSoyad: _adSoyad,
          fotoUrl: profilFotoUrl);

      setState(() {
        _loading = false;
      });

      showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(50), topRight: Radius.circular(50))),
        context: context,
        builder: (context) {
          return Column(
            children: [
              boslukHeight(context, 0.04),
              SvgPicture.asset(
                'assets/svg/confirmed.svg',
                height: MediaQuery.of(context).size.height * 0.2,
              ),
              boslukHeight(context, 0.01),
              _bottomSheetBasarili,
              _bottomSheetAciklama,
              boslukHeight(context, 0.04),
              _tamamBtn,
            ],
          );
        },
      );
    }
  }

  Widget get _bottomSheetBasarili => Text(
        'Successfully updated!',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.03,
          fontWeight: FontWeight.w500,
        ),
      );

  Widget get _bottomSheetAciklama => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Text(
          'Your profile looks much better now.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: MediaQuery.of(context).size.height * 0.02,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  Widget get _tamamBtn => ElevatedButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TabBarMainMovie(),
            ));
      },
      style: ElevatedButton.styleFrom(
          elevation: 5,
          fixedSize: Size(MediaQuery.of(context).size.width * 0.6,
              MediaQuery.of(context).size.height * 0.06)),
      child: const Text('Ok'));
}
