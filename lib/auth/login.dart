import 'package:connectivity/connectivity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/auth/forgot_password.dart';
import 'package:movie_suggestion/auth/model/kullanici.dart';
import 'package:movie_suggestion/auth/register.dart';
import 'package:movie_suggestion/helper/height_width.dart';
import 'package:movie_suggestion/screens/tab_bar_main/tabbar_main_movie.dart';
import 'package:movie_suggestion/service/auth_service.dart';
import 'package:movie_suggestion/service/firestore_service.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  String? email, password;
  bool isObscureTextTrue = true;
  bool _loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _loading = false;
    // internetKontrol();
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
            boslukHeight(context, 0.01),
            _girisYapText,
            _devamEtText,
            boslukHeight(context, 0.05),
            _emailTextField,
            boslukHeight(context, 0.02),
            _passwordTextField,
            boslukHeight(context, 0.01),
            _sifremiUnuttumBtn,
            boslukHeight(context, 0.02),
            _loginBtn,
            boslukHeight(context, 0.02),
            _veyaText,
            boslukHeight(context, 0.02),
            _googleLoginBtn,
            Expanded(
              child: boslukHeight(context, 0.02),
            ),
            _hesapOlusturText,
            boslukHeight(context, 0.05),
          ],
        ),
      );

  Widget get _girisYapText => Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          Text(
            'sign_in'.tr().toString(),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.042,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
      );

  Widget get _devamEtText => Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.05,
          ),
          Text(
            'sign_in_to_continue'.tr().toString(),
            style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.028,
            ),
          ),
          const Expanded(child: SizedBox()),
        ],
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
            // hintStyle: GoogleFonts.libreFranklin(),
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
                        // color: Color(0xff6c62fe),
                      )
                    : const Icon(
                        FontAwesomeIcons.eye,
                        // color: Color(0xff6c62fe),
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

  Widget get _sifremiUnuttumBtn => Row(
        children: [
          const Expanded(child: SizedBox()),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: Text(
                  'forgot_password'.tr().toString(),
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: MediaQuery.of(context).size.height * 0.02),
                ),
              ))
        ],
      );

  Widget get _loginBtn => ElevatedButton(
        onPressed: _girisYap,
        child: Text(
          'sign_in'.tr().toString(),
        ),
        style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
            elevation: 5,
            fixedSize: Size(
              MediaQuery.of(context).size.width * 0.9,
              MediaQuery.of(context).size.height * 0.06,
            )),
      );

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

  Widget get _googleLoginBtn => ElevatedButton.icon(
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

  void _girisYap() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    var _formState = _formKey.currentState;
    if (_formState!.validate()) {
      _formState.save();
      FocusScope.of(context).unfocus();
      setState(() {
        _loading = true;
      });

      if (connectivityResult != ConnectivityResult.none) {
        try {
          await AuthService().mailIleGiris(email!, password!);

          AuthService().onayMailiGonder();

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
        });
        uyariGoster(hataKodu: 0);
      }
    }
  }

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
                      fotoUrl: kullanici.fotoUrl),
                );
          }
        }
        //AuthService().onayMailiGonder();

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
    } else {
      hataMesaji = "an_error_occurred".tr().toString();
    }

    // 474761051 The service is currently unavailable. This is a most likely a transient condition and may be corrected by retrying with a backoff.

    var snackBar = SnackBar(content: Text(hataMesaji));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget get _hesapOlusturText => RichText(
        text: TextSpan(
            text: 'dont_have_an_account'.tr().toString(),
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w400,
              // color: const Color(0xff4B4B4B),
            ),
            children: <TextSpan>[
              TextSpan(
                  text: ' ',
                  style: const TextStyle(
                    // color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    }),
              TextSpan(
                  text: 'create_account'.tr().toString(),
                  style: const TextStyle(
                    // color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    })
            ]),
      );
}
