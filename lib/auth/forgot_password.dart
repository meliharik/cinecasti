import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:movie_suggestion/auth/login.dart';
import 'package:movie_suggestion/helper/height_width.dart';
import 'package:movie_suggestion/service/auth_service.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  String? _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              FontAwesomeIcons.chevronLeft,
              color: Theme.of(context).primaryColor,
              size: 20,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _loading
                  ? LinearProgressIndicator(
                      backgroundColor: Colors.grey,
                      color: Theme.of(context).primaryColor,
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              _image,
              boslukHeight(context, 0.01),
              _sifremiUnuttumText,
              boslukHeight(context, 0.01),
              _aciklamaText,
              boslukHeight(context, 0.03),
              _emailTextField,
              boslukHeight(context, 0.03),
              _sifirlaBtn,
            ],
          ),
        ),
      ),
    );
  }

  Widget get _image => Center(
        child: SvgPicture.asset(
          'assets/svg/forgot_password.svg',
          theme: SvgTheme(
            currentColor: Theme.of(context).secondaryHeaderColor,
          ),
          height: MediaQuery.of(context).size.height * 0.2,
        ),
      );

  Widget get _sifremiUnuttumText => Text(
        'Şifreni mi unuttun?',
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.04,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget get _aciklamaText => Text(
        'Please enter your e-mail address below.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: MediaQuery.of(context).size.height * 0.02,
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
            hintText: 'Email',
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
              return 'Email alanı boş bırakılamaz!';
            } else if (!input.contains('@')) {
              return 'Girilen değer mail formatında olmalı';
            }
            return null;
          },
          onSaved: (input) {
            _email = input;
          },
        ),
      );

  Widget get _sifirlaBtn => ElevatedButton(
        onPressed: _resetPassword,
        child: const Text(
          'Şifremi Sıfırla',
        ),
        style: ElevatedButton.styleFrom(
            elevation: 5,
            fixedSize: Size(MediaQuery.of(context).size.width * 0.9,
                MediaQuery.of(context).size.height * 0.06)),
      );

  void _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      FocusScope.of(context).unfocus();

      setState(() {
        _loading = true;
      });
      try {
        await AuthService().sifremiSifirla(_email!);
        setState(() {
          _loading = false;
        });
        showModalBottomSheet(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50))),
            context: context,
            builder: (context) {
              return Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/email_sent.svg',
                    theme: SvgTheme(
                      currentColor: Theme.of(context).secondaryHeaderColor,
                    ),
                    height: MediaQuery.of(context).size.height * 0.2,
                  ),
                  _bottomSheetBasarili,
                  _bottomSheetAciklama,
                  boslukHeight(context, 0.04),
                  _tamamBtn,
                ],
              );
            });
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

  uyariGoster({hataKodu}) {
    String? hataMesaji;

    if (hataKodu == 360587416) {
      hataMesaji = "Girdiğiniz mail adresi geçersizdir.";
    } else if (hataKodu == 34618382) {
      hataMesaji = "Girdiğiniz mail kayıtlıdır.";
    } else if (hataKodu == 265778269) {
      hataMesaji = "Daha zor bir şifre tercih edin.";
    } else if (hataKodu == 505284406) {
      hataMesaji = "Bu mail adresine kayıtlı bir kullanıcı bulunmuyor.";
    } else {
      hataMesaji = "Bir hata oluştu. Birkaç dakika içinde tekrar deneyin.";
    }

    var snackBar = SnackBar(content: Text(hataMesaji));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget get _bottomSheetBasarili => Text(
        'Success!',
        style: TextStyle(
            color: const Color(0xff4B4B4B),
            fontWeight: FontWeight.w700,
            fontSize: MediaQuery.of(context).size.height * 0.03),
      );

  Widget get _bottomSheetAciklama => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(
          'We have sent a link to your email address to reset your password. If you don\'t see the email, be sure to check your spam box.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: const Color(0xff4B4B4B),
            fontWeight: FontWeight.w400,
            fontSize: MediaQuery.of(context).size.height * 0.018,
          ),
        ),
      );

  Widget get _tamamBtn => ElevatedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const LoginScreen();
        }));
      },
      style: ElevatedButton.styleFrom(
        primary: const Color(0xff6c62fe),
        elevation: 5,
      ),
      child: const Text('Tamam'));
}
