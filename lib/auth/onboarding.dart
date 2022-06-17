import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movie_suggestion/auth/register.dart';
import 'package:onboarding/onboarding.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late Material materialButton;
  late int index;

  @override
  void initState() {
    super.initState();
    materialButton = _skipButton();
    index = 0;
  }

  Material _skipButton({void Function(int)? setIndex}) {
    return Material(
      borderRadius: defaultSkipButtonBorderRadius,
      color: defaultSkipButtonColor,
      child: InkWell(
        borderRadius: defaultSkipButtonBorderRadius,
        onTap: () {
          if (setIndex != null) {
            index = 2;
            setIndex(2);
          }
        },
        child: const Padding(
          padding: defaultSkipButtonPadding,
          child: Text(
            'Skip',
            style: defaultSkipButtonTextStyle,
          ),
        ),
      ),
    );
  }

  Material get _signupButton {
    return Material(
      borderRadius: defaultProceedButtonBorderRadius,
      color: defaultProceedButtonColor,
      child: InkWell(
        borderRadius: defaultProceedButtonBorderRadius,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => RegisterScreen(),
            ),
          );
        },
        child: Padding(
          padding: defaultProceedButtonPadding,
          child: Text(
            'sign_up'.tr().toString(),
            style: defaultProceedButtonTextStyle,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final onboardingPagesList = [
      PageModel(
        widget: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              width: 0.0,
              color: background,
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 45.0,
                    vertical: 90.0,
                  ),
                  child: SvgPicture.asset(
                    'assets/svg/movie_night.svg',
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Film ve Dizi İzle',
                      style: pageTitleStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'İstediğin film veya dizinin hemen detaylarını öğren.',
                      style: pageInfoStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      PageModel(
        widget: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              width: 0.0,
              color: background,
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 45.0,
                    vertical: 90.0,
                  ),
                  child: SvgPicture.asset(
                    'assets/svg/playlist.svg',
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Create Playlists',
                      style: pageTitleStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Dizi ve filmlerini playlistlerine ekle.',
                      style: pageInfoStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      PageModel(
        widget: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              width: 0.0,
              color: background,
            ),
          ),
          child: SingleChildScrollView(
            controller: ScrollController(),
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 45.0,
                      vertical: 90.0,
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/all_data.svg',
                      height: MediaQuery.of(context).size.height * 0.3,
                    )),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 45.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Huge Data',
                      style: pageTitleStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 45.0, vertical: 10.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Binlerce dizi ve film seni bekliyor...',
                      style: pageInfoStyle,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ];
    return Scaffold(
      body: Onboarding(
        pages: onboardingPagesList,
        onPageChange: (int pageIndex) {
          index = pageIndex;
        },
        startPageIndex: 0,
        footerBuilder: (context, dragDistance, pagesLength, setIndex) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: background,
              border: Border.all(
                width: 0.0,
                color: background,
              ),
            ),
            child: ColoredBox(
              color: background,
              child: Padding(
                padding: const EdgeInsets.all(45.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomIndicator(
                      netDragPercent: dragDistance,
                      pagesLength: pagesLength,
                      indicator: Indicator(
                        indicatorDesign: IndicatorDesign.line(
                          lineDesign: LineDesign(
                            lineType: DesignType.line_uniform,
                          ),
                        ),
                      ),
                    ),
                    index == pagesLength - 1
                        ? _signupButton
                        : _skipButton(setIndex: setIndex)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
