import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:movie_suggestion/auth/login.dart';
import 'package:movie_suggestion/auth/model/kullanici.dart';
import 'package:movie_suggestion/internet_warning_screen.dart';
import 'package:movie_suggestion/screens/tab_bar_main/tabbar_main_movie.dart';
import 'package:movie_suggestion/service/auth_service.dart';

class Yonlendirme extends StatefulWidget {
  const Yonlendirme({Key? key}) : super(key: key);

  @override
  _YonlendirmeState createState() => _YonlendirmeState();
}

class _YonlendirmeState extends State<Yonlendirme> {
  bool interneteBagliMi = true;
  @override
  void initState() {
    super.initState();
    internetKontrol();
  }

  @override
  Widget build(BuildContext context) {
    // final _yetkilendirmeServisi =
    //     Provider.of<AuthService>(context, listen: false);

    return StreamBuilder(
      stream: AuthService().durumTakipcisi,
      builder: (context, snapshot) {
        if (interneteBagliMi == false) {
          return const InternetWarningPage();
        } else {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(body: _yuklemeAnimasyonu());
          }
          if (snapshot.hasData) {
            Kullanici? aktifKullanici = snapshot.data as Kullanici?;
            AuthService().aktifKullaniciId = aktifKullanici!.id;

            return const TabBarMainMovie();
          } else {
            return const LoginScreen();
          }
        }
      },
    );
  }

  Widget _yuklemeAnimasyonu() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.black.withOpacity(0.5),
      child: const Center(child: Center(child: CircularProgressIndicator())),
    );
  }

  Future internetKontrol() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    debugPrint(connectivityResult.toString());
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        interneteBagliMi = false;
      });
    } else if (connectivityResult != ConnectivityResult.none) {
      interneteBagliMi = true;
    }
  }
}
