import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/wallet/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessSplashPage extends StatelessWidget {
  SuccessSplashPage(this.sith, {super.key});

  String sith;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CupertinoPageScaffold(
        child: Center(
          child: Column(
            children: [
              Icon(CupertinoIcons.hand_thumbsup_fill, color: Styles.takamakaColor.withOpacity(0.9)),
              const SizedBox(height: 30),
              const Text("The transaction has been successfully verified!"),
              const SizedBox(height: 10),
              const Text("SITH"),
              SelectableText(sith),
              const SizedBox(height: 30),
              CupertinoButton(
                  color: Styles.takamakaColor,
                  padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),

                  onPressed: () => {
                    Navigator.of(context).push(
                        CupertinoPageRoute<void>(builder: (BuildContext context) {
                          return const Home();
                        }))
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.home),
                      SizedBox(width: 10),
                      Text('Home'),
                    ],
                  ))
            ],
          )
        ),
      ),
    );
  }

}