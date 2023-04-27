import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/wallet/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:glass/glass.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:dart_wallet_v2/config/globals.dart' as globals;

class NewWallet extends StatelessWidget {
  NewWallet({required this.onRefresh});

  final VoidCallback onRefresh;
  String password = "";
  String walletName = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Center(
                      child: Image.asset('images/logo_small.png', width: 100)),
                  const SizedBox(height: 20),
                  Text(
                      style:
                          TextStyle(fontSize: 25, color: Colors.grey.shade600),
                      "Add a new wallet"),
                  const SizedBox(height: 50),
                  CupertinoTextField(
                    textAlign: TextAlign.center,
                    placeholder: "Wallet name",
                    onChanged: (value) => {walletName = value},
                  ),
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
                      onPressed: () => {_openWallet(context)},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(CupertinoIcons.plus),
                          Text(' Create wallet'),
                        ],
                      )
                  )
                ],
              ),
            ).asGlass(
                tintColor: Colors.transparent,
                clipBorderRadius: BorderRadius.circular(15.0))
          ],
        ),
      ),
    );
  }

  _openWallet(BuildContext context) async {
    await WalletUtils.initWallet(
        'wallets', walletName, dotenv.get('WALLET_EXTENSION'), password);
    onRefresh();
    Navigator.pop(context,true);
  }
}
