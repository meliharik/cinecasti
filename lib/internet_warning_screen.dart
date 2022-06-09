import 'package:flutter/material.dart';
import 'package:movie_suggestion/helper/height_width.dart';
import 'package:movie_suggestion/yonlendirme.dart';

class InternetWarningPage extends StatelessWidget {
  const InternetWarningPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            centerTitle: true,
            automaticallyImplyLeading: false,
            title: const Text('CineCasti')),
        body: SingleChildScrollView(
          child: Column(
            children: [
              boslukHeight(context, 0.08),
              // _lottieAnimation(context),
              boslukHeight(context, 0.05),
              _baslik(context),
              boslukHeight(context, 0.02),
              _aciklamaText(context),
              boslukHeight(context, 0.05),
              _yenidenDeneBtn(context),
            ],
          ),
        ));
  }

  // Widget _lottieAnimation(BuildContext context) {
  //   return Center(
  //     child: Lottie.asset('assets/lottie/no_internet.json',
  //         frameRate: FrameRate(60),
  //         repeat: true,
  //         height: MediaQuery.of(context).size.height * 0.3),
  //   );
  // }

  Widget _baslik(BuildContext context) {
    return Row(
      children: [
        boslukWidth(context, 0.04),
        Text(
          'Ooops!',
          textAlign: TextAlign.start,
          overflow: TextOverflow.clip,
          style: TextStyle(
            fontFamily: 'Manrope',
            fontWeight: FontWeight.w800,
            fontSize: MediaQuery.of(context).size.height * 0.04,
            // color: const Color(0xff252745),
          ),
        ),
        boslukWidth(context, 0.04)
      ],
    );
  }

  Widget _aciklamaText(BuildContext context) {
    return Row(
      children: [
        boslukWidth(context, 0.04),
        Expanded(
          child: Text(
            'You are not connected to the internet. Please check your connection.',
            textAlign: TextAlign.start,
            overflow: TextOverflow.clip,
            style: TextStyle(
              fontFamily: 'Manrope',
              fontWeight: FontWeight.w600,
              fontSize: MediaQuery.of(context).size.height * 0.025,
              // color: const Color(0xff252745).withOpacity(0.7),
            ),
          ),
        ),
        boslukWidth(context, 0.04),
      ],
    );
  }

  Widget _yenidenDeneBtn(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Yonlendirme(),
              ));
        },
        style: ElevatedButton.styleFrom(
          elevation: 10,
          primary: Theme.of(context).primaryColor,
        ),
        child: const Text('Refresh'));
  }
}
