import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/wallet/wallet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SuccessSplashPage extends StatelessWidget {
  const SuccessSplashPage(this.sith, {super.key});

  final String sith;

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 7000,
        splash: SingleChildScrollView(
          child: Column(
            children: [
              Icon(CupertinoIcons.hand_thumbsup_fill,
                  size: 50, color: Styles.takamakaColor.withOpacity(0.9)),
              const SizedBox(height: 20),
              const Text("trxSuccessVerified").tr(),
              const SizedBox(height: 10),
              const Text("SITH"),
              const SizedBox(height: 10),
              SelectableText(sith,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black))
            ],
          ),
        ),
        nextScreen: Wallet(Globals.instance.walletName),
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.topToBottom,
        backgroundColor: Colors.white);
  }
}
