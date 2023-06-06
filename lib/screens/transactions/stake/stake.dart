import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/stake/single_node.dart';
import 'package:easy_localization/easy_localization.dart';
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
  List<Widget> _widgetList = <Widget>[];
  bool errorLoading = false;

  @override
  void initState() {
    _initStakeInterface();
    //fetchMyObjects();
    super.initState();
  }

  Future<void> _initStakeInterface() async {
    try {
      context.loaderOverlay.show();
      List<Widget> temp = [];

      final response = await ConsumerHelper.doRequest(
          HttpMethods.GET,
          ApiList().apiMap[Globals.instance.selectedNetwork]!["listnodes"]!,
          {});

      Globals.instance.snl = StakeNodeList.fromJsonArray(response);

      final responseAcceptedBets = await ConsumerHelper.doRequest(
          HttpMethods.GET,
          ApiList().apiMap[Globals.instance.selectedNetwork]!['acceptedbets']!,
          {});

      AcceptedBetByHolderListBean abhl =
          AcceptedBetByHolderListBean.fromJsonArray(responseAcceptedBets);

      Map<String, int> coveredBets = {};

      abhl.acceptedBets.forEach((element) {
        if (element.holderAddressURL64 ==
            Globals.instance.selectedFromAddress) {
          coveredBets = element.coveredBets;
        }
      });

      if (Globals.instance.snl.stakeNodeLists.isNotEmpty) {
        for (int i = 0; i < Globals.instance.snl.stakeNodeLists.length; i++) {
          StakeNode sn = Globals.instance.snl.stakeNodeLists[i];

          String qTeslaAddressVersion = await ConsumerHelper.doRequest(
              HttpMethods.GET,
              ApiList().apiMap[Globals.instance.selectedNetwork]![
                      'stakenodemap']! +
                  sn.shortAddress,
              {});

          BigInt amountTkBigint = BigInt.from(0);
          if (coveredBets.containsKey(qTeslaAddressVersion)) {
            amountTkBigint = BigInt.from(coveredBets[qTeslaAddressVersion]!);
          }

          temp.add(SingleNode(
              qTeslaAddressVersion,
              sn.shortAddress,
              sn.alias,
              StringUtilities.convertFromBase64ToBase64UrlUnsafe(sn.identicon),
              TKmTK.bigIntDoubleTK(amountTkBigint)));
        }
      }

      setState(() {
        _widgetList = temp;
      });
      context.loaderOverlay.hide();
    } catch (e) {
      print(e);
      context.loaderOverlay.hide();
      setState(() {
        errorLoading = true;
      });
    }
  }

  @pragma('vm:entry-point')
  static Route<Object?> _dialogBuilderError(
      BuildContext context, Object? arguments) {
    return CupertinoDialogRoute<void>(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('alert').tr(),
          content: const Text('genericError').tr(),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () async {
                Globals.instance.resetAndOpenPage(context);
              },
              child: const Text('ok').tr(),
            )
          ],
        );
      },
    );
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Stake",
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
                  children: tryRenderNodes(),
                ))
          ],
        ),
      ),
    );
  }

  List<Widget> tryRenderNodes() {
    if (_widgetList.isEmpty && !errorLoading) {
      return [const CircularProgressIndicator()];
    }
    if (errorLoading) {
      return [
        const Text('genericError').tr(),
        CupertinoButton(
            child: const Text("ok").tr(),
            onPressed: () => {Globals.instance.resetAndOpenPage(context)})
      ];
    }

    return _widgetList;
  }
}
