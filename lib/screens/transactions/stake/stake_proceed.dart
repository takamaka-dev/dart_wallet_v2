import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/screens/transactions/splash_page/error.dart';
import 'package:dart_wallet_v2/screens/transactions/splash_page/success.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../config/styles.dart';

class StakeProceed extends StatefulWidget {
  StakeProceed(this.qteslaAddress, this.shortAddress, {super.key});

  String qteslaAddress;
  String shortAddress;

  @override
  State<StatefulWidget> createState() =>
      _StakeProceedState(qteslaAddress, shortAddress);
}

class _StakeProceedState extends State<StakeProceed> {
  _StakeProceedState(this.qteslaAddress, this.shortAddress);

  String qteslaAddress;
  String shortAddress;
  Int8List? _bytes;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller_2 = TextEditingController();
  final TextEditingController _controllerToAddress = TextEditingController();
  final TextEditingController _controllerToAddressQtesla =
      TextEditingController();
  final TextEditingController _controllerMessage = TextEditingController();

  FeeBean currentFeeBean = FeeBean();
  late TransactionInput ti;

  Future<bool> _initStakeProceedInterface() async {
    _controllerToAddress.text = shortAddress;

    setState(() {
      _bytes = null;
      shortAddress = shortAddress;
    });

    _controllerToAddressQtesla.text = qteslaAddress;
    updateIdenticon(_controllerToAddressQtesla.text);

    return true;
  }

  @override
  void initState() {
    _initStakeProceedInterface();
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
    double tkUsd = Globals
        .instance.changes.changes[Globals.instance.selectedCurrency].value;
    double convertedValue = double.parse(value);

    convertedValue *= (1 / tkUsd);

    setState(() {
      _controller.text =
          "$convertedValue ${Globals.instance.currencyMappingReverse[Globals.instance.selectedCurrency]!}";
    });
  }

  void updateCurrencyValue(String value) {
    double usdTk = Globals
        .instance.changes.changes[Globals.instance.selectedCurrency].value;
    double convertedValue = double.parse(value);

    convertedValue = convertedValue * usdTk;

    setState(() {
      _controller_2.text =
          "$convertedValue ${Globals.instance.currencyMappingReverse[Globals.instance.selectedCurrency]!}";
    });
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

  Future<void> doStake() async {
    if (_controller.text.isEmpty) {
      Navigator.of(context).restorablePush(_dialogBuilderError);
    } else {
      try {
        int.parse(_controller.text);

        InternalTransactionBean itb;

        itb = BuilderItb.stake(
            Globals.instance.selectedFromAddress,
            _controllerToAddressQtesla.text,
            TKmTK.unitStringTK(_controller.text),
            _controllerMessage.text,
            TKmTK.getTransactionTime());

        SimpleKeyPair skp = await WalletUtils.getNewKeypairED25519(
            Globals.instance.generatedSeed);

        TransactionBean tb = await TkmWallet.createGenericTransaction(
            itb, skp, Globals.instance.selectedFromAddress);

        String tbJson = jsonEncode(tb.toJson());
        String payHexBody = StringUtilities.convertToHex(tbJson);

        ti = TransactionInput(payHexBody);

        Globals.instance.ti = ti;

        TransactionBox payTbox =
            await TkmWallet.verifyTransactionIntegrity(tbJson, skp);

        String? singleInclusionTransactionHash =
            payTbox.singleInclusionTransactionHash;

        Globals.instance.sith = singleInclusionTransactionHash!;

        FeeBean feeBean = TransactionFeeCalculator.getFeeBean(payTbox);

        Globals.instance.feeBean = feeBean;

        context.loaderOverlay.hide();

        if (feeBean.disk != null) {
          Navigator.of(context).restorablePush(_dialogBuilderPreConfirm);
        }
      } catch (_) {
        Navigator.of(context).restorablePush(_dialogBuilderPreConfirm);
      }
    }
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderPreConfirm(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('alert').tr(),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('trxCost').tr(),
              Text('${'disk'.tr()}${' ${Globals.instance.feeBean.disk},'
                  'mem'.tr()} ${Globals.instance.feeBean.memory},${'cpu'.tr()} ${Globals.instance.feeBean.cpu}')
            ],
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('abort').tr(),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                context.loaderOverlay.show();
                final response = await ConsumerHelper.doRequest(
                    HttpMethods.POST,
                    ApiList().apiMap[Globals.instance.selectedNetwork]!["tx"]!,
                    Globals.instance.ti.toJson());
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
              child: const Text('confirm').tr(),
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
                          Text("stakeProceed".tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white)),
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
                    readOnly: true,
                    placeholder: "address".tr(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _controller.text = "";
                            _controller_2.text = "";
                          });
                        },
                        child: const CircleAvatar(
                            radius: 30.0,
                            backgroundColor: Colors.green,
                            child: Text("TKG",
                                style: TextStyle(color: Colors.white))),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    textAlign: TextAlign.center,
                    controller: _controller_2,
                    readOnly: true,
                    onChanged: (value) => {updateTokenValue(value)},
                    placeholder:
                    "${"amount".tr()} (${Globals.instance.currencyMappingReverse[Globals.instance.selectedCurrency]!})",
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    textAlign: TextAlign.center,
                    controller: _controller,
                    onTap: () => {_controller.text = ""},
                    onChanged: (value) => {updateCurrencyValue(value)},
                    placeholder: "TKG",
                  ),
                  const SizedBox(height: 20),
                  CupertinoTextField(
                    maxLines: 10,
                    controller: _controllerMessage,
                    placeholder: 'enterTextHere'.tr(),
                  ),
                  const SizedBox(height: 30),
                  CupertinoButton(
                      color: Styles.takamakaColor,
                      onPressed: () => {doStake()},
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(CupertinoIcons.paperplane),
                            SizedBox(width: 10),
                            Text('Stake')
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
