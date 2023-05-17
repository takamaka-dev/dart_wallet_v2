import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/stake/stake_proceed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SingleNode extends StatelessWidget {
  SingleNode(this.qteslaAddress, this.shortAddress, this.alias,
      this.identicon, this.nodeStakeAmount,
      {super.key});

  final String qteslaAddress;
  final String shortAddress;
  final String alias;
  final String identicon;
  final double nodeStakeAmount;
  late TransactionInput ti;

  Future<void> doUnStake(context) async {
    InternalTransactionBean itb;
    itb = BuilderItb.stakeUndo(
        Globals.instance.selectedFromAddress,
        "Stake undo",
        TKmTK.getTransactionTime());

    SimpleKeyPair skp =
    await WalletUtils.getNewKeypairED25519(Globals.instance.generatedSeed);

    TransactionBean tb = await TkmWallet.createGenericTransaction(
        itb, skp, Globals.instance.selectedFromAddress);

    String tbJson = jsonEncode(tb.toJson());
    String payHexBody = StringUtilities.convertToHex(tbJson);

    ti = TransactionInput(payHexBody);

    Globals.instance.ti = ti;

    TransactionBox payTbox = await TkmWallet.verifyTransactionIntegrity(tbJson, skp);

    String? singleInclusionTransactionHash = payTbox.singleInclusionTransactionHash;

    Globals.instance.sith = singleInclusionTransactionHash!;

    FeeBean feeBean = TransactionFeeCalculator.getFeeBean(payTbox);

    Globals.instance.feeBean = feeBean;

    if (feeBean.disk != null) {
      Navigator.of(context).restorablePush(_dialogBuilderPreConfirm);
    }
  }


  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderPreConfirm(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Alert'),
          content: Text('The transaction is ready for confirmation ${Globals.instance.feeBean}'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Abort'),
            ),
            CupertinoDialogAction(
              onPressed: () async {
                context.loaderOverlay.show();
                final response = await ConsumerHelper.doRequest(
                    HttpMethods.POST, ApiList().apiMap[Globals.instance.selectedNetwork]!["tx"]!, Globals.instance.ti.toJson());
                if (response == '{"TxIsVerified":"true"}') {
                  context.loaderOverlay.hide();
                  Navigator.pop(context);
                  Navigator.of(context).restorablePush(_dialogBuilder);
                }
              },
              child: const Text('Confirm'),
            )
          ],
        );
      },
    );
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilder(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Success!'),
          content: Text('The transaction has been properly verified!' "\n Sith: " + Globals.instance.sith),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('Thank you'),
            )
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border(
                  left: BorderSide(
                      color: nodeStakeAmount == 0
                          ? Colors.transparent
                          : Colors.green.shade200,
                      width: 5.0))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20),
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
                    CupertinoPageRoute<void>(builder: (BuildContext context) {
                  return StakeProceed(qteslaAddress, shortAddress);
                }));
              },
              color: Styles.takamakaColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(CupertinoIcons.add_circled_solid),
                  SizedBox(width: 10),
                  Text("Open")
                ],
              ),
            )),
        const SizedBox(height: 20),
        nodeStakeAmount > 0
            ? SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                    color: Styles.takamakaColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(CupertinoIcons.trash, color: Colors.white),
                        SizedBox(width: 10),
                        Text(
                          "Undo staking",
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    ),
                    onPressed: () => {
                      doUnStake(context)
                    }))
            : const Text(""),

        /**/

        const SizedBox(height: 30)
      ],
    );
  }
}
