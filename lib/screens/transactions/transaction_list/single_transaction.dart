import 'package:dart_wallet_v2/config/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:url_launcher/url_launcher.dart';

class SingleTransaction extends StatelessWidget {
  const SingleTransaction(this.tm, {super.key});

  final TransactionResult tm;

  @override
  Widget build(BuildContext context) {
    IconData i = CupertinoIcons.paperplane;

    if (tm.transactionType == "STAKE") {
      i = CupertinoIcons.hammer;
    } else if (tm.transactionType == "STAKE_UNDO") {
      i = CupertinoIcons.hand_raised_fill;
    } else if (tm.transactionType == "BLOB") {
      i = CupertinoIcons.doc_on_clipboard_fill;
    }

    DateTime date = DateTime.fromMillisecondsSinceEpoch(tm.notBefore);
    String formattedDateTime = DateFormat("dd/MM/yyyy HH:mm").format(date);

    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                    child: Container(
                  padding: const EdgeInsets.all(12),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      border: const Border(
                        right: BorderSide(width: 1.0, color: Colors.white),
                      )),
                  child: CupertinoButton(
                      color: Colors.grey.shade300,
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                      borderRadius: BorderRadius.zero,
                      onPressed: () => {
                            _launchURLBrowser(
                                ApiList().apiMap['test']!['trxinfoexp']! +
                                    tm.sith)
                          },
                      child: Column(children: [
                        Row(
                          children: [
                            Icon(i, color: Styles.takamakaColor),
                            const SizedBox(width: 10),
                            Text(
                              tm.transactionType.replaceAll("_", " "),
                              style: TextStyle(
                                  color: Styles.takamakaColor, fontSize: 17),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 1.0,
                          color: Styles.takamakaColor.withOpacity(0.25),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formattedDateTime,
                                style: TextStyle(color: Styles.takamakaColor)),
                            Text(
                                "TKG ${tm.greenValue == null ? BigInt.from(0) : tm.greenValue! / BigInt.from(10).pow(9)}",
                                style: TextStyle(color: Styles.takamakaColor)),
                            const SizedBox(width: 10),
                            Text(
                                "TKR ${tm.redValue == null ? BigInt.from(0) : tm.redValue! / BigInt.from(10).pow(9)}",
                                style: TextStyle(color: Styles.takamakaColor))
                          ],
                        )
                      ])),
                ))
              ],
            ),
            const SizedBox(height: 20)
          ],
        ));
  }

  Future<dynamic> _launchURLBrowser(String s) async {
    Uri url = Uri.parse(s);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
