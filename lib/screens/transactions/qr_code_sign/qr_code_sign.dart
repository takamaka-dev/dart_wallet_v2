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
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class QrCodeSign extends StatefulWidget {
  const QrCodeSign({super.key});

  @override
  State<StatefulWidget> createState() => _QrCodeSignState();
}

class _QrCodeSignState extends State<QrCodeSign> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(child:
       QRCodeDartScanView(
         scanInvertedQRCode: true, // enable scan invert qr code ( default = false)
         typeScan: TypeScan.live, // if TypeScan.takePicture will try decode when click to take a picture (default TypeScan.live)
         // takePictureButtonBuilder: (context,controller,isLoading){ // if typeScan == TypeScan.takePicture you can customize the button.
         //    if(loading) return CircularProgressIndicator();
         //    return ElevatedButton(
         //       onPressed:controller.takePictureAndDecode,
         //       child:Text('Take a picture'),
         //    );
         // }
         // resolutionPreset: = QrCodeDartScanResolutionPreset.high,
         // formats: [ // You can restrict specific formats.
         //   BarcodeFormat.QR_CODE,
         //   BarcodeFormat.AZTEC,
         //   BarcodeFormat.DATA_MATRIX,
         //   BarcodeFormat.PDF_417,
         //   BarcodeFormat.CODE_39,
         //   BarcodeFormat.CODE_93,
         //   BarcodeFormat.CODE_128,
         //  BarcodeFormat.EAN_8,
         //   BarcodeFormat.EAN_13,
         // ],
         onCapture: (Result result) {
           verifyTransactionAndCallback(result);
           // do anything with result
           // result.text
           // result.rawBytes
           // result.resultPoints
           // result.format
           // result.numBits
           // result.resultMetadata
           // result.time
         },
       )
    );
  }

  Future<void> verifyTransactionAndCallback(Result scannedData) async {
    SimpleKeyPair skp = await WalletUtils.getNewKeypairED25519(
        Globals.instance.generatedSeed);

    TransactionBean tb = TransactionBean();
    tb.message ="{\"from\":\"Ns559nPpty-fEOzV1Xx5sm49ITFTlNDAezW2BETh75c.\",\"to\":\"\",\"message\":\"7d383r_9_b6p42ycz4qq5610b3xq_7yp\",\"notBefore\":1693441529415,\"redValue\":null,\"greenValue\":null,\"transactionType\":\"BLOB\",\"transactionHash\":\"TzR1k8-ksBG0yvZ_3GsypXo1PtEniASi-82YyMXZnkc.\",\"epoch\":null,\"slot\":null}";
    tb.publicKey = "Ns559nPpty-fEOzV1Xx5sm49ITFTlNDAezW2BETh75c.";
    tb.randomSeed ="xLmY";
    tb.signature = "yhrYv-iN6tj6Kt69duvr4flWQOsU40pEqw0nywsWo4bsW3DT66YllAUGynTCStxD6l9s6fuP31geXz2Piz4TAw..";
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