import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:dart_wallet_v2/config/database/metatransaction.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/screens/restore/restore_part_1.dart';
import 'package:dart_wallet_v2/screens/wallet/new_wallet.dart';
import 'package:dart_wallet_v2/screens/wallet/wallet.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

import '../../config/styles.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String>? wallets =
      Globals.instance.wallets.isEmpty ? null : Globals.instance.wallets;
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;


  @override
  void initState() {
    getWallets();
    //initDeepLinks();
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

  void insertJsonHash(String hash) async{
    var box = await Hive.openBox('metatransaction');
    var metatransaction = Metatransaction(hash, DateTime.timestamp(), false);
    await box.put(hash, metatransaction);
    Hive.close();
  }

  Future<void> initDeepLinks(Uri uri) async {
    final appLinks = AppLinks();

// Get the initial/first link.
// This is useful when app was terminated (i.e. not started)
    //final uri = await appLinks.getInitialAppLink();
     Map<String, String> params = uri!.queryParameters;
     String param = params['json_hash']??'';
     _showAlertDialog(context, param);
     insertJsonHash(param);

// Do something (navigation, ...)

// Subscribe to further events when app is started.
// (Use stringLinkStream to get it as [String])
    _linkSubscription = appLinks.uriLinkStream.listen((uri) async {
      openAppLink(uri);
    });

  }

  void openAppLink(Uri uri) {
    Map<String, String> params = uri.queryParameters;
   String param = params['json_hash']??'';
   _showAlertDialog(context, param);
    insertJsonHash(param);
  }
  
  void testDeepLink(){
    initDeepLinks(Uri.parse("tkmwallet://tkmwallet.com/home?json_hash=1edfce8f4eede990892139bed80992c88cea1cad3fe8e797c8e4aac043460e55"));
  }

  void _showAlertDialog(BuildContext context, String text) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: const Text('Alert'),
            content: Text(text),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(

                /// This parameter indicates this action is the default,
                /// and turns the action's text to bold text.
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              )
            ],
          ),
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
              middle: Text("Home"),
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
                          Center(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                const SizedBox(height: 50),
                                CupertinoButton(
                                    color: Styles.takamakaColor,
                                    onPressed: _newWallet,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(CupertinoIcons.plus),
                                        const SizedBox(width: 10),
                                        const Text('addWallet').tr(),
                                      ],
                                    )),
                                const SizedBox(height: 30),
                                CupertinoButton(
                                    color: Styles.takamakaColor,
                                    onPressed: _restoreWallet,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(CupertinoIcons
                                              .arrow_3_trianglepath),
                                          const SizedBox(width: 10),
                                          const Text('restoreWallet').tr()
                                        ])),
                                const SizedBox(height: 50),
                              ])),
                          const SizedBox(height: 30),
                          CupertinoButton(
                              color: Styles.takamakaColor,
                              onPressed: testDeepLink,
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(CupertinoIcons
                                        .alarm),
                                    const SizedBox(width: 10),
                                    const Text('Test Deeplink')
                                  ])),
                          const SizedBox(height: 50),
                        ])),
              ],
            )),
      ),
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
        margin: EdgeInsets.all(30),
        header: const Text('myWallets').tr(),
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
        color: Colors.transparent,
        child: Icon(Icons.wallet,
            color: Styles.takamakaColor.withOpacity(0.5), size: 28),
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
