import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/tag_list/tagList.dart';
import 'package:dart_wallet_v2/screens/wallet/new_wallet_challenge_step.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("New wallet (step 1/3)",
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
                  children: [
                    Center(
                        child: Icon(
                      Icons.wallet,
                      color: Styles.takamakaColor.withOpacity(0.9),
                      size: 80,
                    )),
                    const SizedBox(height: 20),
                    TagList(
                        Globals.instance.generatedWordsPreInitWallet,
                        Colors.white,
                        MainAxisAlignment.center,
                        Styles.takamakaColor.withOpacity(0.6),
                        Colors.transparent,
                        deleteTag),
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
                            canProceed ?
                              Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                      builder: (BuildContext context) {
                                return NewWalletChallengeStep();
                              })) : print("not allowed")
                            },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.arrow_right),
                            Text(canProceed
                                ? ' Proceed'
                                : ' Please confirm the statement above to proceed!'),
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
