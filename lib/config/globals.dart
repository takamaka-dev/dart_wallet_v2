library globals;

import 'package:flutter/cupertino.dart';

class Globals extends ChangeNotifier {
  String selectedNetwork = "";
  String generatedSeed = "";
  List<String> words = [];

  void setGeneratedSeed(String seed) {
    generatedSeed = seed;
    notifyListeners();
  }


}