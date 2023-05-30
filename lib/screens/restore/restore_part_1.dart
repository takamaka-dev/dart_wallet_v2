import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/restore/restore.dart';
import 'package:dart_wallet_v2/screens/tag_list/tagList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:loader_overlay/loader_overlay.dart';

class RestorePart1 extends StatefulWidget {
  const RestorePart1({super.key});

  @override
  State<StatefulWidget> createState() => _RestorePart1State();
}

class _RestorePart1State extends State<RestorePart1> {
  final TextEditingController _tagController = TextEditingController();

  List<String>? wallets = Globals.instance.wallets.isEmpty ? null : Globals.instance.wallets;

  bool _errorEmptyTag = false;

  void updateTagsList(String value) {
    if (value.isNotEmpty) {
      setState(() {
        _errorEmptyTag = false;
        Globals.instance.restoreNewWalletsWords.add(value);
      });
    } else {
      setState(() {
        _errorEmptyTag = true;
      });
    }
    _tagController.text = "";
  }

  void deleteTag(String tag) {
    setState(() {
      Globals.instance.restoreNewWalletsWords
          .removeWhere((element) => element == tag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: CupertinoPageScaffold(
          child: Container(
              child: Column(
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
                              child: const Icon(Icons.arrow_back, color: Colors.white),
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Restore wallet (1/2)",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                          ],
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.all(50),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const SizedBox(
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Import your wallet right now!",
                                      softWrap: true,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 10))),
                          const SizedBox(height: 30),
                          const SizedBox(
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                      "You are about to begin the process of importing an existing wallet, now you will need to enter all 25 words you have saved, to check if they are exactly those in your wallet.",
                                      softWrap: true,
                                      maxLines: 10))),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Flexible(
                                child: CupertinoTextField(
                                  placeholder: "Words",
                                  controller: _tagController,
                                  onChanged: (value) => {},
                                ),
                              ),
                              CupertinoButton(
                                  child: const Icon(CupertinoIcons.plus),
                                  onPressed: () => {updateTagsList(_tagController.text)})
                            ],
                          ),
                          const SizedBox(height: 10),
                          TagList(
                              Globals.instance.restoreNewWalletsWords,
                              Colors.white,
                              MainAxisAlignment.spaceBetween,
                              Styles.takamakaColor.withOpacity(0.9),
                              Colors.red.shade300,
                              deleteTag),

                          const SizedBox(height: 30),

                          CupertinoButton(
                              color: Globals.instance.restoreNewWalletsWords.length < 25 ? Styles.takamakaColor.withOpacity(0.5) : Styles.takamakaColor,
                              onPressed: () => {
                                if (Globals.instance.restoreNewWalletsWords.length == 25)
                                  {
                                    Navigator.of(context).push(CupertinoPageRoute<void>(
                                        builder: (BuildContext context) {
                                          return  Restore(onRefresh: () {
                                            FileSystemUtils.getWalletsInWalletsDir(
                                                dotenv.get('WALLET_FOLDER'), dotenv.get('WALLET_EXTENSION'))
                                                .then((value) => {
                                              setState(() {
                                                wallets = value;
                                              })
                                            });
                                          });
                                        }))
                                  }
                              },
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(CupertinoIcons.arrow_right),
                                  SizedBox(width: 5),
                                  Text('Proceed'),
                                ],
                              ))

                        ]),
                  )
                ],
              )))
    );
  }
}
