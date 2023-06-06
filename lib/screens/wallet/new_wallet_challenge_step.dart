import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/wallet/home.dart';
import 'package:easy_localization/easy_localization.dart';
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("newWalletS3".tr(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white)),
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
      SizedBox(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "walletReallyCreated".tr(),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.arrow_right),
              const SizedBox(width: 5),
              const Text('proceed').tr(),
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
      SizedBox(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text("letsCheck".tr(),
                  softWrap: true,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 10))),
      const SizedBox(height: 10),
      SizedBox(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "letsCheck2".tr(),
                  softWrap: true,
                  maxLines: 10))),
      const SizedBox(height: 40),
      SizedBox(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "letsCheck3".tr(),
                  softWrap: true,
                  maxLines: 10))),
      const SizedBox(height: 20),
      SizedBox(
          child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                  "${"writeWordAtIndex".tr()} ${currentIndexCheckWord + 1}",
                  softWrap: true,
                  maxLines: 10))),
      const SizedBox(height: 20),
      wordMissmatch
          ? Column(children: [
              Text("genericError2".tr(),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(CupertinoIcons.arrow_right),
              const SizedBox(width: 5),
              const Text('proceed').tr(),
            ],
          ))
    ];
  }
}
