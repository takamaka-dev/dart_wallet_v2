import 'package:dart_wallet_v2/config/database/metatransaction.dart';
import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/metatransaction_list/single_metatransaction.dart';
import 'package:dart_wallet_v2/screens/transactions/transaction_list/single_transaction.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:hive/hive.dart';

class MetatransactionList extends StatefulWidget {
  const MetatransactionList({super.key});

  @override
  State<StatefulWidget> createState() => _MetatransactionListState();
}

class _MetatransactionListState extends State<MetatransactionList> {
  bool errorLoading = false;

  List<Widget> transactionList = [];

  Future<bool> _initMetatransactionListInterface() async {
    try {
      List<Widget> trxListTemp = [];
      var box = await Hive.openBox('metatransaction');
      Iterable<Metatransaction> metatrxs = box.values.cast();
      for (Metatransaction metatrx in metatrxs) {
        trxListTemp.add(SingleMetatransaction(metatrx));
      }
      context.loaderOverlay.show();

      setState(() {
        transactionList = trxListTemp;
      });

      context.loaderOverlay.hide();

      return true;
    } catch (e) {
      context.loaderOverlay.hide();
      setState(() {
        errorLoading = true;
      });
      return false;
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
          height: 216,
          padding: const EdgeInsets.only(top: 6.0),
          // The Bottom margin is provided to align the popup above the system navigation bar.
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          // Provide a background color for the popup.
          color: CupertinoColors.systemBackground.resolveFrom(context),
          // Use a SafeArea widget to avoid system overlaps.
          child: SafeArea(
            top: false,
            child: child,
          ),
        ));
  }

  @override
  void initState() {
    _initMetatransactionListInterface();
    //fetchMyObjects();
    super.initState();
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
                          Text("Metatransactions",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("${"itemNumber".tr()} ${transactionList.length}"),
                const SizedBox(width: 10),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: errorLoading
                    ? [
                        const Text('genericError').tr(),
                        CupertinoButton(
                            child: const Text("ok").tr(),
                            onPressed: () =>
                                {Globals.instance.resetAndOpenPage(context)})
                      ]
                    : transactionList,
              ),
            )
          ],
        ),
      ),
    );
  }
}