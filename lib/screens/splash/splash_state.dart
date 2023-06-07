import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/about_us/about_us.dart';
import 'package:dart_wallet_v2/screens/settings/settings.dart';
import 'package:dart_wallet_v2/screens/wallet/home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '/screens/splash/splash.dart';

class SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: CupertinoSimpleHomePage(),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}

class CupertinoSimpleHomePage extends StatefulWidget {
  const CupertinoSimpleHomePage({Key? key}) : super(key: key);

  @override
  _CupertinoSimpleHomePageState createState() =>
      _CupertinoSimpleHomePageState();
}

class _CupertinoSimpleHomePageState extends State<CupertinoSimpleHomePage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 2500,
      splashIconSize: double.infinity,
      splash: CupertinoPageScaffold(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/splash.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 600
                    ),
                      padding: const EdgeInsets.all(30),
                      child: const Image(
                          image: AssetImage('images/takamaka_white.png')),
                  ),
                  const CircularProgressIndicator(color: Colors.white),
                ],
              ))),
      nextScreen: MainScreen(),
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
    );
  }
}

class MainScreen extends StatelessWidget {
  final String settings = tr('settings');

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      // 2 <-- SEE HERE
      tabBar: CupertinoTabBar(
        currentIndex: 1,
        activeColor: Styles.takamakaColor,
        items: <BottomNavigationBarItem>[
          // 3 <-- SEE HERE
          const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.question_circle), label: 'About'),
          const BottomNavigationBarItem(
              icon: Icon(Icons.wallet), label: 'Wallets'),
          BottomNavigationBarItem(
              icon: const Icon(CupertinoIcons.settings), label: settings),
        ],
      ),
      tabBuilder: (context, index) {
        late final CupertinoTabView returnValue;
        switch (index) {
          case 0:
            returnValue = CupertinoTabView(
              builder: (context) {
                return const AboutUs();
              },
            );
            break;
          case 1:
          // 4 <-- SEE HERE
            returnValue = CupertinoTabView(builder: (context) {
              return const Home();
            });
            break;
          case 2:
            returnValue = CupertinoTabView(
              builder: (context) {
                return const Settings();
              },
            );
            break;
        }
        return returnValue;
      },
    );
  }
}
