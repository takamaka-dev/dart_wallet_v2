import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/restore/restore.dart';
import 'package:dart_wallet_v2/screens/tag_list/tagList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';
import 'package:provider/provider.dart';

class RestorePart1 extends StatefulWidget {
  const RestorePart1({super.key});

  @override
  State<StatefulWidget> createState() => _RestorePart1State();
}

class _RestorePart1State extends State<RestorePart1> {
  final TextEditingController _tagController = TextEditingController();
  final List<String> wordsDictionary = DictionaryReader.readDictionary();

  List<String> suggestions = [];

  List<String>? wallets =
      Globals.instance.wallets.isEmpty ? null : Globals.instance.wallets;

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

  List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(wordsDictionary);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: Globals.instance,
        child: Consumer<Globals>(
            builder: (context, model, child) => SingleChildScrollView(
                    child: CupertinoPageScaffold(
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
                                child: const Icon(Icons.arrow_back,
                                    color: Colors.white),
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
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
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
                            _errorEmptyTag == true
                                ? const Text("Error: the input is empty!",
                                    style: TextStyle(color: Colors.red))
                                : const Text(""),
                            const SizedBox(height: 10),
                            Row(children: [
                              Flexible(
                                child: CupertinoTextField(
                                  placeholder: "Words",
                                  onSubmitted: (String value) =>
                                      {updateTagsList(value)},
                                  onChanged: (value) {
                                    setState(() {
                                      // Filter suggestions based on input value
                                      suggestions = getSuggestions(value);
                                    });
                                  },
                                  controller: _tagController,
                                ),
                              ),
                              CupertinoButton(
                                  child: const Icon(CupertinoIcons.plus),
                                  onPressed: () =>
                                      {updateTagsList(_tagController.text)})
                            ]),
                            const SizedBox(height: 16.0),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                              ),
                              child: Column(
                                children:
                                    List.generate(suggestions.length, (index) {
                                  return Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      CupertinoButton(
                                          color: Styles.takamakaColor
                                              .withOpacity(0.1),
                                          alignment: Alignment.topLeft,
                                          padding: const EdgeInsets.fromLTRB(
                                              16.0, 0.0, 16.0, 0.0),
                                          borderRadius: BorderRadius.zero,
                                          onPressed: () => {
                                                _tagController.text = "",
                                                updateTagsList(
                                                    suggestions[index]),
                                                setState(() => suggestions = [])
                                              },
                                          child: Center(
                                              child: Text(suggestions[index],
                                                  style: const TextStyle(
                                                      color: Colors.black38,
                                                      fontWeight:
                                                          FontWeight.w600)))),
                                      const SizedBox(height: 10)
                                    ],
                                  );
                                  /*return Text(suggestions[index]);*/
                                }),
                              ),
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
                                color: Globals.instance.restoreNewWalletsWords
                                            .length <
                                        25
                                    ? Styles.takamakaColor.withOpacity(0.5)
                                    : Styles.takamakaColor,
                                onPressed: () => {
                                      if (Globals.instance
                                              .restoreNewWalletsWords.length ==
                                          25)
                                        {
                                          Navigator.of(context).push(
                                              CupertinoPageRoute<void>(builder:
                                                  (BuildContext context) {
                                            return Restore(onRefresh: () {
                                              FileSystemUtils
                                                      .getWalletsInWalletsDir(
                                                          dotenv.get(
                                                              'WALLET_FOLDER'),
                                                          dotenv.get(
                                                              'WALLET_EXTENSION'))
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
                )))));
  }
}
