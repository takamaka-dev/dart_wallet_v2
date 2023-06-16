import 'dart:convert';
import 'dart:io';
import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/api/changes.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

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
    ));
  }

  Future<void> verifyTransactionAndCallback(Result scannedData) async {
    SimpleKeyPair skp = await WalletUtils.getNewKeypairED25519(
        Globals.instance.generatedSeed);
    //String tbJson = scannedData.text;
    //Ale ho harcodato il tb json letto dal qr ma non funzia
    String tbJson = '{"message":"{\"from\":\"JzBcX2bJqZA82gOisilXwPd6szu1pnJMYZ7mamF1OgE.\",\"to\":\"7vI0N7nqWJqmpe3ehfIK40Ucc_xOBAePFzgLGXTUul0.\",\"message\":\"2d8ar9drby_1021r99rqaq64b3z_q950\",\"notBefore\":1686923883509,\"redValue\":null,\"greenValue\":null,\"transactionType\":\"BLOB\",\"transactionHash\":\"x_GuF5yc9vJKoXq2BXIYqEgI6RIJQ-CcmVHh-GEcDd0.\",\"epoch\":null,\"slot\":null}","publicKey":"JzBcX2bJqZA82gOisilXwPd6szu1pnJMYZ7mamF1OgE.","randomSeed":"OfdQ","signature":"Spd12Uee9dftxLMtRQabJ5OsPJBTfZDY2QaZb7flWHXq0Aq0aGufZD7ZCM-MUQFPYIGgdHfKqeqZ0OGKPIaUCQ..","walletCypher":"Ed25519BC"}';
    TransactionBox verifiedTB =
    await TkmWallet.verifyTransactionIntegrity(tbJson, skp);
    bool isVerified = verifiedTB.valid??false;

    if(isVerified){
      InternalTransactionBean itb = BuilderItb.blob(
          Globals.instance.selectedFromAddress,
          tbJson,
          TKmTK.getTransactionTime());
      TransactionBean tb2 = await TkmWallet.createGenericTransaction(
          itb, skp, Globals.instance.selectedFromAddress);
      String tb2Json = jsonEncode(tb2.toJson());
      TransactionBox payload =
      await TkmWallet.verifyTransactionIntegrity(tb2Json, skp);
      final response = await ConsumerHelper.doRequest(
          HttpMethods.POST,
          ApiList().apiMap[Globals.instance.selectedNetwork]!["txverifywebsite"]!,
          payload.toJson());
      print(response);
      // inviarla in post a takamaka
    }

  }
}
