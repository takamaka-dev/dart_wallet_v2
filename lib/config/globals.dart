import 'package:flutter/cupertino.dart';

class Globals with ChangeNotifier {
  String _generatedSeed = "";

  static final Globals _instance = Globals._privateConstructor();

  static Globals get instance => _instance;

  String get generatedSeed => _generatedSeed;

  Globals._privateConstructor();

  set generatedSeed(String seed) {
    _generatedSeed = seed;
    super.notifyListeners();
  }

}