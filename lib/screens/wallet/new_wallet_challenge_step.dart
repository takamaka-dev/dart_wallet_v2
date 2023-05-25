import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/wallet/home.dart';
import 'package:dart_wallet_v2/screens/wallet/wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:page_transition/page_transition.dart';

class NewWalletChallengeStep extends StatefulWidget {
  NewWalletChallengeStep(this.startWordsChallenge, {super.key});

  Map<int, String> startWordsChallenge;

  @override
  State<StatefulWidget> createState() =>
      _NewWalletChallengeStepState(startWordsChallenge);
}

class _NewWalletChallengeStepState extends State<NewWalletChallengeStep> {
  _NewWalletChallengeStepState(this.startWordsChallenge);

  TextEditingController controller = TextEditingController();

  bool wordMissmatch = false;

  Map<int, String> startWordsChallenge;

  String currentWordCheck = "";

  bool testEnded = false;
  int currentIndexCheckWord = 0;

  bool loadingCreationWallet = false;

  void _initNewWalletChallengeStep() {
    setState(() {
      if (startWordsChallenge.keys.isEmpty) {
        setState(() {
          loadingCreationWallet = true;
        });
        testEnded = true;
      } else {
        currentIndexCheckWord = startWordsChallenge.keys.toList().first;
        currentWordCheck = startWordsChallenge[currentIndexCheckWord]!;
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
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children:
                        testEnded ? renderSuccessPage() : renderCheckPage()),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> renderSuccessPage() {
    context.loaderOverlay.show();
    WalletUtils.initWallet('wallets', Globals.instance.walletName,
        dotenv.get('WALLET_EXTENSION'), Globals.instance.walletPassword);
    context.loaderOverlay.hide();

    return [
      Center(
          child: Icon(
            CupertinoIcons.smiley,
            color: Styles.takamakaColor.withOpacity(0.9),
            size: 80,
          )),
      const SizedBox(height: 20),
      const SizedBox(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "Your wallet has been created properly!",
                  softWrap: true,
                  maxLines: 10))),
      const SizedBox(height: 20),
      CupertinoButton(
          color: Styles.takamakaColor,
          onPressed: () => {
            Navigator.of(context).push(CupertinoPageRoute<void>(
                builder: (BuildContext context) {
                  return const Home();
                }))
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.arrow_right),
              SizedBox(width: 5),
              Text('Proceed'),
            ],
          ))
    ];
  }

  List<Widget> renderCheckPage() {
    return [
      Center(
          child: Icon(
        Icons.checklist_rtl_rounded,
        color: Styles.takamakaColor.withOpacity(0.9),
        size: 80,
      )),
      const SizedBox(height: 20),
      const SizedBox(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text("Well... now let's check.!!",
                  softWrap: true,
                  style: TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 10))),
      const SizedBox(height: 10),
      const SizedBox(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "After you have saved the 25 words let's check whether you actually did so!",
                  softWrap: true,
                  maxLines: 10))),
      const SizedBox(height: 40),
      const SizedBox(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "Now you will have to write the words that will be required of you.",
                  softWrap: true,
                  maxLines: 10))),
      const SizedBox(height: 20),
      SizedBox(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "Write the word at index n. ${currentIndexCheckWord + 1}",
                  softWrap: true,
                  maxLines: 10))),
      const SizedBox(height: 20),
      wordMissmatch
          ? Column(children: [
              Text("Error, please try again!",
                  style: TextStyle(
                      color: Colors.red.withOpacity(0.8), fontSize: 14)),
              const SizedBox(height: 10)
            ])
          : const Text(""),
      CupertinoTextField(
        placeholder: "Type here check word",
        controller: controller,
      ),
      const SizedBox(height: 20),
      loadingCreationWallet ? const CircularProgressIndicator() : CupertinoButton(
          color: Styles.takamakaColor,
          onPressed: () => {
                if (controller.text == currentWordCheck)
                  {
                    startWordsChallenge.remove(currentIndexCheckWord),
                    Navigator.of(context).push(CupertinoPageRoute<void>(
                        builder: (BuildContext context) {
                      return NewWalletChallengeStep(startWordsChallenge);
                    }))
                  }
                else
                  {
                    setState(() {
                      wordMissmatch = true;
                    })
                  }
              },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(CupertinoIcons.arrow_right),
              SizedBox(width: 5),
              Text('Proceed'),
            ],
          ))
    ];
  }
}
