/*
*/

import 'package:dart_wallet_v2/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  final String _url = 'https://takamaka.io/aboutus';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CupertinoPageScaffold(
          /*navigationBar: CupertinoNavigationBar(
            backgroundColor: Colors.white,
            middle: const Text('aboutUs').tr(),
          ),*/
          child: Container(
            constraints: const BoxConstraints(
                minHeight: 800
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/splash.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 700),
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 50),
                  child: Center(
                      child: Image.asset('images/takamaka_white.png',
                          fit: BoxFit.fill, scale: 0.5)),
                ),
                Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    // constraints: const BoxConstraints(maxWidth: 700),
                    padding: const EdgeInsets.all(30),
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text('AiliA SA',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22)),
                            const SizedBox(height: 10),
                            const Text('Hertistrasse 25a 6300 Zug, CH',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300)),
                            const SizedBox(height: 50),
                            CupertinoButton(
                                color: Styles.formBgColor,
                                onPressed: _launchURLBrowser,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.hand_thumbsup_fill, color: Colors.black.withOpacity(0.7),),
                                    const Text(style: TextStyle(color: Colors.black),'moreInfo').tr(),
                                  ],
                                )),
                            const SizedBox(height: 60)
                          ],
                        )))
              ],
            ),
          )),
    );
  }

  // Future<void> _launchUrl(String _url) async {
  //   if (!await launchUrl(_url as Uri)) {
  //     throw Exception('Could not launch $_url');
  //   }
  // }
  Future<dynamic> _launchURLBrowser() async {
    Uri url = Uri.parse(_url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
