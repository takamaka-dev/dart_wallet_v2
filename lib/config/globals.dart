library globals;

import 'package:flutter/cupertino.dart';

class Globals extends ChangeNotifier {
  String selectedNetwork = "";
  String _generatedSeed = "";
  List<String> words = [];

  String get generatedSeed => _generatedSeed;

  set generatedSeed(String seed) {
    generatedSeed = seed;
    print('Inside Global generated seed');
    print('seed: $seed');
    notifyListeners();
  }

}