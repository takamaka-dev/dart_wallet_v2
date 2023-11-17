import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/screens/wallet/home.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class SelectWallet extends StatefulWidget{
  const SelectWallet({super.key});
  @override
  State<StatefulWidget> createState() => _SelectWalletState();

}

class _SelectWalletState extends State<SelectWallet> {
  List<String>? wallets =
  Globals.instance.wallets.isEmpty ? null : Globals.instance.wallets;

  @override
  void initState() {
    getWallets();
    super.initState();
  }

  Future<void> getWallets() async {
    bool existsFolder =
    await (await FileSystemUtils.getWalletDir(dotenv.get('WALLET_FOLDER')))
        .exists();

    if (!existsFolder) {
      await FileSystemUtils.createFolderInAppDocDir(
          dotenv.get('WALLET_FOLDER'));
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
      return WalletListWidget(wallets!).build(context);
    }

    return Column(
      children: [
        const SizedBox(height: 20),
        const Text("noWalletsAdded").tr(),
        const SizedBox(height: 20)
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        constraints: const BoxConstraints(minHeight: 1200),
        decoration: const BoxDecoration(color: Colors.white),
        child: CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text("Select Wallet"),
            ),
            child: Column(
              children: [
                Container(child: const Center()),
                Container(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          tryRenderWallets(),
                                  ])),
                      ],
            )),
      ),
    );
  }
}