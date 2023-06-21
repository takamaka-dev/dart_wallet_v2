import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';
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
    tb.message ="{\"from\":\"5Ra-N-s9zJqgoAzrKxWZ3O9oluhP_WYL3K46IRJU2X4.\",\"to\":\"eTMddu48tLU2uNmB_husTiRzmDLFG3e63n2aTi7N4Vg.\",\"message\":\"pullus\",\"notBefore\":1687271102595,\"redValue\":500,\"greenValue\":null,\"transactionType\":\"PAY\",\"transactionHash\":\"TpjZSrvV32pGscCmse1zhoPWPSyjbJbZKjDHSEjKIE8.\",\"epoch\":null,\"slot\":null}";
    tb.publicKey = "5Ra-N-s9zJqgoAzrKxWZ3O9oluhP_WYL3K46IRJU2X4.";
    tb.randomSeed ="BOIA";
    tb.signature = "p9wT0khsrhgt5Jlm_N0JuGEMD-a6CZpm-cFE5yu4eWmaLvF4-jQbYUeSRdxedpmchD8pSKdUXnJgUM-C4UOTBw..";
    tb.walletCypher = "Ed25519BC";

    // SimplePublicKey pubk = await skp.extractPublicKey();

    String tbJson = jsonEncode(tb);
    bool isVerified = await CryptoMisc.verifySign(tb);

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