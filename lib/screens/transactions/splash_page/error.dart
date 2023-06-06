import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/screens/wallet/wallet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ErrorSplashPage extends StatelessWidget {
  const ErrorSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        duration: 6000,
        splash: SingleChildScrollView(
          child: Column(
            children: [
              Icon(CupertinoIcons.hand_thumbsdown_fill,
                  size: 50, color: Colors.red.withOpacity(0.7)),
              const SizedBox(height: 20),
              const Text("trxNotVerified").tr()
            ],
          ),
        ),
        nextScreen: Wallet(Globals.instance.walletName),
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.topToBottom,
        backgroundColor: Colors.white);
  }

}