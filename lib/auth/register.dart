import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/auth/login.dart';
import 'package:movie_suggestion/auth/model/kullanici.dart';
import 'package:movie_suggestion/helper/height_width.dart';
import 'package:movie_suggestion/policy/privacy_policy.dart';
import 'package:movie_suggestion/policy/user_agreement.dart';
import 'package:movie_suggestion/screens/tab_bar_main/tabbar_main_movie.dart';
import 'package:movie_suggestion/service/analytic.dart';
import 'package:movie_suggestion/service/auth_service.dart';
import 'package:movie_suggestion/service/firestore_service.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  String? email, password, adSoyad;
  bool isObscureTextTrue = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    // internetKontrol();
  }

  @override
  void dispose() {
    _loading = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Stack(
        children: [_sayfaElemanlari, _yuklemeAnimasyonu()],
      )),
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
            boslukHeight(context, 0.01),

            // _image,
            _girisYapText,
            _devamEtText,
            boslukHeight(context, 0.02),
            _adSoyadTextField,
            boslukHeight(context, 0.02),
            _emailTextField,
            boslukHeight(context, 0.02),
            _passwordTextField,
            boslukHeight(context, 0.02),
            _sozlesmeKabulTxt,
            boslukHeight(context, 0.02),
            _signUpBtn,
            boslukHeight(context, 0.015),
            _veyaText,
            boslukHeight(context, 0.015),
            _googleSignUpBtn,
            Expanded(
              child: boslukHeight(context, 0.02),
            ),
            _girisYapTextBtn,
            boslukHeight(context, 0.05),
          ],
        ),
      );
  Widget get _girisYapText => Row(
        children: [
          boslukWidth(context, 0.05),
          Text(
            'create_account'.tr().toString(),
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MediaQuery.of(context).size.height * 0.04),
          ),
          const Expanded(child: SizedBox()),
        ],
      );

  Widget get _devamEtText => Row(
        children: [
          boslukWidth(context, 0.05),
          Text(
            'sign_up_and_join_us'.tr().toString(),
            style:
                TextStyle(fontSize: MediaQuery.of(context).size.height * 0.03),
          ),
          const Expanded(child: SizedBox()),
        ],
      );

  Widget get _adSoyadTextField => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          style: const TextStyle(fontWeight: FontWeight.w400),
          autocorrect: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            border: const OutlineInputBorder(),
            hintText: 'name_surname'.tr().toString(),
            errorStyle: const TextStyle(
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
              borderSide: const BorderSide(color: Color(0xffDA4167), width: 2),
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
              return 'name_surname_required'.tr().toString();
            } else if (input.contains(',') ||
                input.contains('.') ||
                input.contains('*')) {
              debugPrint(input.toString());
              return 'name_surname_invalid'.tr().toString();
            }
            return null;
          },
          onSaved: (input) {
            adSoyad = input;
          },
        ),
      );

  Widget get _emailTextField => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: TextFormField(
          style: const TextStyle(fontWeight: FontWeight.w400),
          autocorrect: true,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(15),
            border: const OutlineInputBorder(),
            hintText: 'email'.tr().toString(),
            hintStyle: const TextStyle(),
            errorStyle: const TextStyle(
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
              borderSide: const BorderSide(color: Color(0xffDA4167), width: 2),
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
              return 'email_required'.tr().toString();
            } else if (!input.contains('@')) {
              return 'email_invalid'.tr().toString();
            }
            return null;
          },
          onSaved: (input) {
            email = input;
          },
        ),
      );

  Widget get _passwordTextField => Padding(
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
            hintText: 'password'.tr().toString(),
            hintStyle: const TextStyle(fontWeight: FontWeight.w400),
            errorStyle: const TextStyle(
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
              return 'password_required'.tr().toString();
            } else if (input.trim().length <= 4) {
              return 'password_must_be_at_least_4_characters'.tr().toString();
            }
            return null;
          },
          onSaved: (input) {
            password = input;
          },
        ),
      );

  Widget get _sozlesmeKabulTxt => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: RichText(
          text: TextSpan(
              text: 'by_registering_you_agree_to'.tr().toString(),
              style: const TextStyle(fontWeight: FontWeight.w400),
              children: <TextSpan>[
                const TextSpan(
                  text: '  ',
                  style: TextStyle(
                      // color: Colors.white,
                      ),
                ),
                TextSpan(
                    text: 'privacy_policy'.tr().toString(),
                    style: const TextStyle(
                      color: Colors.blueAccent,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const GizlilikPolitikasi(),
                          ),
                        );
                      }),
                const TextSpan(
                  text: ' - ',
                  style: TextStyle(
                      // color: Colors.white,
                      ),
                ),
                TextSpan(
                    text: 'user_agreement'.tr().toString(),
                    style: const TextStyle(
                      color: Colors.blueAccent,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const KullanimKosullari(),
                          ),
                        );
                      }),
              ]),
        ),
      );

  Widget get _signUpBtn => ElevatedButton(
        onPressed: _hesapOlustur,
        child: Text(
          'create_account'.tr().toString(),
        ),
        style: ElevatedButton.styleFrom(
            elevation: 5,
            fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                MediaQuery.of(context).size.height * 0.06)),
      );

  Future<void> _hesapOlustur() async {
    var _formState = _formKey.currentState;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (_formState!.validate()) {
      _formState.save();
      FocusScope.of(context).unfocus();
      setState(() {
        _loading = true;
      });

      if (connectivityResult != ConnectivityResult.none) {
        try {
          Kullanici? kullanici =
              await AuthService().mailIleKayit(email!, password!, adSoyad!);
          if (kullanici != null) {
            await FirebaseMessaging.instance
                .getToken()
                .whenComplete(() {})
                .then(
                  (value) => FirestoreService().kullaniciOlustur(
                      token: value.toString(),
                      id: kullanici.id,
                      email: email,
                      adSoyad: adSoyad,
                      sifre: password),
                );
          }
          AuthService().onayMailiGonder();

          AnalyticService.sendAnalyticsEvent();

          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const TabBarMainMovie()));
        } catch (hata) {
          debugPrint("hata");
          debugPrint(hata.hashCode.toString());
          debugPrint(hata.toString());

          setState(() {
            _loading = false;
          });

          uyariGoster(hataKodu: hata.hashCode);
        }
      } else {
        setState(() {
          _loading = false;
          uyariGoster(hataKodu: 0);
        });
      }
    }
  }

  // internetKontrol() async {
  //   var connectivityResult = await (Connectivity().checkConnectivity());

  //   if (connectivityResult == ConnectivityResult.none) {
  //     uyariGoster(hataKodu: 0);
  //   }
  // }

  uyariGoster({hataKodu}) {
    String? hataMesaji;

    if (hataKodu == 505284406) {
      hataMesaji = "user_not_found".tr().toString();
    } else if (hataKodu == 360587416) {
      hataMesaji = "email_invalid".tr().toString();
    } else if (hataKodu == 185768934) {
      hataMesaji = "password_incorrect".tr().toString();
    } else if (hataKodu == 446151799) {
      hataMesaji = "user_banned".tr().toString();
    } else if (hataKodu == 0) {
      hataMesaji = "check_connection".tr().toString();
    } else if (hataKodu == 34618382) {
      hataMesaji = "user_already_registered";
    } else {
      hataMesaji = "an_error_occurred".tr().toString();
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget get _veyaText => Row(
        children: [
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, right: 15),
              child: Divider(
                thickness: 2,
                color: Colors.grey,
              ),
            ),
          ),
          Text(
            'or'.tr().toString(),
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              // color: Color(0xff4B4B4B),
            ),
          ),
          const Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 15.0, right: 25),
              child: Divider(
                thickness: 2,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      );

  Widget get _googleSignUpBtn => ElevatedButton.icon(
        onPressed: _googleIleGiris,
        icon: const Icon(
          FontAwesomeIcons.google,
          color: Colors.white,
        ),
        label: Text(
          'sign_in_with_google'.tr().toString(),
        ),
        style: ElevatedButton.styleFrom(
            primary: const Color(0xffde4032),
            elevation: 5,
            fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                MediaQuery.of(context).size.height * 0.06)),
      );

  void _googleIleGiris() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    setState(() {
      _loading = true;
    });
    if (connectivityResult != ConnectivityResult.none) {
      try {
        Kullanici? kullanici = await AuthService().googleIleGiris();
        if (kullanici != null) {
          Kullanici? firestoreKullanici =
              await FirestoreService().kullaniciGetir(kullanici.id);
          if (firestoreKullanici == null) {
            await FirebaseMessaging.instance
                .getToken()
                .whenComplete(() {})
                .then(
                  (value) => FirestoreService().kullaniciOlustur(
                      token: value.toString(),
                      id: kullanici.id,
                      email: kullanici.email,
                      adSoyad: kullanici.adSoyad,
                      sifre: kullanici.sifre),
                );
          }
        }
        //AuthService().onayMailiGonder();
        AnalyticService.sendAnalyticsEvent();

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const TabBarMainMovie()));
      } catch (hata) {
        debugPrint("hata");
        debugPrint(hata.hashCode.toString());
        debugPrint(hata.toString());
        if (mounted) {
          setState(() {
            _loading = false;
          });
        }
        uyariGoster(hataKodu: hata.hashCode);
      }
    } else {
      setState(() {
        _loading = false;
      });
      uyariGoster(hataKodu: 0);
    }
  }

  Widget get _girisYapTextBtn => RichText(
        text: TextSpan(
          text: 'already_have_an_account'.tr().toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            color: Colors.white70,
          ),
          children: <TextSpan>[
            TextSpan(
                text: ' ' + 'sign_in'.tr().toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  })
          ],
        ),
      );
}
