import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/helper/height_width.dart';
import 'package:movie_suggestion/screens/tab_bar_main/tabbar_main_movie.dart';
import 'package:movie_suggestion/service/firestore_service.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  String? currentPassword;
  String? newPassword;
  bool isObscureTextTrue = true;
  bool isObscureTextTrue2 = true;
  bool _loading = false;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.angleLeft),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('change_password'.tr().toString()),
      ),
      body: Stack(
        children: [
          _yuklemeAnimasyonu(),
          _sayfaElemanlari,
        ],
      ),
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

  Widget get _sayfaElemanlari => Form(
        key: _formKey,
        child: Column(
          children: [
            boslukHeight(context, 0.04),
            _lottieAnimation,
            boslukHeight(context, 0.07),
            _mevcutSifreTextField,
            boslukHeight(context, 0.015),
            _yeniSifreTextField,
            const Expanded(
                child: SizedBox(
              child: Text(''),
            )),
            _kaydetBtn,
            boslukHeight(context, 0.05),
          ],
        ),
      );

  Widget get _lottieAnimation => Center(
        child: SvgPicture.asset(
          'assets/svg/auth.svg',
          width: MediaQuery.of(context).size.width * 0.35,
        ),
      );

  Widget get _mevcutSifreTextField => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          style: const TextStyle(fontWeight: FontWeight.w400),
          obscureText: isObscureTextTrue,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: isObscureTextTrue
                    ? const Icon(
                        FontAwesomeIcons.eyeSlash,
                      )
                    : const Icon(
                        FontAwesomeIcons.eye,
                      ),
                onPressed: () {
                  setState(() {
                    isObscureTextTrue = !isObscureTextTrue;
                  });
                },
              ),
            ),
            contentPadding: const EdgeInsets.all(15),
            border: const OutlineInputBorder(),
            hintText: 'current_password'.tr().toString(),
            hintStyle: const TextStyle(fontWeight: FontWeight.w400),
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
              borderSide: const BorderSide(color: Color(0xffEF2E5B), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 2),
            ),
          ),
          validator: (input) {
            if (input!.isEmpty) {
              return 'cant_be_empty_password'.tr().toString();
            } else if (input.trim().length <= 4) {
              return 'password_must_be_at_least_4_characters'.tr().toString();
            }
            return null;
          },
          onSaved: (input) {
            currentPassword = input;
          },
        ),
      );

  Widget get _yeniSifreTextField => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          style: const TextStyle(fontWeight: FontWeight.w400),
          obscureText: isObscureTextTrue2,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: isObscureTextTrue2
                    ? const Icon(
                        FontAwesomeIcons.eyeSlash,
                      )
                    : const Icon(
                        FontAwesomeIcons.eye,
                      ),
                onPressed: () {
                  setState(() {
                    isObscureTextTrue2 = !isObscureTextTrue2;
                  });
                },
              ),
            ),
            contentPadding: const EdgeInsets.all(15),
            border: const OutlineInputBorder(),
            hintText: 'new_password'.tr().toString(),
            hintStyle: const TextStyle(fontWeight: FontWeight.w400),
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
              borderSide: const BorderSide(color: Color(0xffEF2E5B), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey, width: 2),
            ),
          ),
          validator: (input) {
            if (input!.isEmpty) {
              return 'cant_be_empty_password'.tr().toString();
            } else if (input.trim().length <= 4) {
              return 'password_must_be_at_least_4_characters'.tr().toString();
            }
            return null;
          },
          onSaved: (input) {
            newPassword = input;
          },
        ),
      );

  Widget get _kaydetBtn => ElevatedButton(
        onPressed: _sifreDegistir,
        child: Text(
          'change'.tr().toString(),
          style: const TextStyle(),
        ),
        style: ElevatedButton.styleFrom(
            elevation: 5,
            fixedSize: Size(MediaQuery.of(context).size.width * 0.4,
                MediaQuery.of(context).size.height * 0.06)),
      );

  _sifreDegistir() async {
    var _formState = _formKey.currentState;
    if (_formState!.validate()) {
      _formState.save();
      FocusScope.of(context).unfocus();

      setState(() {
        _loading = true;
      });

      final user = FirebaseAuth.instance.currentUser;
      final cred = EmailAuthProvider.credential(
          email: user!.email as String, password: currentPassword as String);

      if (currentPassword.toString() == newPassword.toString()) {
        setState(() {
          _loading = false;
        });
        uyariGoster(hataKodu: 1);
      } else {
        try {
          await user.reauthenticateWithCredential(cred);
          try {
            await user.updatePassword(newPassword!);
            setState(() {
              _loading = false;
            });

            FirestoreService().sifreGuncelle(
                kullaniciId: FirebaseAuth.instance.currentUser!.uid,
                yeniSifre: newPassword);

            showModalBottomSheet(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                context: context,
                builder: (context) {
                  return Column(
                    children: [
                      boslukHeight(context, 0.02),
                      SvgPicture.asset('assets/svg/confirmed.svg',
                          height: MediaQuery.of(context).size.height * 0.2),
                      _bottomSheetBasarili,
                      _bottomSheetAciklama,
                      boslukHeight(context, 0.04),
                      _tamamBtn,
                    ],
                  );
                });
          } catch (error) {
            debugPrint("hata");
            debugPrint(error.hashCode.toString());
            debugPrint(error.toString());
            setState(() {
              _loading = false;
            });
            uyariGoster(hataKodu: error.hashCode);
          }
        } catch (hata) {
          debugPrint("hata");
          debugPrint(hata.hashCode.toString());
          debugPrint(hata.toString());
          setState(() {
            _loading = false;
          });
          uyariGoster(hataKodu: hata.hashCode);
        }
      }
    }
  }

  uyariGoster({hataKodu}) {
    String? hataMesaji;

    if (hataKodu == 287540269) {
      hataMesaji = "tried_too_often".tr().toString();
    } else if (hataKodu == 185768934) {
      hataMesaji = "current_password_incorrect".tr().toString();
    } else if (hataKodu == 265778269) {
      hataMesaji = "harder_password".tr().toString();
    } else if (hataKodu == 1) {
      hataMesaji = "same_password".tr().toString();
    } else {
      hataMesaji = "an_error_occurred".tr().toString();
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget get _bottomSheetBasarili => Text(
        'successfully_updated'.tr().toString(),
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.025,
          fontWeight: FontWeight.w600,
        ),
      );

  Widget get _bottomSheetAciklama => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Text(
          'password_changed'.tr().toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
          ),
        ),
      );

  Widget get _tamamBtn => ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const TabBarMainMovie();
        }));
      },
      child: Text('ok'.tr().toString(), style: const TextStyle()),
      style: ElevatedButton.styleFrom(elevation: 5));
}
