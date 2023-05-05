import 'package:dart_wallet_v2/config/api/changes.dart';
import 'package:flutter/cupertino.dart';

import 'api/single_change.dart';

class Globals with ChangeNotifier {
  String _generatedSeed = "";
  String _recoveryWords = "";
  Changes _changes = Changes(changes: []);


  Changes get changes => _changes;

  set changes(Changes value) {
    _changes = value;
  }

  String get recoveryWords => _recoveryWords;

  set recoveryWords(String value) {
    _recoveryWords = value;
    super.notifyListeners();
  }

  static final Globals _instance = Globals._privateConstructor();

  static Globals get instance => _instance;

  String get generatedSeed => _generatedSeed;

  Globals._privateConstructor();

  set generatedSeed(String seed) {
    _generatedSeed = seed;
    super.notifyListeners();
  }

}