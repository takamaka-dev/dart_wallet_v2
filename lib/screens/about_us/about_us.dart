/*
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  final String _url = 'https://takamaka.io/aboutus';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('About Us'),
        ),
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 700),
              padding: const EdgeInsets.fromLTRB(20, 80, 20, 50),
              child: Center(
                  child: Image.asset('images/logo.png',
                      fit: BoxFit.fill, scale: 0.5)),
            ),
            Container(
                child: Center(
                    child: Column(
              children: [
                const Text('AiliA SA', style: TextStyle(color: Colors.black)),
                const Text('Hertistrasse 25a 6300 Zug, CH',
                    style: TextStyle(color: Colors.black)),
                const Text(
                    'For more details on company registration you can visit the following link to the Zug Canton Commercial Register, by clicking the button underneath.',
                    style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
                CupertinoButton.filled(child: Text('more Infos'), onPressed: _launchURLBrowser)
              ],
            )))
          ],
        ));
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
