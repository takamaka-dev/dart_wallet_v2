import 'package:cryptography/cryptography.dart';
import 'package:dart_wallet_v2/config/api/changes.dart';
import 'package:flutter/cupertino.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

import 'api/single_change.dart';

class Globals with ChangeNotifier {

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
  }

  BalanceResponseBean _brb = BalanceResponseBean();

  BalanceResponseBean get brb => _brb;

  set brb(BalanceResponseBean value) {
    _brb = value;
    super.notifyListeners();
  }

  String _selectedFromAddress = "";

  String get selectedFromAddress => _selectedFromAddress;

  set selectedFromAddress(String value) {
    _selectedFromAddress = value;
    super.notifyListeners();
  }

  String _generatedSeed = "";
  String _recoveryWords = "";
  String _selectedNetwork = "";

  String get selectedNetwork => _selectedNetwork;

  set selectedNetwork(String value) {
    _selectedNetwork = value;
    super.notifyListeners();
  }

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