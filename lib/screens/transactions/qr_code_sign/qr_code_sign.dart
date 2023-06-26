import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/dart.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';

class QrCodeSign extends StatefulWidget {
  const QrCodeSign({super.key});

  @override
  State<StatefulWidget> createState() => _QrCodeSignState();
}

class _QrCodeSignState extends State<QrCodeSign> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: QRCodeDartScanView(
      scanInvertedQRCode: false,
      // enable scan invert qr code ( default = false)
      typeScan: TypeScan.live,
      // if TypeScan.takePicture will try decode when click to take a picture (default TypeScan.live)
      onCapture: (Result result) {
        verifyTransactionAndCallback(result, Globals.instance.isLoginSign);
      },
    )
        // Column(children: [
        //   // CupertinoButton(
        //   //   onPressed: () {
        //   //     verifyTransactionAndCallback('z26x6xc727xba0cb16c1ax2rp4p2q2r1', Globals.instance.isLoginSign);
        //   //   }, child: Text("Click to test login"),
        //   // ),
        //   // CupertinoButton(
        //   //   onPressed: () {
        //   //     verifyTransactionAndCallback('pbqry_z21p4qrzya69cz1yb1d7z438p8', false);
        //   //   }, child: Text("Click to test select"),
        //   // )
        // ],)

        );
  }

  Future<void> verifyTransactionAndCallback(
      Result scannedData, bool isLoginAction) async {
    context.loaderOverlay.show();
    // Future<void> verifyTransactionAndCallback(String code, bool isLoginAction) async {
    String code = scannedData.text;
    final response = await ConsumerHelper.doRequest(
        HttpMethods.POST,
        isLoginAction
            ? ApiList().apiMap['local']!["trxgetnoncedata"]!
            : ApiList().apiMap['local']!['trxgetnoncedataselect']!,
        {
          'nonce': code,
          'selected_address':
              isLoginAction ? '' : Globals.instance.selectedFromAddress
        });

    final myApiResponse =
        RequestChallengeFromNetty.fromJson(jsonDecode(response));

    var myApiDataResponse = myApiResponse.data.values.toList();

    SimpleKeyPair skp =
        await WalletUtils.getNewKeypairED25519(Globals.instance.generatedSeed);

    TransactionBean tb = TransactionBean();
    tb.message = myApiDataResponse[0];
    tb.publicKey = myApiDataResponse[1];
    tb.randomSeed = myApiDataResponse[2];
    tb.signature = myApiDataResponse[3];
    tb.walletCypher = myApiDataResponse[4];

    // SimplePublicKey pubk = await skp.extractPublicKey();

    String tbJson = jsonEncode(tb);
    bool isVerified = await CryptoMisc.verifySign(tb);

    if (isVerified) {
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
      Map<String, dynamic> trx = {'trx_to_verify': signTbJson};
      final response = await ConsumerHelper.doRequest(HttpMethods.POST,
          ApiList().apiMap['local']!["txverifywebsite"]!, trx);
      Map<String, dynamic> responseJson = jsonDecode(response);
      context.loaderOverlay.hide();
      Globals.instance.resetAndOpenPage(context);
      /*if (responseJson['res'] == true) {
        Globals.instance.resetAndOpenPage(context);
      }*/
      // inviarla in post a takamaka
    }
  }

}
