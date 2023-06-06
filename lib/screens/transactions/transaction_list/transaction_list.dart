import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/transaction_list/single_transaction.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  bool errorLoading = false;

  List<Widget> transactionList = [];

  Future<bool> _initTransactionListInterface(int size) async {
    try {
      List<Widget> trxListTemp = [];
      context.loaderOverlay.show();
      TransactionSearchInput tsi = TransactionSearchInput(
          size, "from", true, Globals.instance.selectedFromAddress);

      final response = await ConsumerHelper.doRequest(
          HttpMethods.POST,
          ApiList()
              .apiMap[Globals.instance.selectedNetwork]!["listransactions"]!,
          tsi.toJson());

      TransactionResultList trl = TransactionResultList.fromJsonArray(response);

      trl.transactions.forEach((element) {
        trxListTemp.add(SingleTransaction(element));
      });

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

  @override
  void initState() {
    _initTransactionListInterface(50);
    //fetchMyObjects();
    super.initState();
  }

  List<String> filters = ["50", "100", "150", "200"];

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
                        children: <Widget>[
                          Text("latestTrx".tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white)),
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
                CupertinoButton(
                    color: Colors.grey.shade200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(CupertinoIcons.search,
                            color: Styles.takamakaColor.withOpacity(0.6)),
                        const SizedBox(width: 10),
                        Text("windowResultSize".tr(),
                            style: TextStyle(
                                color: Styles.takamakaColor.withOpacity(0.6)))
                      ],
                    ),
                    onPressed: () {
                      _showDialog(CupertinoPicker(
                        magnification: 1.22,
                        squeeze: 1.2,
                        useMagnifier: true,
                        itemExtent: 32.0,
                        onSelectedItemChanged: (int selectedItem) {
                          _initTransactionListInterface(
                              int.parse(filters[selectedItem]));
                        },
                        children:
                            List<Widget>.generate(filters.length, (int index) {
                          return Center(
                            child: Text(
                              filters[index],
                            ),
                          );
                        }),
                      ));
                    })
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
              child: Column(
                children: errorLoading ? [
                const Text('genericError').tr(),
                CupertinoButton(
                    child: const Text("ok").tr(),
                    onPressed: () => {Globals.instance.resetAndOpenPage(context)})
                ] : transactionList,
              ),
            )
          ],
        ),
      ),
    );
  }
}
