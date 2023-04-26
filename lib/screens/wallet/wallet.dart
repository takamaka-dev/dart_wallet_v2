import 'dart:typed_data';
import 'dart:ui';

import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/utils/wallet_general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:dart_wallet_v2/config/globals.dart' as globals;
import 'package:qr_flutter/qr_flutter.dart';

class Wallet extends StatefulWidget {
  const Wallet(this.walletName, {super.key});

  final String walletName;

  @override
  State<Wallet> createState() => _WalletState(walletName);
}

class _WalletState extends State<Wallet> {
  _WalletState(this.walletName);

  final String walletName;

  Int8List? _bytes;
  String? walletAddress;
  String? crc;
  String? seed;

  String password = "";

  Future<bool> _initWalletInterface() async {

    setState(() {
      crc = null;
      walletAddress = null;
      _bytes = null;
      seed = null;
    });

    Uint8List data;

    /*bool exists = await FileSystemUtils.existsFile('words.txt');*/

    /*globals.words = await WalletUtils.generateWords();
    FileSystemUtils.saveFile('words.txt', globals.words.join(" "));*/

    /*if(!exists) {
      globals.words = await WalletUtils.generateWords();
      FileSystemUtils.saveFile('words.txt', globals.words.join(" "));
    }else{
      FileSystemUtils.readFile('words.txt').then((wordList) => {globals.words = wordList.split(" ")});
    }*/
    //
    // String tkmAddressResult = "";
    // String crcResult = "";


    /*FileSystemUtils.readFile(dotenv.get('PREFIX_SEED_FILE_NAME')).then((seed) => {
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
        });*/



    /*final qrValidationResult = QrValidator.validate(
      data: globals.words.join(" "),
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );*/

    /*final QrCode? qrCode = qrValidationResult.qrCode;

    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: const Color(0xFF000000),
      gapless: true,
      embeddedImageStyle: null,
      embeddedImage: null,
    );

    final picData =
        await painter.toImageData(2048, format: ImageByteFormat.png);
    await FileSystemUtils.saveFileByte("QrCode.png", picData!);*/
    //
    // WalletUtils.initWallet(dotenv.get('WALLET_FOLDER'), 'pippo', dotenv.get('WALLET_EXTENSION'), 'password');
    //
    return true;

  }

  @override
  void initState() {
    _initWalletInterface();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(

        child: seed==null?getLockedWallet():getUnlockedWallet());
  }

  Widget getLockedWallet(){
    return CupertinoPageScaffold(
        child: Column(
          children: [
            CupertinoButton(
              onPressed: () {
                Navigator.pop(
                    context); // Navigate back when back button is pressed
              },
              child: const Icon(Icons.arrow_back),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoTextField(
                  textAlign: TextAlign.center,
                  placeholder: "Password",
                  onChanged: (value) => {password = value},
                ),
                CupertinoButton(
                    child: Text("Login"),
                    onPressed: _openWallet

                )
              ],
            )
          ],
        ));
  }

  Widget getUnlockedWallet() {

    return Column(
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
            onPressed: _initWalletInterface,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(CupertinoIcons.arrow_right_square),
                SizedBox(width: 10),
                Text('Logout'),
              ],
            ))
      ],
    );

  }

  Future<void> _openWallet() async {
    seed = await WalletUtils.initWallet('wallets', walletName, dotenv.get('WALLET_EXTENSION'), password);
    SimpleKeyPair keypair = await WalletUtils.getNewKeypairED25519(seed!);
    crc = await WalletUtils.getCrc32(keypair);
    walletAddress = await WalletUtils.getTakamakaAddress(keypair);
    _bytes = await WalletUtils.testBitMap(walletAddress!).buffer.asInt8List();
    setState(() {
      seed = seed;
      crc = crc;
      walletAddress = walletAddress;
      _bytes = _bytes;
    });
  }


// @override
//   Widget build(BuildContext context) {
//     print(globals.selectedNetwork);
//     return CupertinoPageScaffold(
//         navigationBar: const CupertinoNavigationBar(
//           middle: Text('Wallet'),
//         ),
//         child: );
//   }



}
