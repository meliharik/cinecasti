import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:movie_suggestion/yonlendirme.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

List languages = [
  'en-US',
  'tr-TR',
  'ru-RU',
  'de-DE',
  'fr-FR',
  'es-ES',
  'it-IT',
  'pt-PT',
  'hi-IN',
  'zh-CN',
  'ja-JP',
  'ko-KR',
];

Future<void> main() async {
  String defaultLocale = Platform.localeName; // en_US
  debugPrint("defaultLocale: " + defaultLocale);
  debugPrint(defaultLocale.substring(0, 2));

  for (var i = 0; i < languages.length; i++) {
    if (languages[i].substring(0, 2) == defaultLocale.substring(0, 2)) {
      defaultLocale = languages[i];
      break;
    } else {
      defaultLocale = languages[0];
    }
  }


  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  HttpOverrides.global = MyHttpOverrides();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('tr', 'TR'),
          Locale('ru', 'RU'),
          Locale('de', 'DE'),
          Locale('fr', 'FR'),
          Locale('es', 'ES'),
          Locale('it', 'IT'),
          Locale('pt', 'PT'),
          Locale('zh', 'CN'),
          Locale('ja', 'JP'),
          Locale('ko', 'KR'),
          Locale('hi', 'IN'),
        ],
        fallbackLocale:
            Locale(defaultLocale.substring(0, 2), defaultLocale.substring(3)),
        path: 'assets/translations',
        child: Phoenix(child: const MyApp()),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: 'CineCasti',
      debugShowCheckedModeBanner: false,
      home: const Yonlendirme(),
      theme: FlexThemeData.dark(
        scheme: FlexScheme.ebonyClay,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 20,
        appBarOpacity: 0.95,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: false,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.sanJuanBlue,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 15,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.90,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 30,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        useMaterial3: true,
        fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
