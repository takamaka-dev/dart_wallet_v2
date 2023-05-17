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
            padding: const EdgeInsets.all(70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(color: Styles.takamakaColor, width: 1.0),
                      right: BorderSide(color: Styles.takamakaColor, width: 1.0),
                      top: BorderSide(color: Styles.takamakaColor, width: 1.0),
                      bottom: BorderSide(color: Styles.takamakaColor, width: 1.0)
                    )
                  ),
                  width: double.infinity,
                  child: CupertinoButton(
                      color: Colors.grey.shade200,
                      onPressed: () => {
                        Navigator.of(context).push(CupertinoPageRoute<void>(
                            builder: (BuildContext context) {
                              return const BlobFile();
                            }))
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(height: 10),
                            Text('Upload File', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                            SizedBox(height: 20),
                            Icon(CupertinoIcons.doc_on_clipboard, color: Colors.black54),
                            SizedBox(height: 10),

                          ]))
                ),
                const SizedBox(height: 60),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Styles.takamakaColor, width: 1.0),
                          right: BorderSide(color: Styles.takamakaColor, width: 1.0),
                          top: BorderSide(color: Styles.takamakaColor, width: 1.0),
                          bottom: BorderSide(color: Styles.takamakaColor, width: 1.0)
                      )
                  ),
                  width: double.infinity,
                  child: CupertinoButton(
                      color: Colors.grey.shade200,
                      onPressed: () => {
                        Navigator.of(context).push(CupertinoPageRoute<void>(
                            builder: (BuildContext context) {
                              return const BlobFile();
                            }))
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(height: 10),
                            Text('Upload Simple Text', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                            SizedBox(height: 20),
                            Icon(CupertinoIcons.text_bubble_fill, color:Colors.black54),
                            SizedBox(height: 10),

                          ])),
                ),
                const SizedBox(height: 60),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          left: BorderSide(color: Styles.takamakaColor, width: 1.0),
                          right: BorderSide(color: Styles.takamakaColor, width: 1.0),
                          top: BorderSide(color: Styles.takamakaColor, width: 1.0),
                          bottom: BorderSide(color: Styles.takamakaColor, width: 1.0)
                      )
                  ),
                  width: double.infinity,
                  child: CupertinoButton(
                      color: Colors.grey.shade200,
                      onPressed: () => {},
                      child:Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            SizedBox(height: 10),
                            Text('Upload Rich Text', style: TextStyle(color: Colors.black54, fontWeight: FontWeight.w500)),
                            SizedBox(height: 20),
                            Icon(CupertinoIcons.doc_chart_fill, color: Colors.black54),
                            SizedBox(height: 10),

                          ])),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
