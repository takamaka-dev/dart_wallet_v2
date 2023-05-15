import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
                        const Text("TKG: ", style: TextStyle(fontWeight: FontWeight.bold),),
                        Text(nodeStakeAmount.toString())
                      ],
                    ),
                    SizedBox(height: 10),
                    Text(
                      alias,
                      softWrap: true,
                      textAlign: TextAlign.left,
                      overflow: TextOverflow.visible, // new
                    ),
                  ],
                ),
              )
            ),

           /* Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("TKG: ", textAlign: TextAlign.start,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(nodeStakeAmount.toString()),
                  ],
                ),





                *//*Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Text("Alias: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Flexible(child: Text(
                      alias,
                      softWrap: false,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )),
                  ],
                )*//*
              ],
            )*/
          ],
        ),
        SizedBox(height: 30)
      ],
    );
  }
}
