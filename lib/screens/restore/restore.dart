import 'package:dart_wallet_v2/config/globals.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:glass/glass.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

import '../../config/styles.dart';

class Restore extends StatelessWidget {
  Restore({required this.onRefresh});

  final VoidCallback onRefresh;
  String walletName = "";
  String password = "";

  Future<void> _restoreWallet(context) async {
    context.loaderOverlay.show();
    List<String> wordList = [];
    if (Globals.instance.restoreNewWalletsWords.isNotEmpty) {
      wordList = Globals.instance.restoreNewWalletsWords;
    } else {
      throw Error();
    }
    if (walletName.isEmpty || password.isEmpty) {
      throw Error();
    }
    String seed = await WalletUtils.importFromKeyWords(
        wordList,
        dotenv.get('WALLET_FOLDER'),
        walletName,
        dotenv.get('WALLET_EXTENSION'),
        password);

    await WalletUtils.getNewKeypairED25519(seed);

    onRefresh();
    context.loaderOverlay.hide();
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
                    child: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Restore wallet (2/2)",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              )),
        ),
        Container(
          constraints: const BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.fromLTRB(100, 80, 100, 50),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                    child: Icon(
                  CupertinoIcons.arrow_up_bin,
                  color: Styles.takamakaColor.withOpacity(0.7),
                  size: 60,
                )),
                const SizedBox(height: 30),
                Text(
                    style: TextStyle(fontSize: 25, color: Colors.grey.shade600),
                    "Please choose a name and a password below"),
                const SizedBox(height: 30),

                CupertinoTextField(
                  placeholder: "Wallet Name",
                  onChanged: (value) => {walletName = value},
                ),
                const SizedBox(height: 30),
                CupertinoTextField(
                  obscureText: true,
                  placeholder: "Password",
                  onChanged: (value) => {password = value},
                ),
                const SizedBox(height: 30),
                CupertinoButton(
                    color: Styles.takamakaColor,
                    onPressed: () => {_restoreWallet(context)},
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.refresh),
                        SizedBox(width: 10),
                        Text('Restore Wallet'),
                      ],
                    ))
              ]),
        )
      ],
    )));
  }
}
