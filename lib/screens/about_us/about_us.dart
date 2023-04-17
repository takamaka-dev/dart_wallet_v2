/*
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

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
              padding: const EdgeInsets.fromLTRB(50, 100, 50, 30),
              child: Center(child: Image.asset('images/logo.png', fit: BoxFit.fill, scale: 0.5)),
            ),
            Container(
              child: const Center(child: Text('ciao', style: TextStyle(color: Colors.black)))
            )
          ],
        ));
  }
}
