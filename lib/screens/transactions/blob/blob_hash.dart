import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/screens/transactions/splash_page/error.dart';
import 'package:dart_wallet_v2/screens/transactions/splash_page/success.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:pointycastle/digests/sha3.dart';

import '../../../config/styles.dart';

class BlobHash extends StatefulWidget {
  const BlobHash({super.key});

  @override
  State<StatefulWidget> createState() => _BlobHashState();
}

class _BlobHashState extends State<BlobHash> {
  File? _selectedFile;
  void _openFilePicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File selectedFile = File(result.files.single.path!);
      setState(() {
        _selectedFile = selectedFile;
      });
    }
  }

  FeeBean currentFeeBean = FeeBean();
  late TransactionInput ti;
  Future<bool> _initBlobInterface() async {
    setState(() {
      _selectedFile = null;
    });

    return true;
  }

  @override
  void initState() {
    _initBlobInterface();
    //fetchMyObjects();
    super.initState();
  }

  Future<void> doBlobHash() async {

    context.loaderOverlay.show();

    File f = File(_selectedFile!.path);
    Uint8List bytes = f.readAsBytesSync();
    SHA3Digest sha3digest = SHA3Digest(256);
    Uint8List hash = sha3digest.process(Uint8List.fromList(bytes));
    String b64UrlHash = StringUtilities.convertFromBase64ToBase64UrlSafe(base64.encode(hash));

    InternalTransactionBean itb = BuilderItb.blob(
        Globals.instance.selectedFromAddress,
        b64UrlHash,
        TKmTK.getTransactionTime());

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
              'The transaction is ready for confirmation. '
                  'The cost of the transaction will be DISK: ${Globals.instance.feeBean.disk},'
                  'MEM  ${Globals.instance.feeBean.memory},'
                  'CPU  ${Globals.instance.feeBean.cpu}'),
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

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
                        Text("Upload File Hash",
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
                CupertinoButton(
                    color: Styles.takamakaColor,
                    onPressed: _openFilePicker,
                    child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(CupertinoIcons.doc_fill),
                          SizedBox(width: 10),
                          Text('Select File')
                        ])),
                const SizedBox(height: 16),
                Text(
                  _selectedFile != null ? 'Selected file: ${_selectedFile!.path}' : 'No file selected',
                ),
                const SizedBox(height: 30),
                CupertinoButton(
                    color: Styles.takamakaColor,
                    onPressed: () => {
                      doBlobHash()
                    },
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
          ),
        ],
      ),
    );
  }
}
