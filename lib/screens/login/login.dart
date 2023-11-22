import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/wallet/unlocked_wallet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class Login extends StatefulWidget{
  const Login(this.walletName, {super.key});

  final walletName;

  @override
  State<StatefulWidget> createState() => _LoginState(walletName);

}

class _LoginState extends State<Login>{
  _LoginState(this.walletName);

  final String walletName;
  bool _error = false;

  Map<String, dynamic>? kb;
  Int8List? _bytes;
  String? walletAddress;
  String? crc;
  int? selectedIndex;

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _walletIndexNumberController =
  TextEditingController(text: '0');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CupertinoPageScaffold(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Container(
                    color: Styles.takamakaColor,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: <Widget>[
                        CupertinoButton(
                          onPressed: () {
                            Navigator.pop(
                                context); // Navigate back when back button is pressed
                          },
                          child: const Icon(Icons.arrow_back,
                              color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("walletLogin".tr(),
                                textAlign: TextAlign.center,
                                style:
                                const TextStyle(color: Colors.white)),
                          ],
                        ),
                      ],
                    )),
              ),
              const SizedBox(height: 20),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(CupertinoIcons.lock_circle,
                        size: 60, color: Styles.takamakaColor),
                    Text(
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade600),
                        "pleaseInsertWalletPassword".tr()),
                    const SizedBox(height: 20),
                    SizedBox(
                        width: 200,
                        child: Column(
                          children: [
                            CupertinoTextField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              controller: _walletIndexNumberController,
                              placeholder: 'walletIndexNumber'.tr(),
                              onChanged: (value) {
                                _walletIndexNumberController.text = value;
                                _walletIndexNumberController.selection =
                                    TextSelection.fromPosition(TextPosition(
                                        offset:
                                        _walletIndexNumberController
                                            .text.length));
                              },
                            ),
                            const SizedBox(height: 20),
                            CupertinoTextField(
                              controller: _passwordController,
                              obscureText: true,
                              textAlign: TextAlign.center,
                              placeholder: "password".tr(),
                            ),
                          ],
                        )),
                    _error
                        ? Text("invalidCredentials".tr(),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red))
                        : const Text(""),
                    const SizedBox(height: 25),
                    CupertinoButton(
                        color: Styles.takamakaColor,
                        child: const Text("Login"),
                        onPressed: () async {
                          loginWallet(context, walletName, _passwordController.text);
                        }),
                    const SizedBox(height: 80)
                  ],
                ),
              )
            ],
          )),
    );
  }

  Future<void> loginWallet(context, walletName, password) async {
    try {
      // context.loaderOverlay.show();
      kb = await WalletUtils.initWallet(
          'wallets', walletName, dotenv.get('WALLET_EXTENSION'), password);

      Globals.instance.kb = kb!;
      Globals.instance.generatedSeed = kb!['seed'];

      SimpleKeyPair keypair = await WalletUtils.getNewKeypairED25519(
          kb!['seed'],
          index: int.parse(_walletIndexNumberController.text));

      Globals.instance.generatedSeed = kb!['seed'];
      Globals.instance.currentIndex =
          int.parse(_walletIndexNumberController.text);

      crc = await WalletUtils.getCrc32(keypair);
      walletAddress = await WalletUtils.getTakamakaAddress(keypair);
      _bytes = await WalletUtils.testBitMap(walletAddress!).buffer.asInt8List();

      Globals.instance.crc = crc!;
      Globals.instance.walletAddress = walletAddress!;
      Globals.instance.bytes = _bytes!;

      // fetchMyObjects();

      Globals.instance.walletName = walletName;

      Globals.instance.selectedWalletIndex = int.parse(_walletIndexNumberController.text);
      Globals.instance.walletPassword = password;
      // context.loaderOverlay.hide();
      Navigator.of(context).push(
          CupertinoPageRoute<void>(builder: (BuildContext context) {
            return const UnlockedWallet();
          }));
      print('login is successfull');
    } on ArgumentError catch (_) {
      // context.loaderOverlay.hide();
      setState(() {
        _error = true;
      });
    }
  }
}