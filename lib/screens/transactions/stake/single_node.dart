import 'dart:convert';

import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/stake/stake_proceed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class SingleNode extends StatelessWidget {
  const SingleNode(this.alias, this.identicon, this.nodeStakeAmount,
      {super.key});

  final String alias;
  final String identicon;
  final BigInt nodeStakeAmount;

  @override
  Widget build(BuildContext context) {
    /*return Row(
        children: const [
          Flexible(
            child: Text(
              'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
              style: TextStyle(fontSize: 58),
              softWrap: true,
              overflow: TextOverflow.visible, // new
            ),
          ),
        ],
      );*/

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.memory(
              Uint8List.fromList(base64.decode(identicon)),
              width: 128,
              height: 128,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Expanded(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            "TKG: ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(nodeStakeAmount.toString())
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        alias,
                        softWrap: true,
                        textAlign: TextAlign.left,
                        overflow: TextOverflow.visible, // new
                      ),
                    ],
                  ),
                )),
          ],
        ),
        const SizedBox(height: 20),
        Container(
            width: double.infinity,
            child: CupertinoButton(
              onPressed: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                        builder: (BuildContext context) {

                          return const StakeProceed();
                        }));
              },
              color: Styles.takamakaColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(CupertinoIcons.hand_point_right_fill),
                  SizedBox(width: 10),
                  Text("Select for staking")
                ],
              ),
            )),
        const SizedBox(height: 30)
      ],
    );
  }
}
