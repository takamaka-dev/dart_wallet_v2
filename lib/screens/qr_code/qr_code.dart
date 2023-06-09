import 'package:dart_wallet_v2/config/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class QrCode extends StatelessWidget {
  const QrCode(this.qrInput, {super.key});

  final String qrInput;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(child: WalletUtils.renderQrImage(qrInput)),
        const SizedBox(height: 50),
        CupertinoButton(
            color: Styles.takamakaColor,
            child: const Text('saveQr').tr(),
            onPressed: () => _saveQr)
      ],
    ));
  }

  void _saveQr(String walletName, String input) {}
}
