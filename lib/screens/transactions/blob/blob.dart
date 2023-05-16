import 'dart:convert';
import 'dart:typed_data';
import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/screens/transactions/blob/blob_file.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../../config/styles.dart';

class Blob extends StatelessWidget {
  const Blob({super.key});

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
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text("Blob selection",
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CupertinoButton(
                      color: Styles.takamakaColor,
                      onPressed: () => {
                            Navigator.of(context).push(CupertinoPageRoute<void>(
                                builder: (BuildContext context) {
                              return const BlobFile();
                            }))
                          },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(CupertinoIcons.arrow_up_to_line_alt),
                            SizedBox(width: 10),
                            Text('Upload File')
                          ]))
                ]),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center

                    , children: [
                  CupertinoButton(
                      color: Styles.takamakaColor,
                      onPressed: () => {
                        Navigator.of(context).push(CupertinoPageRoute<void>(
                            builder: (BuildContext context) {
                              return const BlobFile();
                            }))
                      },
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(CupertinoIcons.arrow_up_to_line_alt),
                            SizedBox(width: 10),
                            Text('Upload Simple text')
                          ]))
                ]),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  CupertinoButton(
                      color: Styles.takamakaColor,
                      onPressed: () => {},
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(CupertinoIcons.arrow_up_to_line_alt),
                            SizedBox(width: 10),
                            Text('Upload Rich text')
                          ]))
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }
}
