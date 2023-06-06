import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  static const routeName = '/';

  final State<Splash> state;

  const Splash(this.state, {Key? key}) : super(key: key);

  @override
  State<Splash> createState() => state;
}
