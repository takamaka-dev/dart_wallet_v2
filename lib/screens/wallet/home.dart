import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/l10n/app_localizations.dart';
import 'package:dart_wallet_v2/screens/restore/restore_part_1.dart';
import 'package:dart_wallet_v2/screens/wallet/new_wallet.dart';
import 'package:dart_wallet_v2/screens/wallet/wallet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

import '../../config/styles.dart';
import '../restore/restore.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String>? wallets = Globals.instance.wallets.isEmpty ? null : Globals.instance.wallets;

  @override
  void initState() {
    getWallets();
    super.initState();
  }

  Future<void> getWallets() async {

    bool existsFolder = await (await FileSystemUtils.getWalletDir(dotenv.get('WALLET_FOLDER'))).exists();

    if (!existsFolder) {
      await FileSystemUtils.createFolderInAppDocDir(dotenv.get('WALLET_FOLDER'));
    }

    List<String> walletsResult = await FileSystemUtils.getWalletsInWalletsDir(
        dotenv.get('WALLET_FOLDER'), dotenv.get('WALLET_EXTENSION'));

    setState(() {
      wallets = walletsResult;
    });
  }

  Widget tryRenderWallets() {

    if (wallets == null) {
      return const CircularProgressIndicator();
    } else if (wallets!.isNotEmpty) {
      return  WalletListWidget(wallets!).build(context);
    }

    return const Column(
      children: [
        SizedBox(height: 20),
        Text("No wallets has been added yet!"),
        SizedBox(height: 20)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    AppLocalizations.of(context)?.load();

    AppLocalizations? _appLocalizations = AppLocalizations.of(context);

    String appName = _appLocalizations?.translate('app_name') ?? 'My App';

    return SingleChildScrollView(
      child: CupertinoPageScaffold(
          navigationBar: const CupertinoNavigationBar(
            middle: Text('Home'),
          ),
          child: Column(
            children: [
              Container(
                  child: const Center()),
              Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        tryRenderWallets(),
                        Center(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 50),
                                  CupertinoButton(
                                      color: Styles.takamakaColor,
                                      onPressed: _newWallet,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(CupertinoIcons.plus),
                                          SizedBox(width: 10),
                                          Text('New Wallet'),
                                        ],
                                      )),
                                  const SizedBox(height: 30),
                                  CupertinoButton(
                                      color: Styles.takamakaColor,
                                      onPressed: _restoreWallet,
                                      child: const Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(CupertinoIcons.arrow_3_trianglepath),
                                            SizedBox(width: 10),
                                            Text('Restore Wallet')
                                          ])),
                                  const SizedBox(height: 50),
                                ])),
                        const SizedBox(height: 50)
                      ]))
            ],
          )),
    );
  }

  Future<void> _newWallet() async {
    Navigator.of(context).push(CupertinoPageRoute<void>(
      builder: (BuildContext context) {
        return const NewWallet();
      },
    ));
  }

  void _restoreWallet() {
    Navigator.of(context).push(CupertinoPageRoute<void>(
      builder: (BuildContext context) {
        return const RestorePart1();
        /*return Restore(onRefresh: () {
          FileSystemUtils.getWalletsInWalletsDir(
                  dotenv.get('WALLET_FOLDER'), dotenv.get('WALLET_EXTENSION'))
              .then((value) => {
                    setState(() {
                      wallets = value;
                    })
                  });
        });*/
      },
    ));
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
        header: const Text('My wallets'),
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
            return Wallet(walletName);
          },
        ),
      ),
    );
  }
}
