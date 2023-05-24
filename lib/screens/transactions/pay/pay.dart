import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/screens/transactions/splash_page/error.dart';
import 'package:dart_wallet_v2/screens/transactions/splash_page/success.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../config/styles.dart';

class Pay extends StatefulWidget {
  const Pay({super.key});

  @override
  State<StatefulWidget> createState() => _PayState();
}

class _PayState extends State<Pay> {
  String? currentToken;
  Int8List? _bytes;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller_2 = TextEditingController();
  final TextEditingController _controllerToAddress = TextEditingController();
  final TextEditingController _controllerMessage = TextEditingController();

  FeeBean currentFeeBean = FeeBean();
  late TransactionInput ti;
  Future<bool> _initPayInterface() async {
    setState(() {
      currentToken = "TKG";
      _bytes = null;
    });

    return true;
  }

  @override
  void initState() {
    _initPayInterface();
    //fetchMyObjects();
    super.initState();
  }

  Future<void> updateIdenticon(String address) async {
    var bytesResult;
    if (address.isNotEmpty) {
      bytesResult = await WalletUtils.testBitMap(address).buffer.asInt8List();
    }

    setState(() {
      _bytes = bytesResult;
    });
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

  Future<void> doPay() async {
    InternalTransactionBean itb;

    //context.loaderOverlay.show();

    if (currentToken == "TKG") {
      itb = BuilderItb.pay(
          Globals.instance.selectedFromAddress,
          _controllerToAddress.text,
          TKmTK.unitStringTK(_controller.text.split(" TKG")[0]),
          TKmTK.unitTK(0),
          _controllerMessage.text,
          TKmTK.getTransactionTime());
    } else {
      itb = BuilderItb.pay(
          Globals.instance.selectedFromAddress,
          _controllerToAddress.text,
          TKmTK.unitTK(0),
          TKmTK.unitStringTK(_controller.text.split(" TKR")[1]),
          _controllerMessage.text,
          TKmTK.getTransactionTime());
    }

    SimpleKeyPair skp =
        await WalletUtils.getNewKeypairED25519(Globals.instance.generatedSeed);

    TransactionBean tb = await TkmWallet.createGenericTransaction(
        itb, skp, Globals.instance.selectedFromAddress);

    String tbJson = jsonEncode(tb.toJson());
    String payHexBody = StringUtilities.convertToHex(tbJson);

    ti = TransactionInput(payHexBody);

    Globals.instance.ti = ti;

    TransactionBox payTbox = await TkmWallet.verifyTransactionIntegrity(tbJson, skp);

    String? singleInclusionTransactionHash = payTbox.singleInclusionTransactionHash;

    Globals.instance.sith = singleInclusionTransactionHash!;

    FeeBean feeBean = TransactionFeeCalculator.getFeeBean(payTbox);

    Globals.instance.feeBean = feeBean;

    context.loaderOverlay.hide();

    if (feeBean.disk != null) {
      Navigator.of(context).restorablePush(_dialogBuilderPreConfirm);
    }

    /*final response = await ConsumerHelper.doRequest(
        HttpMethods.POST, ApiList().apiMap[Globals.instance.selectedNetwork]!["tx"]!, ti.toJson());
    print(response);

    if (response == '{"TxIsVerified":"true"}') {
      Navigator.of(context).restorablePush(_dialogBuilder);
    }*/
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderPreConfirm(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Alert'),
          content: Text('The transaction is ready for confirmation ${Globals.instance.feeBean}'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Abort'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                context.loaderOverlay.show();
                final response = await ConsumerHelper.doRequest(
                    HttpMethods.POST, ApiList().apiMap[Globals.instance.selectedNetwork]!["tx"]!, Globals.instance.ti.toJson());
                if (response == '{"TxIsVerified":"true"}') {
                  context.loaderOverlay.hide();
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      CupertinoPageRoute<void>(builder: (BuildContext context) {
                        return SuccessSplashPage(Globals.instance.sith);
                      }));
                } else {
                  context.loaderOverlay.hide();
                  Navigator.pop(context);
                  Navigator.of(context).push(
                      CupertinoPageRoute<void>(builder: (BuildContext context) {
                        return const ErrorSplashPage();
                      }));
                }
              },
              child: const Text('Confirm'),
            )
          ],
        );
      },
    );
  }

  /*@pragma('vm:entry-point')
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Success!'),
          content: Text('The transaction has been properly verified!' "\n Sith: " + Globals.instance.sith),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Thank you'),
            )
          ],
        );
      },
    );
  }*/

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
                          Text("Pay section",
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
                      child: _bytes == null
                          ? Icon(CupertinoIcons.qrcode,
                              color: Styles.takamakaColor, size: 100)
                          : Image.memory(
                              Uint8List.fromList(_bytes!),
                              width: 250,
                              height: 250,
                              fit: BoxFit.contain,
                            )),
                  const SizedBox(height: 50),
                  CupertinoTextField(
                    textAlign: TextAlign.center,
                    onChanged: (value) => {updateIdenticon(value)},
                    controller: _controllerToAddress,
                    placeholder: "Address",
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            currentToken = "TKG";
                            _controller.text = "";
                            _controller_2.text = "";
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
                      )
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
                      onPressed: () => {doPay()},
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.paperplane),
                            SizedBox(width: 10),
                            Text('Send')
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
}
