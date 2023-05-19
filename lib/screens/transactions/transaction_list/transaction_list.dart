import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/transactions/transaction_list/single_transaction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<StatefulWidget> createState() => _TransactionListState();

}

class _TransactionListState extends State<TransactionList> {

  List<Widget> transactionList = [];


  Future<bool> _initTransactionListInterface() async {

    TransactionSearchInput tsi = TransactionSearchInput(50, "from", true, Globals.instance.selectedFromAddress);

    final response = await ConsumerHelper.doRequest(
        HttpMethods.POST, ApiList().apiMap[Globals.instance.selectedNetwork]!["listransactions"]!, tsi.toJson());

    TransactionResultList trl = TransactionResultList.fromJsonArray(response);

    trl.transactions.forEach((element) {
      transactionList.add(SingleTransaction(element));
    });

    setState(() {
      //transactionList = trl.transactions;
    });

    return true;
  }

  @override
  void initState() {
    _initTransactionListInterface();
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const <Widget>[
                          Text("Latest transactions",
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
                children: transactionList,
              ),
            )
          ],
        ),
      ),
    );
  }
}