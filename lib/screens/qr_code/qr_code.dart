import 'package:flutter/cupertino.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatelessWidget {
  const QrCode(this.qrinput, {super.key});

  final String qrinput;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Center(
          child: WalletUtils.renderQrImage(qrinput)
        )
      ],
    ));
  }
}
