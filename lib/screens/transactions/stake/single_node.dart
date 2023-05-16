import 'dart:convert';

import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/stake/stake_proceed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SingleNode extends StatelessWidget {
  const SingleNode(this.qteslaAddress, this.shortAddress, this.alias, this.identicon, this.nodeStakeAmount,
      {super.key});

  final String qteslaAddress;
  final String shortAddress;
  final String alias;
  final String identicon;
  final double nodeStakeAmount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: nodeStakeAmount == 0 ? Colors.transparent : Colors.green.shade200,
                      width: 5.0
                  )
              )
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 20),
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
                          alias.isEmpty ? shortAddress : alias,
                          softWrap: true,
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.visible, // new
                        )
                      ],
                    ),
                  )),
            ],
          ),
        ),

        const SizedBox(height: 20),
        SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              onPressed: () {
                Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                        builder: (BuildContext context) {
                          return StakeProceed(qteslaAddress, shortAddress);
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
