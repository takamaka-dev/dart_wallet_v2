import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class Wallet extends StatefulWidget{
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
  }

class _WalletState extends State<Wallet>{

  Int8List? _bytes;

  void _getBytes(content) async {
    final Uint8List data = await WalletUtils.testBitMap(content);
    setState(() {
      _bytes = data.buffer.asInt8List();
      print(_bytes);
    });
  }

  @override
  void initState() {
    _getBytes("yzrhYG_yVL_Cswdg6tiTEx0nTKSPwcfd75J4BP2n0C4.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Wallet'),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [Center(
              child: _bytes == null
                  ? const CircularProgressIndicator()
                  : Image.memory(
                Uint8List.fromList(_bytes!),
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              )),
          CupertinoTextField(
            onChanged: (value) => _getBytes(value),
          )],
        ));
  }


}