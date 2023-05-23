import 'dart:convert';
import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/screens/tag_list/tagList.dart';
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
    String message = _controllerMessage.text.trim();

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
          title: const Text('Alert'),
          content: Text(
              'The transaction is ready for confirmation ${Globals.instance.feeBean}'),
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
                    HttpMethods.POST,
                    ApiList().apiMap[Globals.instance.selectedNetwork]!["tx"]!,
                    Globals.instance.ti.toJson());
                if (response == '{"TxIsVerified":"true"}') {
                  Navigator.pop(context);
                  Navigator.of(context).restorablePush(_dialogBuilder);
                }
                context.loaderOverlay.hide();
              },
              child: const Text('Confirm'),
            )
          ],
        );
      },
    );
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Success!'),
          content: Text(
              'The transaction has been properly verified!' "\n Sith: " +
                  Globals.instance.sith),
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
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderError(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Error!'),
          content: const Text(
              'To upload a text you have to type something in the Text Area!'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Ok'),
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
                        children: const <Widget>[
                          Text("Send Simple Text",
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
                  Row(
                    children: [
                      Text("Insert message here below:",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CupertinoTextField(
                    maxLines: 20,
                    controller: _controllerMessage,
                    placeholder: "Type here your text",
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text("Insert tags:",
                          style: TextStyle(
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.w600)),
                      _errorEmptyTag == true
                          ? const Text("Error: the input is empty!",
                              style: TextStyle(color: Colors.red))
                          : const Text("")
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Flexible(
                        child: CupertinoTextField(
                          placeholder: "Words",
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
                  TagList(tags, Colors.white, MainAxisAlignment.spaceBetween, Styles.takamakaColor.withOpacity(0.9), Colors.red.shade300, deleteTag),
                  const SizedBox(height: 30),
                  CupertinoButton(
                      color: Styles.takamakaColor,
                      onPressed: () => {doBlobText()},
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(CupertinoIcons.paperplane),
                            SizedBox(width: 10),
                            Text('Send')
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
