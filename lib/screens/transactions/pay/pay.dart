import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:glass/glass.dart';

class Pay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CupertinoButton(
                onPressed: () {
                  Navigator.pop(
                      context); // Navigate back when back button is pressed
                },
                child: const Icon(Icons.arrow_back),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [Text("From"), SizedBox(width: 1000), Text("To")],
          )
        ],
      ),
    ).asGlass(
            tintColor: Colors.transparent,
            clipBorderRadius: BorderRadius.circular(15.0)));
  }
}
