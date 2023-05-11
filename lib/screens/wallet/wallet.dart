import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/api/changes.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/pay/pay.dart';
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
          builder: (context, model, child) => Scaffold(
                  body: Container(
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
                            child: const Text("Login"),
                            onPressed: () async {
                              kb = await WalletUtils.initWallet(
                                  'wallets',
                                  walletName,
                                  dotenv.get('WALLET_EXTENSION'),
                                  password);
                              SimpleKeyPair keypair =
                                  await WalletUtils.getNewKeypairED25519(
                                      kb!['seed']);

                              Globals.instance.generatedSeed = kb!['seed'];

                              crc = await WalletUtils.getCrc32(keypair);
                              walletAddress =
                                  await WalletUtils.getTakamakaAddress(keypair);
                              _bytes =
                                  await WalletUtils.testBitMap(walletAddress!)
                                      .buffer
                                      .asInt8List();
                              setState(() {
                                kb = kb;
                                crc = crc;
                                walletAddress = walletAddress;
                                Globals.instance.selectedFromAddress =
                                    walletAddress!;
                                _bytes = _bytes;
                                fetchMyObjects();
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

  Future<void> doGetBalance() async {
    BalanceRequestBean brb =
        BalanceRequestBean(Globals.instance.selectedFromAddress);

    print('GET BALANCE FOR ADDRESS: ' + Globals.instance.selectedFromAddress);

    BalanceResponseBean brespb = BalanceResponseBean.fromJson(jsonDecode(
        await ConsumerHelper.doRequest(HttpMethods.POST,
            ApiList().apiMap['test']!['balance']!, brb.toJson())));
    print((brespb.greenBalance as BigInt) / BigInt.from(10).pow(9));
  }

  Widget getUnlockedWallet() {
    return ChangeNotifierProvider.value(
      value: Globals.instance,
      child: Consumer<Globals>(
          builder: (context, model, child) => SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const SizedBox(height: 50),
                Center(
                    child: _bytes == null
                        ? const CircularProgressIndicator()
                        : Image.memory(
                      Uint8List.fromList(_bytes!),
                      width: 250,
                      height: 250,
                      fit: BoxFit.contain,
                    )),
                SizedBox(height: 20),
                Container(
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('images/wall.jpeg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                const CircleAvatar(
                                    radius: 35.0,
                                    backgroundColor: Colors.green,
                                    child: Text("TKG",
                                        style:
                                        TextStyle(color: Colors.white))),
                                const SizedBox(height: 10),
                                Text(
                                    "TKG ${(Globals.instance.brb.greenBalance! / BigInt.from(10).pow(10)).toStringAsFixed(2)}",
                                    style:
                                    const TextStyle(color: Colors.white)),
                                Text(
                                    "\$ ${updateCurrencyValue(Globals.instance.brb.greenBalance! / BigInt.from(10).pow(10))}",
                                    style:
                                    const TextStyle(color: Colors.white))
                              ],
                            ),
                            const SizedBox(width: 50),
                            Column(
                              children: [
                                const CircleAvatar(
                                    radius: 35.0,
                                    backgroundColor: Colors.red,
                                    child: Text("TKR",
                                        style:
                                        TextStyle(color: Colors.white))),
                                const SizedBox(height: 10),
                                Text(
                                    "TKR ${(Globals.instance.brb.redBalance! / BigInt.from(10).pow(10)).toStringAsFixed(2)}",
                                    style:
                                    const TextStyle(color: Colors.white)),
                                Text(
                                    "\$ ${(Globals.instance.brb.redBalance! / BigInt.from(10).pow(10)).toStringAsFixed(2)}",
                                    style:
                                    const TextStyle(color: Colors.white))
                              ],
                            )
                          ],
                        ),
                        const SizedBox(height: 50),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: const [
                              Text("Your Takamaka Address:",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold))
                            ]),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            walletAddress == null
                                ? const CircularProgressIndicator()
                                : Text(walletAddress!,
                                style:
                                const TextStyle(color: Colors.white))
                          ],
                        ),
                        const SizedBox(height: 20),
                        crc == null
                            ? const CircularProgressIndicator()
                            : Column(
                          children: [
                            Row(
                              children: const [
                                Text("Your CRC: ",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold))
                              ],
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                Text(crc!,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(
                                        color: Colors.white))
                              ],
                            )
                          ],
                        )
                      ],
                    )),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                          color: Styles.takamakaColor,
                          onPressed: () => {
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
                      const SizedBox(height: 30),
                      CupertinoButton(
                          color: Styles.takamakaColor,
                          onPressed: () => {
                            Navigator.of(context).push(
                                CupertinoPageRoute<void>(
                                    builder: (BuildContext context) {
                                      return const Pay();
                                    }))
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(CupertinoIcons.paperplane),
                              SizedBox(width: 10),
                              Text('Payments'),
                            ],
                          )),
                      const SizedBox(height: 50),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  Future<void> fetchMyObjects() async {
    final response = await ConsumerHelper.doRequest(
        HttpMethods.GET, ApiList().apiMap['test']!['changes']!, {});

    final myApiResponse = Changes.fromJson(jsonDecode(response));
    Globals.instance.changes = myApiResponse;

    BalanceRequestBean brb =
        BalanceRequestBean(Globals.instance.selectedFromAddress);

    BalanceResponseBean brespb = BalanceResponseBean.fromJson(jsonDecode(
        await ConsumerHelper.doRequest(HttpMethods.POST,
            ApiList().apiMap['test']!['balance']!, brb.toJson())));

    Globals.instance.brb = brespb;
  }

  String updateCurrencyValue(double value) {
    double usdTk = Globals.instance.changes.changes[2].value;

    return (value * usdTk).toStringAsFixed(2);
  }
}
