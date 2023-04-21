import 'dart:typed_data';
import 'dart:ui';

import 'package:dart_wallet_v2/config/styles.dart';
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
  String? walletAddress;
  String? crc;

  Future<bool> _getBytes() async {

    setState(() {
      crc = null;
      walletAddress = null;
      _bytes = null;
    });

    print(globals.words);
    Uint8List data;


    globals.words = await WalletUtils.generateWords();
    print(globals.words);

    String filePath = await FileSystemUtils.getFilePath('words.txt');

    print(filePath);

    String tkmAddressResult = "";
    String crcResult = "";

    FileSystemUtils.saveFile('words.txt', globals.words.join(" "));
    FileSystemUtils.readFile(dotenv.get('SEED_FILE_NAME')).then((seed) => {
          print('il valore è: $seed'),
          if (seed.isEmpty)
            {
              WalletGeneralUtils.saveSeed(),
            }
          else
            {
              WalletUtils.getNewKeypairED25519(seed).then((keypair) async => {
                    tkmAddressResult = await WalletUtils.getTakamakaAddress(keypair),
                    crcResult = await WalletUtils.getCrc32(keypair),
                    data = await WalletUtils.testBitMap(tkmAddressResult),


                    setState(() {
                    _bytes = data.buffer.asInt8List();
                    crc = crcResult;
                    walletAddress = tkmAddressResult;
                    })

                  })
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

    final picData =
        await painter.toImageData(2048, format: ImageByteFormat.png);
    await FileSystemUtils.saveFileByte("QrCode.png", picData!);
    
    WalletUtils.initWallet(dotenv.get('WALLET_FOLDER'), 'pippo', dotenv.get('WALLET_EXTENSION'), 'password');
    
    return true;

  }

  @override
  void initState() {
    _getBytes();
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
          children: [
            Center(
                child: _bytes == null
                    ? const CircularProgressIndicator()
                    : Image.memory(
                        Uint8List.fromList(_bytes!),
                        width: 250,
                        height: 250,
                        fit: BoxFit.contain,
                      )),

            Center(child: walletAddress == null? const CircularProgressIndicator() : Text(walletAddress!)),

            Center(child: crc == null? const CircularProgressIndicator() : Text(crc!)),

            CupertinoButton(
                color: Styles.takamakaColor,
                onPressed: _getBytes,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(CupertinoIcons.refresh),
                    SizedBox(width: 10),
                    Text('Get Wallet'),
                  ],
                ))

            /*CupertinoTextField(
                padding:
                    EdgeInsets.only(left: 65, top: 10, right: 6, bottom: 10),
                prefix: Text('Wallet Address'),
                placeholder: 'Required',
                onChanged: (value) => _getBytes())*/
          ],
        ));
  }
}
