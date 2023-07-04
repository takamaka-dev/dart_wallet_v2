import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
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
    ));
  }

  Future<void> verifyTransactionAndCallback(
      Result scannedData, bool isLoginAction) async {
    context.loaderOverlay.show();
    // Future<void> verifyTransactionAndCallback(String code, bool isLoginAction) async {
    String code = scannedData.text;
    final response = await ConsumerHelper.doRequest(
        HttpMethods.POST,
        isLoginAction
            ? ApiList().apiMap[Globals.instance.selectedNetwork]!["trxgetnoncedata"]!
            : ApiList().apiMap[Globals.instance.selectedNetwork]!['trxgetnoncedataselect']!,
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
      await ConsumerHelper.doRequest(HttpMethods.POST,
          ApiList().apiMap[Globals.instance.selectedNetwork]!["txverifywebsite"]!, trx);
      context.loaderOverlay.hide();
      Globals.instance.resetAndOpenPage(context);
      /*if (responseJson['res'] == true) {
        Globals.instance.resetAndOpenPage(context);
      }*/
      // inviarla in post a takamaka
    }
  }
}
