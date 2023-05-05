import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Navigate back when back button is pressed
                },
                child: const Icon(Icons.arrow_back),
              ),
              Container(
                  width: 100,
                  height: 60,
                  decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius:
                          BorderRadius.only(bottomLeft: Radius.circular(10))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(CupertinoIcons.paperplane,
                          size: 20, color: Colors.white),
                      SizedBox(width: 10),
                      Text("Pay", style: TextStyle(color: Colors.white))
                    ],
                  ))
            ],
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
                              style: TextStyle(color: currentToken == "TKR" ? Colors.white : Colors.black54))),
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
                InputTextWithAnimation()
                /*CupertinoTextField(
                  maxLines: 10,
                  placeholder: 'Enter your text here',

                ),*/
                /*const CupertinoTextField(
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                  ),
                  placeholder: 'Inserisci qui il testo',
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                )*/
              ],
            ),
          )
        ],
      ),
    );
  }
}

class InputTextWithAnimation extends StatefulWidget {
  @override
  _InputTextWithAnimationState createState() => _InputTextWithAnimationState();
}

class _InputTextWithAnimationState extends State<InputTextWithAnimation> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          width: 300.0,
          height: 60.0,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _isFocused ? Colors.blue : Colors.grey,
                width: 2.0,
              ),
            ),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Enter your text here',
              border: InputBorder.none,
            ),
            onChanged: (value) {},
            onTap: () {
              setState(() {
                _isFocused = true;
              });
            },
            onSubmitted: (value) {
              setState(() {
                _isFocused = false;
              });
            },
          ),
        ),
      ],
    );
  }
}
