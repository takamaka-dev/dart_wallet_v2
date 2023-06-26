import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/qr_code_sign/qr_code_sign.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PreSelectQrScan extends StatelessWidget {
  const PreSelectQrScan({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: CupertinoPageScaffold(
          child: Container(
            constraints: const BoxConstraints(
                minHeight: 900
            ),
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
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text("qrselection",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white))
                                .tr(),
                          ],
                        ),
                      ],
                    )),
              ),
              Container(
                padding: const EdgeInsets.all(70),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: Styles.takamakaColor.withOpacity(0.7),
                                    width: 2.0),
                                right: BorderSide(
                                    color: Styles.takamakaColor.withOpacity(0.7),
                                    width: 2.0),
                                top: BorderSide(
                                    color: Styles.takamakaColor.withOpacity(0.7),
                                    width: 2.0),
                                bottom: BorderSide(
                                    color: Styles.takamakaColor.withOpacity(0.7),
                                    width: 2.0))),
                        width: double.infinity,
                        child: CupertinoButton(
                            color: Colors.grey.shade200,
                            onPressed: () => {
                              Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                      builder: (BuildContext context) {
                                        Globals.instance.isLoginSign = true;
                                        return const QrCodeSign();
                                      }))
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10),
                                  const Text('signForLogin',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500))
                                      .tr(),
                                  const SizedBox(height: 20),
                                  const Icon(CupertinoIcons.doc_on_clipboard,
                                      color: Colors.black54),
                                  const SizedBox(height: 10),
                                ]))),
                    const SizedBox(height: 60),
                    Container(
                        decoration: BoxDecoration(
                            border: Border(
                                left: BorderSide(
                                    color: Styles.takamakaColor.withOpacity(0.7),
                                    width: 2.0),
                                right: BorderSide(
                                    color: Styles.takamakaColor.withOpacity(0.7),
                                    width: 2.0),
                                top: BorderSide(
                                    color: Styles.takamakaColor.withOpacity(0.7),
                                    width: 2.0),
                                bottom: BorderSide(
                                    color: Styles.takamakaColor.withOpacity(0.7),
                                    width: 2.0))),
                        width: double.infinity,
                        child: CupertinoButton(
                            color: Colors.grey.shade200,
                            onPressed: () => {
                              Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                      builder: (BuildContext context) {
                                        Globals.instance.isLoginSign = false;
                                        return const QrCodeSign();
                                      }))
                            },
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 10),
                                  const Text('loginSelectWallet',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500))
                                      .tr(),
                                  const SizedBox(height: 20),
                                  const Icon(CupertinoIcons.doc_on_clipboard,
                                      color: Colors.black54),
                                  const SizedBox(height: 10),
                                ]))),
                  ],
                ),
              )
            ],
          ),
        ),
          )
          );
  }
}