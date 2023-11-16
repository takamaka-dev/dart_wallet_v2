import 'package:dart_wallet_v2/config/database/metatransaction.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/blob/blob_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleMetatransaction extends StatelessWidget {
  const SingleMetatransaction(this.mtrx,{super.key});

  final Metatransaction mtrx;

  void _showAlertDialog(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) =>
          CupertinoAlertDialog(
            title: const Text('Alert'),
            content: Text("Login first!"),
            actions: <CupertinoDialogAction>[
              CupertinoDialogAction(

                /// This parameter indicates this action is the default,
                /// and turns the action's text to bold text.
                isDefaultAction: true,
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Ok'),
              )
            ],
          ),
    );
  }


  @override
  Widget build(BuildContext context) {
    IconData i = CupertinoIcons.doc_fill;

    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.topLeft,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: const Border(
                            right: BorderSide(width: 1.0, color: Colors.white),
                          )),
                      child: CupertinoButton(
                          color: Colors.grey.shade300,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                          borderRadius: BorderRadius.zero,
                          onPressed: () => {
                            Globals.instance.generatedSeed.isEmpty?
                          _showAlertDialog(context):Navigator.of(context).push(
                                CupertinoPageRoute<void>(builder: (BuildContext context) {
                                  return const BlobText();
                                }))},
                          child: Column(children: [
                            Row(
                              children: [
                                Icon(i, color: Styles.takamakaColor),
                                const SizedBox(width: 10),
                                Text(mtrx.jsonHash),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Container(
                              height: 1.0,
                              color: Styles.takamakaColor.withOpacity(0.25),
                            ),
                            const SizedBox(height: 10),
                          ])),
                    ))
              ],
            ),
            const SizedBox(height: 20)
          ],
        ));
  }
}
