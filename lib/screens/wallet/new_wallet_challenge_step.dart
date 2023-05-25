import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

class NewWalletChallengeStep extends StatefulWidget {
  NewWalletChallengeStep(this.startWordsChallenge, {super.key});

  Map<int, String> startWordsChallenge;

  @override
  State<StatefulWidget> createState() =>
      _NewWalletChallengeStepState(startWordsChallenge);
}

class _NewWalletChallengeStepState extends State<NewWalletChallengeStep> {
  _NewWalletChallengeStepState(this.startWordsChallenge);

  Map<int, String> startWordsChallenge;

  String currentWordCheck = "";

  bool testEnded = false;

  void _initNewWalletChallengeStep() {
    setState(() async {
      if (startWordsChallenge.keys.isEmpty) {
        context.loaderOverlay.show();
        await WalletUtils.initWallet(
            'wallets',
            Globals.instance.walletName,
            dotenv.get('WALLET_EXTENSION'),
            Globals.instance.walletPassword);
        context.loaderOverlay.hide();
        testEnded = true;
      } else {
        currentWordCheck = startWordsChallenge[startWordsChallenge.keys.toList().first]!;
      }
    });
  }

  @override
  void initState() {
    _initNewWalletChallengeStep();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CupertinoPageScaffold(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                    color: Styles.takamakaColor,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        CupertinoButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Navigate back when back button is pressed
                          },
                          child:
                              const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("New wallet (step 3/3)",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    )),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
