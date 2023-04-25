import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

import '../../config/styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  void _printClikNew() {
    print("Clicked New Wallet");
    FileSystemUtils.getWalletsInWalletsDir(dotenv.get('WALLET_FOLDER'), dotenv.get('WALLET_EXTENSION'));
  }

  void _printClikRestore() {
    print("Clicked Restore Wallet");
  }
}
