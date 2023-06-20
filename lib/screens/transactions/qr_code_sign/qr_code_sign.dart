import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
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
    tb.message ="{\"from\":\"PmwBpB9fY0oyA_IZbYeOBr5ImIfN7ZiXs12elWQcyno.\",\"to\":\"7Y-QAQYbUqpuwH3-_P0jLa3fd8zAtjCaw1AkVCHuIDU.\",\"message\":\"ciao\",\"notBefore\":1683706093246,\"redValue\":null,\"greenValue\":1000000000,\"transactionType\":\"PAY\",\"transactionHash\":\"Y1pEdKSDqQ4jxbVieVPdak-h9jxVi_wt-GGQnq2oUcM.\",\"epoch\":null,\"slot\":null}";
    tb.publicKey = "PmwBpB9fY0oyA_IZbYeOBr5ImIfN7ZiXs12elWQcyno.";
    tb.randomSeed ="D2CG";
    tb.signature = "pY2KAdaB6LgOIP91tYw7rHEFSb87tVboXhKBtndmZPy03HEsL_YvEzHrN1a7BEr1g1nfi9FEdPUiJGIHSF1mBw..";
    tb.walletCypher = "Ed25519BC";

    String tbJson = jsonEncode(tb);
    TransactionBox verifiedTB =
    await TkmWallet.verifyTransactionIntegrity(tbJson, skp);
    bool isVerified = verifiedTB.valid??false;

    if(isVerified){
       InternalTransactionBean itb = BuilderItb.blob(
           Globals.instance.selectedFromAddress,
           tbJson,
           TKmTK.getTransactionTime());
       TransactionBean gtb = await TkmWallet.createGenericTransaction(
           itb, skp, Globals.instance.selectedFromAddress);
       String tb2Json = jsonEncode(gtb);
       TransactionBox signedTbox =
       await TkmWallet.verifyTransactionIntegrity(tb2Json, skp);
       Map<String, dynamic> stb = signedTbox.tb!.toJson();
       final response = await ConsumerHelper.doRequest(
           HttpMethods.POST,
           ApiList().apiMap['local']!["txverifywebsite"]!,
           stb);
      // inviarla in post a takamaka
    }

  }
}
