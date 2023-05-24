import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:glass/glass.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

class NewWallet extends StatefulWidget {
  const NewWallet({super.key, required this.onRefresh});

  final VoidCallback onRefresh;

  @override
  State<StatefulWidget> createState() => _NewWalletState(onRefresh);
}

class _NewWalletState extends State<NewWallet> {
  _NewWalletState(this.onRefresh);

  TextEditingController controllerPassword = TextEditingController();
  TextEditingController controllerRepassword = TextEditingController();

  final VoidCallback onRefresh;
  String password = "";
  String walletName = "";

  bool errorPassword = false;

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
                    Text(
                        style: TextStyle(
                            fontSize: 25, color: Colors.grey.shade600),
                        "Add a new wallet"),
                    const SizedBox(height: 50),
                    CupertinoTextField(
                      textAlign: TextAlign.center,
                      placeholder: "Wallet name",
                      onChanged: (value) => {walletName = value},
                    ),
                    const SizedBox(height: 30),
                    errorPassword
                        ? Column(children: [
                            Text("The password fields do not match",
                                style: TextStyle(
                                    color: Colors.red.withOpacity(0.8))),
                            const SizedBox(height: 20)
                          ])
                        : const Text(""),
                    CupertinoTextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      placeholder: "Password",
                      controller: controllerPassword,
                      onChanged: (value) => {password = value},
                    ),
                    const SizedBox(height: 50),
                    CupertinoTextField(
                      obscureText: true,
                      textAlign: TextAlign.center,
                      controller: controllerRepassword,
                      placeholder: "Retype password",
                      onChanged: (value) => {password = value},
                    ),
                    const SizedBox(height: 50),
                    CupertinoButton(
                        color: Styles.takamakaColor,
                        onPressed: () => {_openWallet(context)},
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(CupertinoIcons.plus),
                            Text(' Create wallet'),
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

  _openWallet(BuildContext context) async {
    if (controllerPassword.text != controllerRepassword.text) {
      setState(() {
        errorPassword = true;
      });
    } else {
      context.loaderOverlay.show();
      /*await WalletUtils.initWallet(
        'wallets', walletName, dotenv.get('WALLET_EXTENSION'), password);*/

      Globals.instance.generatedWordsPreInitWallet =
          await WordsUtils.generateWords();

      onRefresh();
      context.loaderOverlay.hide();
      Navigator.pop(context, true);
    }
  }
}
