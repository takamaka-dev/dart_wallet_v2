import 'dart:typed_data';
import 'dart:ui';

import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/utils/wallet_general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:glass/glass.dart';
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
        child: seed == null ? getLockedWallet() : getUnlockedWallet());
  }

  Widget getLockedWallet() {
    return Scaffold(
        body: Container(
            /*decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("images/wallpaper.jpeg"),
                fit: BoxFit.cover,
              ),
            ),*/
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        Navigator.pop(
                            context); // Navigate back when back button is pressed
                      },
                      child: const Icon(Icons.arrow_back),
                    )
                  ],
                ),
                Container(
                  /*decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade400,
                          spreadRadius: 1,
                          blurRadius: 8)
                    ],
                  ),*/
                  constraints: const BoxConstraints(maxWidth: 700),
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                          style: TextStyle(
                              fontSize: 25, color: Colors.grey.shade600),
                          "Please insert your wallet password"),
                      const SizedBox(height: 50),
                      CupertinoTextField(
                        obscureText: true,
                        textAlign: TextAlign.center,
                        placeholder: "Password",
                        onChanged: (value) => {password = value},
                      ),
                      const SizedBox(height: 50),
                      CupertinoButton(
                          color: Styles.takamakaColor,
                          child: Text("Login"),
                          onPressed: _openWallet)
                    ],
                  ),
                ).asGlass(tintColor: Colors.transparent,
                    clipBorderRadius: BorderRadius.circular(15.0))
              ],
            )));
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
        Center(
            child: walletAddress == null
                ? const CircularProgressIndicator()
                : Text(walletAddress!)),
        Center(
            child:
                crc == null ? const CircularProgressIndicator() : Text(crc!)),
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
    seed = await WalletUtils.initWallet(
        'wallets', walletName, dotenv.get('WALLET_EXTENSION'), password);
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
