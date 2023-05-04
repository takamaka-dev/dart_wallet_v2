import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class Pay extends StatelessWidget {
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
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        // Codice da eseguire al clic del bottone
                      },
                      child: const CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.green,
                        child: Text("TKG", style: TextStyle(color: Colors.white))
                      ),
                    ),
                    const SizedBox(width: 30),
                    TextButton(
                      onPressed: () {
                        // Codice da eseguire al clic del bottone
                      },
                      child: const CircleAvatar(
                        radius: 30.0,
                        backgroundColor: Colors.grey,
                        child: Text("TKR", style: TextStyle(color: Colors.black54))
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                const CupertinoTextField(
                  textAlign: TextAlign.center,
                  placeholder: "Amount (EUR)",
                ),
                SizedBox(height: 20),
                const CupertinoTextField(
                  textAlign: TextAlign.center,
                  placeholder: "TKG",
                ),
                SizedBox(height: 20),
                const CupertinoTextField(
                  decoration: BoxDecoration(

                    color: CupertinoColors.white,
                  ),
                  placeholder: 'Inserisci qui il testo',
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
