import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/screens/tag_list/tagList.dart';
import 'package:dart_wallet_v2/screens/transactions/splash_page/error.dart';
import 'package:dart_wallet_v2/screens/transactions/splash_page/success.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../config/styles.dart';

class BlobText extends StatefulWidget {
  const BlobText({super.key});

  @override
  State<StatefulWidget> createState() => _BlobTextState();
}

class _BlobTextState extends State<BlobText> {
  List<String> tags = [];
  bool _errorEmptyTag = false;
  final TextEditingController _controllerMessage = TextEditingController();
  final TextEditingController _tagController = TextEditingController();

  FeeBean currentFeeBean = FeeBean();
  late TransactionInput ti;

  @override
  void initState() {
    super.initState();
  }

  void updateTagsList(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _errorEmptyTag = false;
        tags.add(value);
      });
    } else {
      setState(() {
        _errorEmptyTag = true;
      });
    }
    _tagController.text = "";
  }

  Future<void> doBlobText() async {
    String message = _controllerMessage.text;
    message = base64UrlEncode(utf8.encode(message));

    if (message.isEmpty) {
      Navigator.of(context).restorablePush(_dialogBuilderError);
    } else {
      context.loaderOverlay.show();
      InternalTransactionBean itb = BuilderItb.blob(
          Globals.instance.selectedFromAddress,
          message,
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
              Text('${'DISK:'.tr()}${' ${Globals.instance.feeBean.disk},'
                  'MEM:'.tr()} ${Globals.instance.feeBean.memory},${'CPU:'.tr()} ${Globals.instance.feeBean.cpu}')
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
                context.loaderOverlay.hide();
              },
              child: const Text('confirm').tr(),
            )
          ],
        );
      },
    );
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderError(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('error_excl').tr(),
          content: const Text(
              'warningTextArea').tr(),
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

  void deleteTag(String tag) {
    setState(() {
      tags.removeWhere((element) => element == tag);
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("sendSimpleText",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)).tr(),
                        ],
                      ),
                    ],
                  )),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text("insertMessage",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w600)).tr(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CupertinoTextField(
                    maxLines: 20,
                    controller: _controllerMessage,
                    placeholder: "typeText".tr(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Insert tags:",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w600)).tr(),
                      _errorEmptyTag == true
                          ?  Text("errorInputText".tr(),
                              style: const TextStyle(color: Colors.red))
                          : const Text("")
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        child: CupertinoTextField(
                          placeholder: "words".tr(),
                          onSubmitted: (String value) =>
                          {updateTagsList(value)},
                          controller: _tagController,
                          onChanged: (value) => {},
                        ),
                      ),
                      CupertinoButton(
                          child: const Icon(CupertinoIcons.plus),
                          onPressed: () =>
                              {updateTagsList(_tagController.text)})
                    ],
                  ),
                  const SizedBox(height: 10),
                  TagList(
                      tags,
                      Colors.white,
                      MainAxisAlignment.spaceBetween,
                      Styles.takamakaColor.withOpacity(0.9),
                      Colors.red.shade300,
                      deleteTag,
                      false),
                  const SizedBox(height: 30),
                  CupertinoButton(
                      color: Styles.takamakaColor,
                      onPressed: () => {doBlobText()},
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(CupertinoIcons.paperplane),
                            const SizedBox(width: 10),
                            const Text('send').tr()
                          ])),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
