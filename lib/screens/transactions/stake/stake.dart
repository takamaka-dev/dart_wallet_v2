import 'dart:convert';

import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/stake/single_node.dart';
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

  @override
  void initState() {
    _initStakeInterface();
    //fetchMyObjects();
    super.initState();
  }

  Future<void> _initStakeInterface() async {
    context.loaderOverlay.show();
    List<Widget> temp = [];

    final response = await ConsumerHelper.doRequest(
        HttpMethods.POST, ApiList().apiMap['test']!["listnodes"]!, {});

    Globals.instance.snl = StakeNodeList.fromJsonArray(response);

    if (Globals.instance.snl.stakeNodeLists.isNotEmpty) {
      for (int i = 0; i < Globals.instance.snl.stakeNodeLists.length; i++) {
        StakeNode sn = Globals.instance.snl.stakeNodeLists[i];
        temp.add(SingleNode(sn.alias.isEmpty ? sn.shortAddress : sn.alias, StringUtilities.convertFromBase64ToBase64UrlUnsafe(sn.identicon), BigInt.from(5)));
      }
    }

    setState(() {
      _widgetList = temp;
    });
    context.loaderOverlay.hide();

  }

  Future<void> doUnStake() async {
    InternalTransactionBean itb;


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
                children: tryRenderNodes(),
              )
            )
          ],
        ),
      ),
    );
  }

  List<Widget> tryRenderNodes() {
    if (_widgetList.isEmpty) {
      return [const CircularProgressIndicator()];
    }

    return _widgetList;

  }

}
