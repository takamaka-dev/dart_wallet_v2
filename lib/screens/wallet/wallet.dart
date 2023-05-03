import 'dart:typed_data';
import 'dart:ui';

import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:glass/glass.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:provider/provider.dart';
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
  Map<String, dynamic>? kb;

  String password = "";

  Future<bool> _initWalletInterface() async {
    setState(() {
      crc = null;
      walletAddress = null;
      _bytes = null;
      kb = null;
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
        child: kb == null ? getLockedWallet() : getUnlockedWallet());
  }

  Widget getLockedWallet() {
    return ChangeNotifierProvider.value(
      value: Globals.instance,
      child: Consumer<Globals>(
          builder: (context, model, child) =>
              Scaffold(
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
                                        fontSize: 25,
                                        color: Colors.grey.shade600),
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
                                    onPressed: () async {
                                      kb = await WalletUtils.initWallet(
                                          'wallets',
                                          walletName,
                                          dotenv.get('WALLET_EXTENSION'),
                                          password);
                                      SimpleKeyPair keypair =
                                      await WalletUtils.getNewKeypairED25519(
                                          kb!['seed']);
                                      crc = await WalletUtils.getCrc32(keypair);
                                      walletAddress =
                                      await WalletUtils.getTakamakaAddress(
                                          keypair);
                                      _bytes =
                                      await WalletUtils
                                          .testBitMap(walletAddress!)
                                          .buffer
                                          .asInt8List();
                                      setState(() {
                                        kb = kb;
                                        crc = crc;
                                        walletAddress = walletAddress;
                                        _bytes = _bytes;
                                      });
                                      model.generatedSeed = kb!['seed'];
                                      model.recoveryWords = kb!['words'];
                                    })
                              ],
                            ),
                          ).asGlass(
                              tintColor: Colors.transparent,
                              clipBorderRadius: BorderRadius.circular(15.0))
                        ],
                      )))),
    );
  }

  Widget getUnlockedWallet() {
    return ChangeNotifierProvider.value(
      value: Globals.instance,
      child: Consumer<Globals>(
          builder: (context, model, child) =>
              Column(
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
                      child: crc == null
                          ? const CircularProgressIndicator()
                          : Text(crc!)),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CupertinoButton(
                            color: Styles.takamakaColor,
                            onPressed: () =>
                            {
                              model.generatedSeed = "",
                              model.recoveryWords = "",
                              _initWalletInterface()
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(CupertinoIcons.arrow_right_square),
                                SizedBox(width: 10),
                                Text('Logout'),
                              ],
                            )),
                        SizedBox(width: 30),
                        CupertinoButton(
                            color: Styles.takamakaColor,
                            onPressed: () =>
                            {
                              Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                      builder: (BuildContext context) {
                                        return Scaffold();
                                      }
                                  ))
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(CupertinoIcons.paperplane),
                                SizedBox(width: 10),
                                Text('Payments'),
                              ],
                            ))
                      ],
                    ),
                  )
                ],
              )),
    );
  }
}
