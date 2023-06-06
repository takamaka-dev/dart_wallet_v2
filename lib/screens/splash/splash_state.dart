import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/qr_code/qr_code.dart';
import 'package:dart_wallet_v2/screens/settings/settings.dart';
import 'package:dart_wallet_v2/screens/wallet/wallet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../about_us/about_us.dart';
import '../restore/restore.dart';
import '../wallet/home.dart';
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

  var settings = tr('settings');

  @override
  Widget build(BuildContext context) {
    // 3 <-- SEE HERE
    return CupertinoTabScaffold(

      // 2 <-- SEE HERE
      tabBar: CupertinoTabBar(
        currentIndex: 1,
        activeColor: Styles.takamakaColor,
        items: <BottomNavigationBarItem>[
          // 3 <-- SEE HERE
          const BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.question_circle), label: 'About'),
          const BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallets'),
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
            returnValue = CupertinoTabView(
                builder: (context) {
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
