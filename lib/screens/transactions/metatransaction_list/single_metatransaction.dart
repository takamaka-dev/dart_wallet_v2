import 'package:dart_wallet_v2/config/database/metatransaction.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SingleMetatransaction extends StatelessWidget {
  const SingleMetatransaction(this.mtrx,{super.key});

  final Metatransaction mtrx;

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
                            print("hi!")
                          },
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
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     Text(formattedDateTime,
                            //         style: TextStyle(color: Styles.takamakaColor)),
                            //     Text(
                            //         "TKG ${tm.greenValue == null ? BigInt.from(0) : tm.greenValue! / BigInt.from(10).pow(9)}",
                            //         style: TextStyle(color: Styles.takamakaColor)),
                            //     const SizedBox(width: 10),
                            //     Text(
                            //         "TKR ${tm.redValue == null ? BigInt.from(0) : tm.redValue! / BigInt.from(10).pow(9)}",
                            //         style: TextStyle(color: Styles.takamakaColor))
                            //   ],
                            // )
                          ])),
                    ))
              ],
            ),
            const SizedBox(height: 20)
          ],
        ));
  }
}
