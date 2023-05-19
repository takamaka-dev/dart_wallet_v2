import 'package:flutter/cupertino.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class SingleTransaction extends StatelessWidget {
  const SingleTransaction(this.tm, {super.key});

  final TransactionResult tm;

  @override
  Widget build(BuildContext context) {

    IconData i = CupertinoIcons.paperplane;

    if (tm.transactionType == "STAKE") {
      i = CupertinoIcons.hand_raised_fill;
    }

    return Row(
      children: [

      ],
    );
  }

}