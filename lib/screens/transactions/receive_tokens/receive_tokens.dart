import 'dart:convert';
import 'package:dart_wallet_v2/config/api/changes.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:easy_localization/easy_localization.dart';
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
    double tkUsd = Globals
        .instance.changes.changes[Globals.instance.selectedCurrency].value;
    double convertedValue = double.parse(value);

    if (currentToken == "TKG") {
      convertedValue *= (1 / tkUsd);
    }

    setState(() {
      _controller.text = "$convertedValue ${currentToken!}";
    });
  }

  void doGenerateQr() {
    if (_controller.text.isEmpty) {
      Navigator.of(context).restorablePush(_dialogBuilderError);
    } else {
      try {
        int.parse(_controller.text);
        String color = "green";
        if (currentToken == "TKR") {
          color = "red";
        }

        BigInt value = TKmTK.unitStringTK(
            _controller.text.split(" ${currentToken!.toUpperCase()}")[0]);

        ReceiveToken rt = ReceiveToken(color, value.toString(),
            Globals.instance.selectedFromAddress, _controllerMessage.text);

        setState(() {
          qr = jsonEncode(rt.toJson());
        });
      } catch (_) {
        Navigator.of(context).restorablePush(_dialogBuilderError);
      }
    }
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderError(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('alert').tr(),
          content: const Text('invalidInput').tr(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("receiveTokens",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.white))
                              .tr(),
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
                            _controller.text = "";
                            _controller_2.text = "";
                            qr = "";
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
                            _controller.text = "";
                            _controller_2.text = "";
                            qr = "";
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
                    readOnly: true,
                    onChanged: (value) => {
                      updateTokenValue(value),
                      setState(() {
                        qr = "";
                      })
                    },
                    placeholder:
                        "${"amount".tr()} (${Globals.instance.currencyMappingReverse[Globals.instance.selectedCurrency]!})",
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    textAlign: TextAlign.center,
                    controller: _controller,
                    onTap: () => {_controller.text = ""},
                    onChanged: (value) => {
                      updateCurrencyValue(value),
                      setState(() {
                        qr = "";
                      })
                    },
                    placeholder: currentToken == "TKG" ? "TKG" : "TKR",
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    maxLines: 10,
                    controller: _controllerMessage,
                    onChanged: (value) => {
                      setState(() {
                        qr = "";
                      })
                    },
                    placeholder: 'enterTextHere'.tr(),
                  ),
                  const SizedBox(height: 30),
                  CupertinoButton(
                      color: Styles.takamakaColor,
                      onPressed: () => {doGenerateQr()},
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.qrcode),
                            const SizedBox(width: 10),
                            const Text('generateQr').tr()
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
    double usdTk = Globals
        .instance.changes.changes[Globals.instance.selectedCurrency].value;
    double convertedValue = double.parse(value);

    if (currentToken == "TKG") {
      convertedValue = convertedValue * usdTk;
    }

    setState(() {
      _controller_2.text =
          "$convertedValue ${Globals.instance.currencyMappingReverse[Globals.instance.selectedCurrency]!}";
    });
  }
}
