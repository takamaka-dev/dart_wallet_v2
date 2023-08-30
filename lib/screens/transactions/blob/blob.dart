import 'package:dart_wallet_v2/screens/transactions/blob/blob_file.dart';
import 'package:dart_wallet_v2/screens/transactions/blob/blob_text.dart';
import 'package:dart_wallet_v2/screens/transactions/blob_metadata/blob_metadata.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/styles.dart';
import 'blob_hash.dart';

class Blob extends StatelessWidget {
  const Blob({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: CupertinoPageScaffold(
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
                        const Text("blobSelection",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white))
                            .tr(),
                      ],
                    ),
                  ],
                )),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            constraints: const BoxConstraints(
                minHeight: 700
            ),
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
                                return const BlobFile();
                              }))
                            },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              const Text('uploadFile',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500))
                                  .tr(),
                              const SizedBox(height: 20),
                              const Icon(CupertinoIcons.doc_on_clipboard,
                                  color: Colors.black54),
                              const SizedBox(height: 10),
                            ]))),
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
                                    return const BlobMetadata();
                                  }))
                        },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              const Text('blobFromJson',
                                  style: TextStyle(
                                      color: Colors.black54,
                                      fontWeight: FontWeight.w500))
                                  .tr(),
                              const SizedBox(height: 20),
                              const Icon(Icons.document_scanner_outlined,
                                  color: Colors.black54),
                              const SizedBox(height: 10),
                            ]))),
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
                                return const BlobHash();
                              }))
                            },
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 10),
                              const Text('uploadFileHash',
                                      style: TextStyle(
                                          color: Colors.black54,
                                          fontWeight: FontWeight.w500))
                                  .tr(),
                              const SizedBox(height: 20),
                              const Icon(CupertinoIcons.doc_on_clipboard,
                                  color: Colors.black54),
                              const SizedBox(height: 10),
                            ]))),
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
                            Navigator.of(context).push(CupertinoPageRoute<void>(
                                builder: (BuildContext context) {
                              return const BlobText();
                            }))
                          },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 10),
                            const Text('uploadSimpleText',
                                    style: TextStyle(
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500))
                                .tr(),
                            const SizedBox(height: 20),
                            const Icon(CupertinoIcons.text_bubble_fill,
                                color: Colors.black54),
                            const SizedBox(height: 10),
                          ])),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }
}
