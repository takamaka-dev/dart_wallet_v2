import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stake extends StatefulWidget {
  const Stake({super.key});

  @override
  State<StatefulWidget> createState() => _StakeState();
}


class _StakeState extends State<Stake> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: CupertinoPageScaffold(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Text("Stake page")
            ]
          )
    ));
  }


}