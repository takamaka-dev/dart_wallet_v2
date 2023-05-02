import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

import '../../config/styles.dart';

class Restore extends StatelessWidget {
  Restore({required this.onRefresh});

  final VoidCallback onRefresh;
  String words = "";
  String walletName = "";
  String password = "";

  Future<void> _restoreWallet(context) async {
    List<String> wordList = [];
    if (words.isNotEmpty) {
      wordList = words.split(" ");
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
    Navigator.pop(context,true);

  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CupertinoButton(
            onPressed: () {
              Navigator.pop(
                  context); // Navigate back when back button is pressed
            },
            child: const Icon(Icons.arrow_back),
          ),
      Container(
          constraints: const BoxConstraints(maxWidth: 700),
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 50),
          child:Column(
          children: [
            CupertinoTextField(
              placeholder: "Words",
              onChanged: (value) => {words = value},
            ),
            CupertinoTextField(
              placeholder: "Wallet Name",
              onChanged: (value) => {walletName = value},
            ),
            CupertinoTextField(
              placeholder: "Password",
              onChanged: (value) => {password = value},
            ),
            CupertinoButton(
                color: Styles.takamakaColor,
                onPressed: () => {_restoreWallet(context)},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(CupertinoIcons.refresh),
                    SizedBox(width: 10),
                    Text('Restore Wallet'),
                  ],
                ))
        ]),
    )
    ])
    );
  }
}
