import 'package:dart_wallet_v2/config/globals.dart';
import 'package:dart_wallet_v2/config/styles.dart';
import 'package:dart_wallet_v2/screens/restore/restore.dart';
import 'package:dart_wallet_v2/screens/tag_list/tagList.dart';
import 'package:easy_localization/easy_localization.dart';
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
      if (value.split(" ").isNotEmpty) {
        setState(() {
          _errorEmptyTag = false;
          Globals.instance.restoreNewWalletsWords.addAll(value.split(" "));
        });
      } else {
        setState(() {
          _errorEmptyTag = false;
          Globals.instance.restoreNewWalletsWords.add(value);
        });
      }


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

  var wordsLocale = tr('wordsLocale');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: ChangeNotifierProvider.value(
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Text('restoreWallet1',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.white))
                                      .tr(),
                                ],
                              ),
                            ],
                          )),
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: const Text('importWalletrn',
                                            softWrap: true,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                            maxLines: 10)
                                        .tr())),
                            const SizedBox(height: 15),
                            SizedBox(
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: const Text('beginImportProcess',
                                            softWrap: true, maxLines: 10)
                                        .tr())),
                            const SizedBox(height: 10),
                            _errorEmptyTag == true
                                ? const Text('errorInputEmpty',
                                        style: TextStyle(color: Colors.red))
                                    .tr()
                                : const Text(""),
                            Row(children: [
                              Flexible(
                                child: CupertinoTextField(
                                  placeholder: wordsLocale,
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
                                Colors.transparent,
                                deleteTag,
                                true),
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(CupertinoIcons.arrow_right),
                                    const SizedBox(width: 5),
                                    const Text('proceed').tr(),
                                  ],
                                )),
                            const SizedBox(height: 30)
                          ]),
                    )
                  ],
                ))))));
  }
}