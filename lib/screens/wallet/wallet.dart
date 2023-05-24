import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/api/changes.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/blob/blob.dart';
import 'package:dart_wallet_v2/screens/transactions/pay/pay.dart';
import 'package:dart_wallet_v2/screens/transactions/stake/stake.dart';
import 'package:dart_wallet_v2/screens/transactions/transaction_list/transaction_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:glass/glass.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Wallet extends StatefulWidget {
  const Wallet(this.walletName, {super.key});

  final String walletName;

  @override
  State<Wallet> createState() => _WalletState(walletName);
}

class _WalletState extends State<Wallet> {
  _WalletState(this.walletName);

  final TextEditingController _walletIndexNumberController =
      TextEditingController(text: '0');
  TextEditingController _selectedIndexController = TextEditingController();

  final String _url = 'https://exp.takamaka.dev/';

  final String walletName;

  bool _error = false;
  Int8List? _bytes;
  String? walletAddress;
  String? crc;
  int? selectedIndex;
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

  Future<dynamic> _launchURLBrowser() async {
    Uri url = Uri.parse(_url);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget getLockedWallet() {
    return ChangeNotifierProvider.value(
      value: Globals.instance,
      child: Consumer<Globals>(
          builder: (context, model, child) => Scaffold(
                  body: Column(
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
                    padding: const EdgeInsets.fromLTRB(20, 50, 20, 50),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(CupertinoIcons.lock,
                            size: 60, color: Styles.takamakaColor),
                        Text(
                            style: TextStyle(
                                fontSize: 25, color: Colors.grey.shade600),
                            "Please insert your wallet password"),
                        const SizedBox(height: 50),
                        SizedBox(
                            width: 200,
                            child: Column(
                              children: [
                                CupertinoTextField(
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  controller: _walletIndexNumberController,
                                  placeholder: 'Wallet index number',
                                  onChanged: (value) {
                                    _walletIndexNumberController.text = value;
                                    _walletIndexNumberController.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset: _walletIndexNumberController
                                                .text.length));
                                  },
                                ),
                                const SizedBox(height: 50),
                                CupertinoTextField(
                                  obscureText: true,
                                  textAlign: TextAlign.center,
                                  placeholder: "Password",
                                  onChanged: (value) => {password = value},
                                ),
                              ],
                            )),
                        const SizedBox(height: 25),
                        _error
                            ? const Text("Invalid wallet credentials!",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red))
                            : const Text(""),
                        const SizedBox(height: 25),
                        CupertinoButton(
                            color: Styles.takamakaColor,
                            child: const Text("Login"),
                            onPressed: () async {
                              try {
                                context.loaderOverlay.show();
                                kb = await WalletUtils.initWallet(
                                    'wallets',
                                    walletName,
                                    dotenv.get('WALLET_EXTENSION'),
                                    password);
                                SimpleKeyPair keypair =
                                    await WalletUtils.getNewKeypairED25519(
                                        kb!['seed'],
                                        index: int.parse(
                                            _walletIndexNumberController.text));

                                Globals.instance.generatedSeed = kb!['seed'];
                                Globals.instance.currentIndex = int.parse(
                                    _walletIndexNumberController.text);

                                crc = await WalletUtils.getCrc32(keypair);
                                walletAddress =
                                    await WalletUtils.getTakamakaAddress(
                                        keypair);
                                _bytes =
                                    await WalletUtils.testBitMap(walletAddress!)
                                        .buffer
                                        .asInt8List();
                                fetchMyObjects();
                                setState(() {
                                  kb = kb;
                                  crc = crc;
                                  walletAddress = walletAddress;
                                  Globals.instance.selectedFromAddress =
                                      walletAddress!;
                                  _bytes = _bytes;
                                  selectedIndex = int.parse(
                                      _walletIndexNumberController.text);
                                  _selectedIndexController.text =
                                      selectedIndex.toString();
                                });
                                model.generatedSeed = kb!['seed'];
                                model.recoveryWords = kb!['words'];
                                context.loaderOverlay.hide();
                              } on ArgumentError catch (_) {
                                context.loaderOverlay.hide();
                                setState(() {
                                  _error = true;
                                });
                              }
                            })
                      ],
                    ),
                  ).asGlass(
                      tintColor: Colors.transparent,
                      clipBorderRadius: BorderRadius.circular(15.0))
                ],
              ))),
    );
  }

  Future<void> doGetBalance() async {
    BalanceRequestBean brb =
        BalanceRequestBean(Globals.instance.selectedFromAddress);
    BalanceResponseBean.fromJson(jsonDecode(
        await ConsumerHelper.doRequest(
            HttpMethods.POST,
            ApiList().apiMap[Globals.instance.selectedNetwork]!['balance']!,
            brb.toJson())));
  }

  Widget getUnlockedWallet() {
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
                    return const TransactionList();
                  }))
                },
            child: const Center(child: Icon(CupertinoIcons.list_bullet))),
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
                    return const Pay();
                  }))
                },
            child: const Center(child: Icon(CupertinoIcons.arrow_down))),
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

            onPressed: () => {_launchURLBrowser()},
            child: const Center(child: Icon(CupertinoIcons.location_solid))),
      )),
    ];
    return ChangeNotifierProvider.value(
      value: Globals.instance,
      child: Consumer<Globals>(
          builder: (context, model, child) => SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                        child: _bytes == null
                            ? const CircularProgressIndicator()
                            : Image.memory(
                                Uint8List.fromList(_bytes!),
                                width: 250,
                                height: 250,
                                fit: BoxFit.contain,
                              )),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                      ),
                      child: Row(
                        children: List.generate(menuItems.length, (index) {
                          return menuItems[index];
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
                                        "\$ ${updateCurrencyValue((Globals.instance.brb.greenBalance ?? BigInt.from(0)) / BigInt.from(10).pow(9))}",
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
                            const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text("Your Takamaka Address:",
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold))
                                ]),
                            const SizedBox(height: 5),
                            SizedBox(
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: walletAddress == null
                                    ? const CircularProgressIndicator()
                                    : Text(walletAddress!,
                                        softWrap: true,
                                        maxLines: 10,
                                        style: const TextStyle(
                                            color: Colors.white)),
                              ),
                            ),
                            const SizedBox(height: 20),
                            crc == null
                                ? const CircularProgressIndicator()
                                : Column(
                                    children: [
                                      const Row(
                                        children: [
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
                                  ),
                            const SizedBox(height: 20),
                            selectedIndex == null
                                ? const CircularProgressIndicator()
                                : Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text("Your Wallet Index: ",
                                              style: TextStyle(
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
                                              controller:
                                                  _selectedIndexController,
                                              onChanged: (value) => {
                                                _selectedIndexController.text =
                                                    value,
                                                _selectedIndexController
                                                        .selection =
                                                    TextSelection.fromPosition(
                                                        TextPosition(
                                                            offset:
                                                                _selectedIndexController
                                                                    .text
                                                                    .length))
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
                                                        walletName,
                                                        dotenv.get(
                                                            'WALLET_EXTENSION'),
                                                        password);
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
                                                fetchMyObjects();
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
                                                model.generatedSeed =
                                                    kb!['seed'];
                                                model.recoveryWords =
                                                    kb!['words'];
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
                                    model.generatedSeed = "",
                                    model.recoveryWords = "",
                                    _initWalletInterface()
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
                    )
                  ],
                ),
              )),
    );
  }

  Future<void> fetchMyObjects() async {
    context.loaderOverlay.show();

    final response = await ConsumerHelper.doRequest(HttpMethods.GET,
        ApiList().apiMap[Globals.instance.selectedNetwork]!['changes']!, {});

    final myApiResponse = Changes.fromJson(jsonDecode(response));
    Globals.instance.changes = myApiResponse;

    BalanceRequestBean brb =
        BalanceRequestBean(Globals.instance.selectedFromAddress);

    final request = await ConsumerHelper.doRequest(
        HttpMethods.POST,
        ApiList().apiMap[Globals.instance.selectedNetwork]!['balance']!,
        brb.toJson());

    BalanceResponseBean brespb =
        BalanceResponseBean.fromJson(jsonDecode(request));

    Globals.instance.brb = brespb;
    context.loaderOverlay.hide();
  }

  String updateCurrencyValue(double value) {
    try {
      double usdTk = Globals.instance.changes.changes[2].value;

      return (value * usdTk).toStringAsFixed(2);
    } catch (exception) {
      return "0";
    }
  }
}
