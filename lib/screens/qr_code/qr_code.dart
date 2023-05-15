import 'package:flutter/cupertino.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

import '../../config/styles.dart';

class QrCode extends StatelessWidget {
  const QrCode(this.qrInput, {super.key});

  final String qrInput;


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Center(
                    child: WalletUtils.renderQrImage(qrInput)
                ),
                const SizedBox(height: 50),
                CupertinoButton(
                    color: Styles.takamakaColor,
                    child: Text("Save qr"),
                    onPressed: () => _saveQr)

              ],
            )));
  }

  void _saveQr(String walletName, String input) {
    print(walletName);
    print(input);
  }
}
