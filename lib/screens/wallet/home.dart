import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

import '../../config/styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String>? wallets;

  @override
  void initState() {
    getWallets();
    super.initState();
  }

  Future<void> getWallets() async {
    FileSystemUtils.getWalletsInWalletsDir(
            dotenv.get('WALLET_FOLDER'), dotenv.get('WALLET_EXTENSION'))
        .then((value) => {
              setState(() {
                wallets = value;
              })
            });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Column(
      children: [
        Container(
            constraints: const BoxConstraints(maxWidth: 700),
            padding: const EdgeInsets.fromLTRB(20, 80, 20, 50),
            child: Center()),
        Container(
            alignment: Alignment.bottomCenter,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /*const WalletListWidget(['paolino', 'paperino', 'pluto']).build(context),*/
                  wallets == null
                      ? const CircularProgressIndicator()
                      : WalletListWidget(wallets!).build(context),
                  Center(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                        CupertinoButton(
                            color: Styles.takamakaColor,
                            onPressed: _printClikNew,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(CupertinoIcons.plus),
                                SizedBox(width: 10),
                                Text('New Wallet'),
                              ],
                            )),
                        SizedBox(width: 50),
                        CupertinoButton(
                            color: Styles.takamakaColor,
                            onPressed: _printClikRestore,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(CupertinoIcons.arrow_3_trianglepath),
                                  SizedBox(width: 10),
                                  Text('Restore Wallet')
                                ])),
                      ]))
                ]))
      ],
    ));
  }

  Future<void> _printClikNew() async {
    print("Clicked New Wallet");
    /*wallets = await FileSystemUtils.getWalletsInWalletsDir(
        dotenv.get('WALLET_FOLDER'), dotenv.get('WALLET_EXTENSION'));*/
  }

  void _printClikRestore() {
    print("Clicked Restore Wallet");
  }
}

class WalletListWidget extends StatelessWidget {
  const WalletListWidget(this.walletsList, {super.key});

  final List<String> walletsList;

  @override
  Widget build(BuildContext context) {
    List<Widget> wallets = [];
    for (String walletName in walletsList) {
      wallets.add(SingleWallet(walletName).build(context));
    }

    return CupertinoPageScaffold(
      child: CupertinoListSection(
        header: const Text('My Reminders'),
        children: wallets,
      ),
    );
  }
}

class SingleWallet extends StatelessWidget {
  SingleWallet(this.walletName, {super.key});

  final String walletName;
  String password = "";

  @override
  Widget build(BuildContext context) {

    return CupertinoListTile(
      title: Text(walletName),
      leading: Container(
        width: double.infinity,
        height: double.infinity,
        color: CupertinoColors.activeGreen,
      ),
      trailing: const CupertinoListTileChevron(),
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute<void>(
          builder: (BuildContext context) {
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
          },
        ),
      ),
    );
  }

  void _openWallet() {
    WalletUtils.initWallet('wallets', walletName, dotenv.get('WALLET_EXTENSION'), password).then((seed) => {

      print('Current seed ' + seed)
    });
  }

}
