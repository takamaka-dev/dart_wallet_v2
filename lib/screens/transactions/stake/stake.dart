import 'package:dart_wallet_v2/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Stake extends StatefulWidget {
  const Stake({super.key});

  @override
  State<StatefulWidget> createState() => _StakeState();
}


class _StakeState extends State<Stake> {

  @override
  void initState() {
    _initStakeInterface();
    //fetchMyObjects();
    super.initState();
  }

  Future<void> _initStakeInterface() async {
    context.loaderOverlay.show();
    final response = await ConsumerHelper.doRequest(
        HttpMethods.POST, ApiList().apiMap['test']!["listnodes"]!, {});
    if (response == '{"TxIsVerified":"true"}') {
      context.loaderOverlay.hide();
    }
  }


  Future<void> doStake() async {
    InternalTransactionBean itb;

    //context.loaderOverlay.show();

    /*itb = BuilderItb.pay(
        Globals.instance.selectedFromAddress,
        _controllerToAddress.text,
        TKmTK.unitStringTK(_controller.text),
        TKmTK.unitStringTK(_controller.text),
        _controllerMessage.text,
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

    FeeBean feeBean = TransactionFeeCalculator.getFeeBean(payTbox);

    Globals.instance.feeBean = feeBean;

    context.loaderOverlay.hide();

    if (feeBean.disk != null) {
      Navigator.of(context).restorablePush(_dialogBuilderPreConfirm);
    }*/
  }

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
                        child:
                        const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text("Stake section",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  )),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
              child: Column(
                children: [

                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}