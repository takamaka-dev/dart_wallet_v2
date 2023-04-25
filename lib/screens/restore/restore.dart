import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

import '../../config/styles.dart';

class Restore extends StatelessWidget {
  String words = "";
  String walletName = "";
  String password = "";

  Restore({super.key});

  Future<void> _restoreWallet() async {
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

    String tkmAddressResult = "";
    String crcResult = "";

    WalletUtils.getNewKeypairED25519(seed).then((keypair) async => {
          tkmAddressResult = await WalletUtils.getTakamakaAddress(keypair),
          crcResult = await WalletUtils.getCrc32(keypair)
        });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Column(
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
              onPressed: _restoreWallet,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(CupertinoIcons.refresh),
                  SizedBox(width: 10),
                  Text('Restore Wallet'),
                ],
              ))
        ],
      ),
    );
  }
}
