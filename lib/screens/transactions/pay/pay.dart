import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/styles.dart';

class Pay extends StatefulWidget {
  const Pay({super.key});

  @override
  State<StatefulWidget> createState() => _PayState();
}

class _PayState extends State<Pay> {
  String? currentToken;

  Future<bool> _initPayInterface() async {
    setState(() {
      currentToken = "TKG";
    });

    return true;
  }

  @override
  void initState() {
    _initPayInterface();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text("Pay section",
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
                const CupertinoTextField(
                  textAlign: TextAlign.center,
                  placeholder: "Address",
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentToken = "TKG";
                          print(currentToken);
                        });
                      },
                      child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor: currentToken == "TKG"
                              ? Colors.green
                              : Colors.grey,
                          child: const Text("TKG",
                              style: TextStyle(color: Colors.white))),
                    ),
                    const SizedBox(width: 30),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          currentToken = "TKR";
                          print(currentToken);
                        });
                      },
                      child: CircleAvatar(
                          radius: 30.0,
                          backgroundColor:
                              currentToken == "TKR" ? Colors.red : Colors.grey,
                          child: Text("TKR",
                              style: TextStyle(
                                  color: currentToken == "TKR"
                                      ? Colors.white
                                      : Colors.black54))),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                const CupertinoTextField(
                  textAlign: TextAlign.center,
                  placeholder: "Amount (EUR)",
                ),
                const SizedBox(height: 20),
                const CupertinoTextField(
                  textAlign: TextAlign.center,
                  placeholder: "TKG",
                ),
                const SizedBox(height: 20),
                const CupertinoTextField(
                  maxLines: 10,
                  placeholder: 'Enter your text here',
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
