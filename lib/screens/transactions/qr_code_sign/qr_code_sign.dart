import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class QrCodeSign extends StatefulWidget {
  const QrCodeSign({super.key});

  @override
  State<StatefulWidget> createState() => _QrCodeSignState();
}

class _QrCodeSignState extends State<QrCodeSign> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child:
    CupertinoButton(
        color: Styles.takamakaColor,
        onPressed: verifyTransactionAndCallback,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(CupertinoIcons.plus),
            const SizedBox(width: 10),
            const Text('testScan'),
          ],
        )),
      // QRCodeDartScanView(
      //   scanInvertedQRCode: true, // enable scan invert qr code ( default = false)
      //   typeScan: TypeScan.live, // if TypeScan.takePicture will try decode when click to take a picture (default TypeScan.live)
      //   // takePictureButtonBuilder: (context,controller,isLoading){ // if typeScan == TypeScan.takePicture you can customize the button.
      //   //    if(loading) return CircularProgressIndicator();
      //   //    return ElevatedButton(
      //   //       onPressed:controller.takePictureAndDecode,
      //   //       child:Text('Take a picture'),
      //   //    );
      //   // }
      //   // resolutionPreset: = QrCodeDartScanResolutionPreset.high,
      //   // formats: [ // You can restrict specific formats.
      //   //   BarcodeFormat.QR_CODE,
      //   //   BarcodeFormat.AZTEC,
      //   //   BarcodeFormat.DATA_MATRIX,
      //   //   BarcodeFormat.PDF_417,
      //   //   BarcodeFormat.CODE_39,
      //   //   BarcodeFormat.CODE_93,
      //   //   BarcodeFormat.CODE_128,
      //   //  BarcodeFormat.EAN_8,
      //   //   BarcodeFormat.EAN_13,
      //   // ],
      //   onCapture: (Result result) {
      //     verifyTransactionAndCallback(result);
      //     // do anything with result
      //     // result.text
      //     // result.rawBytes
      //     // result.resultPoints
      //     // result.format
      //     // result.numBits
      //     // result.resultMetadata
      //     // result.time
      //   },
      // )
    );
  }

  // Future<void> verifyTransactionAndCallback(Result scannedData) async {
  Future<void> verifyTransactionAndCallback() async {

    SimpleKeyPair skp = await WalletUtils.getNewKeypairED25519(
        Globals.instance.generatedSeed);

    TransactionBean tb = TransactionBean();
    tb.message ="{\"from\":\"JzBcX2bJqZA82gOisilXwPd6szu1pnJMYZ7mamF1OgE.\",\"to\":\"PmwBpB9fY0oyA_IZbYeOBr5ImIfN7ZiXs12elWQcyno.\",\"message\":\"pz2ac9pd5r5xx9ayr0a29c_486r590x3\",\"notBefore\":1693419858900,\"redValue\":null,\"greenValue\":null,\"transactionType\":\"BLOB\",\"transactionHash\":\"qJ7uZEDqtt6g_QLYYhEcSXjx7oIp95eTvC5RqB7X9rI.\",\"epoch\":null,\"slot\":null}";
    tb.publicKey = "JzBcX2bJqZA82gOisilXwPd6szu1pnJMYZ7mamF1OgE.";
    tb.randomSeed ="Q18g";
    tb.signature = "9DX0CvF-A-UEDAH_ZQrkuOSzn-yZj58wqtWLV0i2sYE3L_4PLiGqwnlKPoyGgeuHjJps2Z-R-Oaeu96MkC-2AQ..";
    tb.walletCypher = "Ed25519BC";

    // SimplePublicKey pubk = await skp.extractPublicKey();

    String tbJson = jsonEncode(tb);
    bool isVerified = await CryptoMisc.verifySign(tb);

    if(isVerified){
      InternalTransactionBean itb = BuilderItb.blobSignRequest(
          Globals.instance.selectedFromAddress,
          tbJson,
          TKmTK.getTransactionTime());
      TransactionBean gtb = await TkmWallet.createGenericTransaction(
          itb, skp, Globals.instance.selectedFromAddress);
      String tb2Json = jsonEncode(gtb);
      TransactionBox signedTbox =
      await TkmWallet.verifyTransactionIntegrity(tb2Json, skp);
      String signTbJson = jsonEncode(signedTbox);
      Map<String, dynamic> trx = {
        'trx_to_verify': signTbJson
      };
      final response = await ConsumerHelper.doRequest(
          HttpMethods.POST,
          ApiList().apiMap['local']!["txverifywebsite"]!,
          trx);
      Map<String, dynamic> responseJson = jsonDecode(response);
      if(responseJson['res'] == true){
        Navigator.of(context).restorablePush(_dialogBuilderSuccess);
      }
      // inviarla in post a takamaka
    }
  }
  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderSuccess(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Success').tr(),
          content: const Text('Success').tr(),
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
}