import 'dart:typed_data';
import 'dart:ui';

import 'package:dart_wallet_v2/utils/wallet_general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:dart_wallet_v2/config/globals.dart' as globals;
import 'package:qr_flutter/qr_flutter.dart';

class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  Int8List? _bytes;

  void _getBytes(content) async {
    print(globals.words);
    final Uint8List data = await WalletUtils.testBitMap(content);
    setState(() {
      _bytes = data.buffer.asInt8List();
    });

    globals.words = await WalletUtils.generateWords();
    print(globals.words);

    String filePath = await FileSystemUtils.getFilePath('words.txt');

    print(filePath);

    FileSystemUtils.saveFile('words.txt', globals.words.join(" "));
    FileSystemUtils.readFile(dotenv.get('SEED_FILE_NAME')).then((value) => {
      print('il valore è: $value'),
      if (value == '') {
        WalletGeneralUtils.saveSeed()
      }
    });

    final qrValidationResult = QrValidator.validate(
      data: globals.generatedSeed,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    final QrCode? qrCode = qrValidationResult.qrCode;

    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: const Color(0xFF000000),
      gapless: true,
      embeddedImageStyle: null,
      embeddedImage: null,
    );

    final picData = await painter.toImageData(2048, format: ImageByteFormat.png);
    await FileSystemUtils.saveFileByte("QrCode.png", picData!);

  }

  @override
  void initState() {
    _getBytes("yzrhYG_yVL_Cswdg6tiTEx0nTKSPwcfd75J4BP2n0C4.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(globals.selectedNetwork);
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Wallet'),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [Center(
              child: _bytes == null
                  ? const CircularProgressIndicator()
                  : Image.memory(
                Uint8List.fromList(_bytes!),
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              )),
            CupertinoTextField(
              padding: EdgeInsets.only(left: 65, top: 10, right: 6, bottom: 10),
              prefix: Text('Wallet Address'),
              placeholder: 'Required',
              onChanged: (value) => _getBytes(value)
            )
          ],
        ));
  }


}