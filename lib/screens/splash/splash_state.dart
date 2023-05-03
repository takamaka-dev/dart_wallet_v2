import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/qr_code/qr_code.dart';
import 'package:dart_wallet_v2/screens/settings/settings.dart';
import 'package:dart_wallet_v2/screens/wallet/wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../about_us/about_us.dart';
import '../restore/restore.dart';
import '../wallet/home.dart';
import '/screens/splash/splash.dart';
import 'package:dart_wallet_v2/config/globals.dart' as globals;

class SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    // 1 <-- SEE HERE
    return const CupertinoApp(

      // 2 <-- SEE HERE
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
    // 3 <-- SEE HERE
    return CupertinoTabScaffold(

      // 2 <-- SEE HERE
      tabBar: CupertinoTabBar(
        currentIndex: 1,
        activeColor: Styles.takamakaColor,
        items: const <BottomNavigationBarItem>[
          // 3 <-- SEE HERE
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.question_circle), label: 'About'),
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallets'),
          BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.settings), label: 'Settings'),
          // BottomNavigationBarItem(
          //     icon: Icon(CupertinoIcons.qrcode), label: 'QRcode'),
          // BottomNavigationBarItem(
          //     icon: Icon(CupertinoIcons.arrow_3_trianglepath),
          //     label: 'Restore'),
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



            /*returnValue = CupertinoTabView(
              builder: (context) {

                return const Settings();
              },
            );*/
            break;
          // case 3:
          //   returnValue = CupertinoTabView(
          //     builder: (context) {
          //       return QrCode(globals.words.join(" "));
          //     },
          //   );
          //   break;
          // case 4:
          //   returnValue = CupertinoTabView(
          //     builder: (context) {
          //       return Restore();
          //     },
          //   );
          //   break;
        }
        return returnValue;
      },
    );
  }
}
