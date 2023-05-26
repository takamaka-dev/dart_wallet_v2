import 'dart:convert';
import 'dart:typed_data';

import 'package:dart_wallet_v2/config/api/changes.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ReceiveTokens extends StatefulWidget {
  const ReceiveTokens({super.key});

  @override
  State<StatefulWidget> createState() => _ReceiveTokensState();
}

class _ReceiveTokensState extends State<ReceiveTokens> {
  String? currentToken;
  String qr = "";
  final TextEditingController _controller = TextEditingController();

  final TextEditingController _controller_2 = TextEditingController();
  final TextEditingController _controllerMessage = TextEditingController();

  Future<bool> _initPayInterface() async {
    setState(() {
      currentToken = "TKG";
    });

    return true;
  }

  @override
  void initState() {
    _initPayInterface();
    //fetchMyObjects();
    super.initState();
  }

  void updateTokenValue(String value) {
    double tkUsd = Globals.instance.changes.changes[2].value;
    double convertedValue = double.parse(value);

    if (currentToken == "TKG") {
      convertedValue *= (1 / tkUsd);
    }

    setState(() {
      _controller.text = "$convertedValue " + currentToken!;
    });
  }

  void doGenerateQr() {
    String color = "green";
    if (currentToken == "TKR") {
      color = "red";
    }

    BigInt val = BigInt.parse(_controller.text)*BigInt.from(10).pow(9);

    ReceiveToken rt = ReceiveToken(
        color,
        val.toString(),
        Globals.instance.selectedFromAddress,
        _controllerMessage.text
    );

    setState(() {
      qr = jsonEncode(rt.toJson());
    });

  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CupertinoPageScaffold(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Receive Tokens",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  )),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
              child: Column(
                children: [
                  Center(
                      child: qr.isEmpty
                          ? Icon(CupertinoIcons.qrcode,
                              color: Styles.takamakaColor, size: 100)
                          : WalletUtils.renderQrImage(qr)),
                  const SizedBox(height: 50),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            currentToken = "TKG";
                          });
                        },
                        child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: currentToken == "TKG"
                                ? Colors.green
                                : Colors.grey,
                            child: const Text("TKG",
                                style: TextStyle(color: Colors.white))),
                      ),
                      const SizedBox(width: 30),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            currentToken = "TKR";
                          });
                        },
                        child: CircleAvatar(
                            radius: 30.0,
                            backgroundColor: currentToken == "TKR"
                                ? Colors.red
                                : Colors.grey,
                            child: Text("TKR",
                                style: TextStyle(
                                    color: currentToken == "TKR"
                                        ? Colors.white
                                        : Colors.black54))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    textAlign: TextAlign.center,
                    controller: _controller_2,
                    onChanged: (value) => {updateTokenValue(value)},
                    placeholder: "Amount (USD)",
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    textAlign: TextAlign.center,
                    controller: _controller,
                    onChanged: (value) => {updateCurrencyValue(value)},
                    placeholder: currentToken == "TKG" ? "TKG" : "TKR",
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    maxLines: 10,
                    controller: _controllerMessage,
                    placeholder: 'Enter your text here',
                  ),
                  const SizedBox(height: 30),
                  CupertinoButton(
                      color: Styles.takamakaColor,
                      onPressed: () => {
                        doGenerateQr()
                      },
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.qrcode),
                            SizedBox(width: 10),
                            Text('Generate QR')
                          ])),
                  const SizedBox(height: 30),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> fetchMyObjects() async {
    context.loaderOverlay.show();

    final response = await ConsumerHelper.doRequest(HttpMethods.GET,
        ApiList().apiMap[Globals.instance.selectedNetwork]!['changes']!, {});

    final myApiResponse = Changes.fromJson(jsonDecode(response));
    Globals.instance.changes = myApiResponse;

    context.loaderOverlay.hide();
  }

  void updateCurrencyValue(String value) {
    double usdTk = Globals.instance.changes.changes[2].value;
    double convertedValue = double.parse(value);

    if (currentToken == "TKG") {
      convertedValue = convertedValue * usdTk;
    }

    setState(() {
      _controller_2.text = "$convertedValue USD";
    });
  }

}
