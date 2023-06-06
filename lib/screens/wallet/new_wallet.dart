import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/wallet/new_wallet_save_words_step.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

class NewWallet extends StatefulWidget {
  const NewWallet({super.key});

  @override
  State<StatefulWidget> createState() => _NewWalletState();
}

class _NewWalletState extends State<NewWallet> {
  TextEditingController controllerWalletName = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerRepassword = TextEditingController();

  bool canProceed = false;

  String password = "";
  String walletName = "";

  bool errorWalletName = false;
  bool errorPassword = false;
  bool errorCanProceed = false;

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
                            Text("newWalletS1".tr(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    )),
              ),
              Container(
                padding: const EdgeInsets.all(20),
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
                    Text(
                        style: TextStyle(
                            fontSize: 25, color: Colors.grey.shade600),
                        "addNewWallet".tr()),
                    errorWalletName
                        ? Column(
                            children: [
                              Text("insertWalletNameProceed".tr(),
                                  style: TextStyle(
                                      color: Colors.red.withOpacity(0.8))),
                              const SizedBox(height: 20)
                            ],
                          )
                        : const Text(""),
                    errorCanProceed
                        ? Column(
                            children: [
                              Text("acceptLicence".tr(),
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Colors.red.withOpacity(0.8))),
                              const SizedBox(height: 20)
                            ],
                          )
                        : const Text(""),
                    CupertinoTextField(
                      textAlign: TextAlign.center,
                      placeholder: "walletName".tr(),
                      controller: controllerWalletName,
                      onChanged: (value) => {
                        setState(() {
                          errorWalletName = false;
                        }),
                        walletName = value
                      },
                    ),
                    errorPassword
                        ? Column(children: [
                            Text("passwordMismatch".tr(),
                                style: TextStyle(
                                    color: Colors.red.withOpacity(0.8))),
                            const SizedBox(height: 20)
                          ])
                        : const Text(""),
                    CupertinoTextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      placeholder: "password".tr(),
                      controller: controllerPassword,
                      onChanged: (value) => {
                        setState(() {
                          errorPassword = false;
                        }),
                        password = value
                      },
                    ),
                    const SizedBox(height: 20),
                    CupertinoTextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      controller: controllerRepassword,
                      placeholder: "rPassword".tr(),
                      onChanged: (value) => {
                        setState(() {
                          errorPassword = false;
                        })
                      },
                    ),
                    const SizedBox(height: 20),
                    CupertinoSwitch(
                      // This bool value toggles the switch.
                      value: canProceed,
                      activeColor: CupertinoColors.activeBlue,
                      onChanged: (bool? value) {
                        // This is called when the user toggles the switch.
                        setState(() {
                          canProceed = value ?? false;
                          if(value!) {
                            errorCanProceed = false;
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                                "agreementLicence".tr(),
                                softWrap: true,
                                maxLines: 10))),
                    const SizedBox(height: 30),
                    CupertinoButton(
                        color: !canProceed || errorWalletName
                            ? Styles.takamakaColor.withOpacity(0.7)
                            : Styles.takamakaColor,
                        onPressed: () => {_openWallet(context)},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(CupertinoIcons.plus),
                            const Text(" "),
                            const Text('createWallet').tr(),
                          ],
                        )),
                    const SizedBox(height: 50)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _openWallet(BuildContext context) async {
    if (controllerWalletName.text.isEmpty) {
      setState(() {
        errorWalletName = true;
      });
      return;
    }

    if (controllerPassword.text != controllerRepassword.text ||
        controllerRepassword.text.isEmpty ||
        controllerRepassword.text.isEmpty) {
      setState(() {
        errorPassword = true;
      });
      return;
    }

    if (!canProceed) {
      setState(() {
        errorCanProceed = true;
      });
      return;
    }

    if (!errorCanProceed && !errorWalletName && !errorPassword) {
      Globals.instance.generatedWordsPreInitWallet =
          await WordsUtils.generateWords();
      Globals.instance.walletName = walletName;
      Globals.instance.walletPassword = password;
      Navigator.of(context)
          .push(CupertinoPageRoute<void>(builder: (BuildContext context) {
        return const NewWalletSaveWordsStep();
      }));
    }
  }
}
