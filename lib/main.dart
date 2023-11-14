import 'package:dart_wallet_v2/config/database/metatransaction.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:io_takamaka_core_wallet/io_takamaka_core_wallet.dart';

import 'app.dart';
import '/screens/splash/splash_state.dart';

Future<void> main() async {
  //Hive init
  String path = (await FileSystemUtils.getWalletDir("wallets")).path;
  Hive
    ..init(path)
    ..registerAdapter(MetatransactionAdapter());
  debugPaintSizeEnabled = false;
  runAppWithOptions(
    envFileName: '.env',
    splashState: SplashState(),
  );
}
