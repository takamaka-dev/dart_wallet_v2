import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class Login extends StatelessWidget{
  Login({super.key});

  Map<String, dynamic>? kb;

  @override
  Widget build(BuildContext context) {
    SingleChildScrollView(
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
                            // CupertinoTextField(
                            //   keyboardType: TextInputType.number,
                            //   textAlign: TextAlign.center,
                            //   controller: _walletIndexNumberController,
                            //   placeholder: 'walletIndexNumber'.tr(),
                            //   onChanged: (value) {
                            //     _walletIndexNumberController.text = value;
                            //     _walletIndexNumberController.selection =
                            //         TextSelection.fromPosition(TextPosition(
                            //             offset:
                            //             _walletIndexNumberController
                            //                 .text.length));
                            //   },
                            // ),
                            const SizedBox(height: 20),
                            CupertinoTextField(
                              obscureText: true,
                              textAlign: TextAlign.center,
                              placeholder: "password".tr(),
                              // onSubmitted: (String v) =>
                              // {loginWallet(context)},
                            ),
                          ],
                        )),
                    // _error
                    //     ? Text("invalidCredentials".tr(),
                    //     style: const TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.red))
                    //     : const Text(""),
                    const SizedBox(height: 25),
                    CupertinoButton(
                        color: Styles.takamakaColor,
                        child: const Text("Login"),
                        onPressed: () async {
                          // loginWallet(context);
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
      context.loaderOverlay.show();
      kb = await WalletUtils.initWallet(
          'wallets', walletName, dotenv.get('WALLET_EXTENSION'), password);

      Globals.instance.kb = kb!;

      // SimpleKeyPair keypair = await WalletUtils.getNewKeypairED25519(
      //     kb!['seed'],
          // index: int.parse(_walletIndexNumberController.text));

      Globals.instance.generatedSeed = kb!['seed'];
      // Globals.instance.currentIndex =
      //     int.parse(_walletIndexNumberController.text);

      // crc = await WalletUtils.getCrc32(keypair);
      // walletAddress = await WalletUtils.getTakamakaAddress(keypair);
      // _bytes = await WalletUtils.testBitMap(walletAddress!).buffer.asInt8List();

      // Globals.instance.crc = crc!;
      // Globals.instance.walletAddress = walletAddress!;
      // Globals.instance.bytes = _bytes!;

      // fetchMyObjects();

      Globals.instance.walletName = walletName;

      // Globals.instance.selectedWalletIndex = selectedIndex!;

      context.loaderOverlay.hide();
    } on ArgumentError catch (_) {
      context.loaderOverlay.hide();
      // setState(() {
      //   _error = true;
      // });
    }
  }
}