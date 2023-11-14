import 'dart:typed_data';

import 'package:dart_wallet_v2/config/api/changes.dart';
import 'package:dart_wallet_v2/screens/wallet/home.dart';
import 'package:dart_wallet_v2/screens/wallet/wallet.dart';
import 'package:flutter/material.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

class Globals with ChangeNotifier {
  Map<String, int> currencyMapping = {'USD': 2, 'CHF': 1, 'EUR': 0};

  Map<int, String> currencyMappingReverse = {2: 'USD', 1: 'CHF', 0: 'EUR'};

  Map<int, String> currencyMappingReverseSymbols = {2: '\$', 1: '₣', 0: '€'};

  int _selectedCurrency = 2;

  int get selectedCurrency => _selectedCurrency;

  set selectedCurrency(int value) {
    _selectedCurrency = value;
  }

  String _editTagValue = "";
  int _editTagIndex = -1;

  int get editTagIndex => _editTagIndex;

  set editTagIndex(int value) {
    _editTagIndex = value;
  }

  String get editTagValue => _editTagValue;

  set editTagValue(String value) {
    _editTagValue = value;
  }

  List<String> _restoreNewWalletsWords = [];

  List<String> get restoreNewWalletsWords => _restoreNewWalletsWords;

  set restoreNewWalletsWords(List<String> value) {
    _restoreNewWalletsWords = value;
    super.notifyListeners();
  }

  List<String> wallets = [];

  List<String> _generatedWordsPreInitWallet = [];

  List<String> get generatedWordsPreInitWallet => _generatedWordsPreInitWallet;

  set generatedWordsPreInitWallet(List<String> value) {
    _generatedWordsPreInitWallet = value;
  }

  String _walletPassword = "";

  String get walletPassword => _walletPassword;

  set walletPassword(String value) {
    _walletPassword = value;
  }

  int _selectedWalletIndex = -1;

  int get selectedWalletIndex => _selectedWalletIndex;

  set selectedWalletIndex(int value) {
    _selectedWalletIndex = value;
  }

  Map<String, dynamic> _kb = {};

  Int8List _bytes = Int8List(0);

  String _crc = "";

  String _walletAddress = "";

  Map<String, dynamic> get kb => _kb;

  set kb(Map<String, dynamic> value) {
    _kb = value;
  }

  String _walletName = "";

  String get walletName => _walletName;

  set walletName(String value) {
    _walletName = value;
  }

  TkmMetadata _tkmMetaData = TkmMetadata();

  TkmMetadata get tkmMetaData => _tkmMetaData;

  set tkmMetaData(TkmMetadata value) {
    _tkmMetaData = value;
  }

  StakeNodeList _snl = StakeNodeList([]);

  StakeNodeList get snl => _snl;

  set snl(StakeNodeList value) {
    _snl = value;
  }

  String _sith = "";

  String get sith => _sith;

  set sith(String value) {
    _sith = value;
  }

  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  set currentIndex(int value) {
    _currentIndex = value;
  }

  TransactionInput _ti = TransactionInput("");

  TransactionInput get ti => _ti;

  set ti(TransactionInput value) {
    _ti = value;
  }

  FeeBean _feeBean = FeeBean();

  FeeBean get feeBean => _feeBean;

  set feeBean(FeeBean value) {
    _feeBean = value;
  }

  BalanceResponseBean _brb = BalanceResponseBean(
      "", BigInt.from(0), BigInt.from(0), null, null, 0, "");

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

  Int8List get bytes => _bytes;

  set bytes(Int8List value) {
    _bytes = value;
  }

  String get crc => _crc;

  set crc(String value) {
    _crc = value;
  }

  String get walletAddress => _walletAddress;

  set walletAddress(String value) {
    _walletAddress = value;
  }

  bool _isLoginSign = false;


  bool get isLoginSign => _isLoginSign;

  set isLoginSign(bool value) {
    _isLoginSign = value;
  }

  void resetAndOpenPage(context) {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(
          builder: (BuildContext context) => Wallet(walletName)),
      ModalRoute.withName('/'),
    );
  }

  void resetAndGoToRoot(context) {
    Navigator.pushAndRemoveUntil<void>(
      context,
      MaterialPageRoute<void>(builder: (BuildContext context) => const Home()),
      ModalRoute.withName('/'),
    );
  }
}
