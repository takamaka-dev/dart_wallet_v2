import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/tag_list/tagList.dart';
import 'package:dart_wallet_v2/screens/wallet/new_wallet_challenge_step.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class NewWalletSaveWordsStep extends StatefulWidget {
  const NewWalletSaveWordsStep({super.key});

  @override
  State<StatefulWidget> createState() => _NewWalletSaveWordsStepState();
}

class _NewWalletSaveWordsStepState extends State<NewWalletSaveWordsStep> {
  bool canProceed = false;

  void deleteTag(String foo) {
    return;
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
                            Text("newWalletS2".tr(),
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
                  children: [
                    Center(
                        child: Icon(
                      Icons.screen_lock_portrait_rounded,
                      color: Styles.takamakaColor.withOpacity(0.9),
                      size: 80,
                    )),
                    const SizedBox(height: 20),
                    SizedBox(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("walletCreated".tr(),
                                softWrap: true,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                maxLines: 10))),
                    const SizedBox(height: 10),
                    SizedBox(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text("wordsSaveNotice".tr(),
                                softWrap: true, maxLines: 10))),
                    const SizedBox(height: 20),
                    TagList(
                        Globals.instance.generatedWordsPreInitWallet,
                        Colors.white,
                        MainAxisAlignment.center,
                        Styles.takamakaColor.withOpacity(0.6),
                        Colors.transparent,
                        deleteTag,
                        false),
                    const SizedBox(height: 20),
                    CupertinoSwitch(
                      // This bool value toggles the switch.
                      value: canProceed,
                      activeColor: CupertinoColors.activeBlue,
                      onChanged: (bool? value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          canProceed = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton(
                        color: canProceed
                            ? Styles.takamakaColor
                            : Styles.takamakaColor.withOpacity(0.2),
                        onPressed: () => {
                              canProceed
                                  ? Navigator.of(context).push(
                                      CupertinoPageRoute<void>(
                                          builder: (BuildContext context) {
                                      Map<int, String> startWordsChallenge =
                                          WordsUtils.startWordsChallenge(
                                              int.parse(dotenv.get(
                                                  'ITERATIONS_CHALLENGE_NUMBER')),
                                              Globals.instance
                                                  .generatedWordsPreInitWallet);
                                      return NewWalletChallengeStep(
                                          startWordsChallenge);
                                    }))
                                  : print("not allowed")
                            },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.arrow_right),
                            const SizedBox(width: 5),
                            const Text('proceed').tr(),
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
