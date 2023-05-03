library globals;

import 'package:flutter/cupertino.dart';

class Globals with ChangeNotifier {
  String selectedNetwork = "";
  String _generatedSeed = "";
  List<String> words = [];

  String get generatedSeed => _generatedSeed;

  set generatedSeed(String seed) {
    _generatedSeed = seed;
    notifyListeners();
  }

}