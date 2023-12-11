import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/blob/blob.dart';
import 'package:dart_wallet_v2/screens/transactions/blob/blob_text.dart';
import 'package:dart_wallet_v2/screens/transactions/pay/pay.dart';
import 'package:dart_wallet_v2/screens/transactions/qr_code_sign/pre_select_qr_scan.dart';
import 'package:dart_wallet_v2/screens/transactions/receive_tokens/receive_tokens.dart';
import 'package:dart_wallet_v2/screens/transactions/stake/stake.dart';
import 'package:dart_wallet_v2/screens/transactions/transaction_list/transaction_list.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';

class UnlockedWallet extends StatefulWidget{
  const UnlockedWallet({super.key});

  @override
  State<StatefulWidget> createState() =>_UnlockedWalletState();

}

class _UnlockedWalletState extends State<UnlockedWallet>{

  late Int8List _bytes;
  late String walletAddress;
  late String crc;
  late int selectedIndex;
  late Map<String, dynamic> kb;
  String password = "";

  final TextEditingController _selectedIndexController =
  Globals.instance.selectedWalletIndex < 0
      ? TextEditingController()
      : TextEditingController(
      text: Globals.instance.selectedWalletIndex.toString());

  @override
  void initState() {
    _initWalletInterface();
    super.initState();
    Globals.instance.nextAction == "BLOB"?WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).push(
          CupertinoPageRoute<void>(builder: (BuildContext context) {
            return const BlobText();
          }));}):null;
    }

  Future<dynamic> _launchURLBrowser() async {
    Uri url = Uri.parse(Globals.instance.selectedNetwork == "prod"
        ? 'https://exp.takamaka.dev/'
        : 'https://testexplorer.takamaka.dev/');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> doGetBalance() async {
    BalanceRequestBean brb =
    BalanceRequestBean(Globals.instance.selectedFromAddress);
    BalanceResponseBean.fromJson(jsonDecode(await ConsumerHelper.doRequest(
        HttpMethods.POST,
        ApiList().apiMap[Globals.instance.selectedNetwork]!['balance']!,
        brb.toJson())));
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderCopiedAddress(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('alert').tr(),
          content: const Text('addressCopied').tr(),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ok').tr(),
            ),
          ],
        );
      },
    );
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderCopiedCrc(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('confirm').tr(),
          content: const Text('crcCopied').tr(),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ok').tr(),
            ),
          ],
        );
      },
    );
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogNotAllowed(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('alert').tr(),
          content: const Text('notAllowedQrDesktop').tr(),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('ok').tr(),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: _bytes == null
                      ? const CircularProgressIndicator()
                      : Image.memory(
                    Uint8List.fromList(_bytes!),
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  )),
              Expanded(
                  flex: 1,
                  child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: MediaQuery.of(context).size.width /
                          (MediaQuery.of(context).size.height / 1.9),
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(5),
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 2,
                      children: [
                        CupertinoButton(
                            color: Styles.takamakaColor,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                            borderRadius: BorderRadius.zero,
                            onPressed: () => {
                              Navigator.of(context).push(
                                  CupertinoPageRoute<void>(builder: (BuildContext context) {
                                    return const TransactionList();
                                  }))
                            },
                            child: const Center(child: Icon(CupertinoIcons.time, size: 30, color: Colors.white))),
                        CupertinoButton(
                            color: Colors.grey.shade200,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                            borderRadius: BorderRadius.zero,
                            onPressed: () => {
                              Navigator.of(context).push(
                                  CupertinoPageRoute<void>(builder: (BuildContext context) {
                                    return const ReceiveTokens();
                                  }))
                            },
                            child: const Center(child: Icon(Icons.call_received, size: 30, color: Colors.black45))),
                        CupertinoButton(
                            color: Colors.grey.shade200,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                            borderRadius: BorderRadius.zero,
                            onPressed: () => {_launchURLBrowser()},
                            child: const Center(child: Icon(CupertinoIcons.location_solid, size: 30, color: Colors.black45))),
                        CupertinoButton(
                            color: Styles.takamakaColor,
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                            borderRadius: BorderRadius.zero,
                            onPressed: () => {
                              if (Platform.isAndroid || Platform.isIOS) {
                                Navigator.of(context).push(
                                    CupertinoPageRoute<void>(builder: (BuildContext context) {
                                      return const PreSelectQrScan();
                                    }))
                              } else {
                                Navigator.of(context).restorablePush(_dialogNotAllowed)
                              }

                            },
                            child: const Center(child: Icon(CupertinoIcons.qrcode_viewfinder, size: 30, color: Colors.white)))

                      ]))
            ],
          ),

          const SizedBox(height: 30),

          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
            ),
            child: Row(
              children: List.generate(3, (index) {
                return getMenuItems(context, index);
              }),
            ),
          ),
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
              margin: const EdgeInsets.fromLTRB(5, 20, 5, 5),
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
                                  style: TextStyle(
                                      color: Colors.white))),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text("TKG ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text(
                                  ((Globals.instance.brb
                                      .greenBalance ??
                                      BigInt.from(0)) /
                                      BigInt.from(10).pow(9))
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: Colors.white))
                            ],
                          ),
                          Text(
                              "${Globals.instance.currencyMappingReverseSymbols[Globals.instance.selectedCurrency]!} ${updateCurrencyValue((Globals.instance.brb.greenBalance ?? BigInt.from(0)) / BigInt.from(10).pow(9))}",
                              style: const TextStyle(
                                  color: Colors.white))
                        ],
                      ),
                      const SizedBox(width: 50),
                      Column(
                        children: [
                          const CircleAvatar(
                              radius: 35.0,
                              backgroundColor: Colors.red,
                              child: Text("TKR",
                                  style: TextStyle(
                                      color: Colors.white))),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              const Text("TKR ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              Text(
                                  ((Globals.instance.brb.redBalance ??
                                      BigInt.from(0)) /
                                      BigInt.from(10).pow(9))
                                      .toStringAsFixed(2),
                                  style: const TextStyle(
                                      color: Colors.white))
                            ],
                          ),
                          Text(
                              "\$ ${((Globals.instance.brb.redBalance ?? BigInt.from(0)) / BigInt.from(10).pow(9)).toStringAsFixed(2)}",
                              style: const TextStyle(
                                  color: Colors.white))
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Text("yourTakamakaAddress".tr(),
                        softWrap: true,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: walletAddress == null
                          ? const CircularProgressIndicator()
                          : Container(
                        child: Text(walletAddress!,
                            softWrap: true,
                            style: const TextStyle(
                                color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                      alignment: Alignment.topLeft,
                      child: CupertinoButton(
                          color: Colors.grey.shade200,
                          minSize: 20,
                          // impostiamo la larghezza minima del pulsante
                          padding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          onPressed: () async {
                            String notNullWalletAddress =
                            walletAddress!;
                            Clipboard.setData(ClipboardData(
                                text:
                                notNullWalletAddress.trim()))
                                .then(
                                  (value) {
                                //only if ->
                                Navigator.of(context).restorablePush(
                                    _dialogBuilderCopiedAddress);
                              },
                            );
                          },
                          child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(CupertinoIcons.doc_on_clipboard,
                                    size: 16,
                                    color: Styles.takamakaColor)
                              ]))),
                  const SizedBox(height: 20),
                  crc == null
                      ? const CircularProgressIndicator()
                      : Column(
                    children: [
                      Row(
                        children: [
                          Text("yourCrc".tr(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(crc!,
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                  color: Colors.white)),
                          const SizedBox(width: 10),
                          CupertinoButton(
                              color: Colors.grey.shade200,
                              minSize: 20,
                              // impostiamo la larghezza minima del pulsante
                              padding:
                              const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8),
                              onPressed: () async {
                                String notNullCrc = crc!;
                                Clipboard.setData(ClipboardData(
                                    text:
                                    notNullCrc.trim()))
                                    .then(
                                      (value) {
                                    //only if ->
                                    Navigator.of(context)
                                        .restorablePush(
                                        _dialogBuilderCopiedCrc);
                                  },
                                );
                              },
                              child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  mainAxisSize:
                                  MainAxisSize.min,
                                  children: [
                                    Icon(
                                        CupertinoIcons
                                            .doc_on_clipboard,
                                        size: 16,
                                        color: Styles
                                            .takamakaColor)
                                  ]))
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  selectedIndex == null
                      ? const CircularProgressIndicator()
                      : Column(
                    children: [
                      Row(
                        children: [
                          Text("yourWalletIndexNumber".tr(),
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold))
                        ],
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            child: CupertinoTextField(
                              onTap: () {
                              },
                              textAlign: TextAlign.start,
                            ),
                          ),
                          const SizedBox(width: 10),
                          CupertinoButton(
                              color: Colors.grey.shade200,
                              minSize: 20,
                              // impostiamo la larghezza minima del pulsante
                              padding:
                              const EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8),
                              onPressed: () async {
                                context.loaderOverlay.show();
                                kb = await WalletUtils
                                    .initWallet(
                                    'wallets',
                                    Globals.instance.walletName,
                                    dotenv.get(
                                        'WALLET_EXTENSION'),
                                    password);

                                Globals.instance.kb = kb!;

                                SimpleKeyPair keypair =
                                await WalletUtils
                                    .getNewKeypairED25519(
                                    kb!['seed'],
                                    index: int.parse(
                                        _selectedIndexController
                                            .text));

                                Globals.instance.generatedSeed =
                                kb!['seed'];
                                Globals.instance.currentIndex =
                                    int.parse(
                                        _selectedIndexController
                                            .text);

                                crc =
                                await WalletUtils.getCrc32(
                                    keypair);
                                walletAddress =
                                await WalletUtils
                                    .getTakamakaAddress(
                                    keypair);
                                _bytes = await WalletUtils
                                    .testBitMap(
                                    walletAddress!)
                                    .buffer
                                    .asInt8List();

                                Globals.instance.crc = crc!;
                                Globals.instance.walletAddress =
                                walletAddress!;
                                Globals.instance.bytes =
                                _bytes!;

                                Globals.instance
                                    .selectedWalletIndex =
                                    int.parse(
                                        _selectedIndexController
                                            .text);

                                setState(() {
                                  kb = kb;
                                  crc = crc;
                                  walletAddress = walletAddress;
                                  Globals.instance
                                      .selectedFromAddress =
                                  walletAddress!;
                                  _bytes = _bytes;
                                  selectedIndex = int.parse(
                                      _selectedIndexController
                                          .text);
                                  _selectedIndexController
                                      .text =
                                      selectedIndex.toString();
                                });
                                context.loaderOverlay.hide();
                              },
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(CupertinoIcons.refresh,
                                      color:
                                      Styles.takamakaColor),
                                ],
                              ))
                        ],
                      )
                    ],
                  )
                ],
              )),
          Center(
            child: Container(
                padding: const EdgeInsets.all(15),
                margin: const EdgeInsets.all(0),
                width: double.infinity,
                child: CupertinoButton(
                    color: Styles.takamakaColor,
                    onPressed: () => {
                      Globals.instance.generatedSeed = "",
                      _initWalletInterface(),
                      Globals.instance.resetAndGoToRoot(context)
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(CupertinoIcons.arrow_right_square),
                        SizedBox(width: 10),
                        Text('Logout'),
                      ],
                    ))),
          ),
          const SizedBox(height: 60)
        ],
      ),
    );
  }

  Future<bool> _initWalletInterface() async {
    setState(() {
      crc = Globals.instance.crc;
      walletAddress = Globals.instance.walletAddress;
      _bytes = Globals.instance.bytes;
      kb = Globals.instance.kb;
      selectedIndex = Globals.instance.selectedWalletIndex;
      password = Globals.instance.walletPassword;
      Globals.instance.selectedFromAddress = walletAddress;
    });

    return true;
  }

  Widget getMenuItems(BuildContext context, int index) {
    final List<Widget> menuItems = [
      Flexible(
          child: Container(
            height: 50,
            //width: cellwidth
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Styles.takamakaColor,
                border: const Border(
                  right: BorderSide(width: 1.0, color: Colors.white),
                )),
            child: CupertinoButton(
                color: Styles.takamakaColor,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                borderRadius: BorderRadius.zero,
                onPressed: () => {
                  Navigator.of(context).push(
                      CupertinoPageRoute<void>(builder: (BuildContext context) {
                        return const Pay();
                      }))
                },
                child: const Center(child: Icon(CupertinoIcons.paperplane))),
          )),
      Flexible(
          child: Container(
            height: 50,
            //width: cellwidth
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Styles.takamakaColor,
                border: const Border(
                  right: BorderSide(width: 1.0, color: Colors.white),
                )),
            child: CupertinoButton(
                color: Styles.takamakaColor,
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                alignment: Alignment.topLeft,
                borderRadius: BorderRadius.zero,
                // Rimuove il bordo arrotondato

                onPressed: () => {
                  Navigator.of(context).push(
                      CupertinoPageRoute<void>(builder: (BuildContext context) {
                        return const Blob();
                      }))
                },
                child: const Center(child: Icon(CupertinoIcons.doc_on_clipboard))),
          )),
      Flexible(
          child: Container(
            height: 50,
            //width: cellwidth
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: Styles.takamakaColor,
                border: const Border(
                  right: BorderSide(width: 1.0, color: Colors.white),
                )),
            child: CupertinoButton(
                color: Styles.takamakaColor,
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                borderRadius: BorderRadius.zero,
                // Rimuove il bordo arrotondato

                onPressed: () => {
                  Navigator.of(context).push(
                      CupertinoPageRoute<void>(builder: (BuildContext context) {
                        return const Stake();
                      }))
                },
                child: const Center(child: Icon(CupertinoIcons.layers_alt_fill))),
          ))

    ];
    return menuItems[index];
  }

  String updateCurrencyValue(double value) {
    try {
      double usdTk = Globals
          .instance.changes.changes[Globals.instance.selectedCurrency].value;

      return (value * usdTk).toStringAsFixed(2);
    } catch (exception) {
      return "0";
    }
  }
}